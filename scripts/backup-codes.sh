#!/usr/bin/env bash
# Read and edit the age-encrypted backup codes in backup_codes/.
#
# The codes are encrypted once, to a dedicated age key. Two things unlock them:
#   - the key itself at ~/.config/age/backup-codes.key (automatic on this Mac)
#   - backup_codes/identity.age, the same key encrypted with a passphrase, so a
#     machine without the key file can still decrypt by typing the passphrase
#
# Usage: backup-codes.sh show | edit | unlock | init | migrate
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dir="$repo_root/backup_codes"
codes="$dir/codes-and-keys.txt.age"
recipient_file="$dir/recipient.txt"
protected_key="$dir/identity.age"
vault="$dir/codes-and-keys.txt"
key="${BACKUP_CODES_KEY:-$HOME/.config/age/backup-codes.key}"

die() {
	echo "backup-codes: $*" >&2
	exit 1
}

command -v age >/dev/null || die "age is not installed (brew install age)"

# Prefer the local key; fall back to the passphrase-protected copy, which makes
# age prompt for the passphrase.
identity() {
	if [[ -r "$key" ]]; then
		printf '%s\n' "$key"
	elif [[ -r "$protected_key" ]]; then
		printf '%s\n' "$protected_key"
	else
		die "no key at $key and no $protected_key; run init first"
	fi
}

decrypt() {
	[[ -r "$codes" ]] || die "$codes does not exist; run migrate or init first"
	age --decrypt --identity "$(identity)" "$codes"
}

# Encrypt stdin to the recipient, replacing the codes file only on success.
encrypt_to_codes() {
	[[ -r "$recipient_file" ]] || die "$recipient_file does not exist; run init first"
	age --encrypt --armor --recipients-file "$recipient_file" --output "$codes.tmp"
	mv -f "$codes.tmp" "$codes"
}

cmd_show() {
	decrypt
}

# Plaintext scratch file for edit; global so the EXIT trap can still see it
# after cmd_edit returns.
tmp=""
cleanup() {
	[[ -n "$tmp" && -e "$tmp" ]] && { rm -P "$tmp" 2>/dev/null || rm -f "$tmp"; }
	return 0
}
trap cleanup EXIT
trap 'exit 130' INT TERM HUP

cmd_edit() {
	local before
	tmp="$(umask 077 && mktemp "${TMPDIR:-/tmp}/backup-codes.XXXXXX")"
	decrypt >"$tmp"
	before="$(shasum -a 256 <"$tmp")"

	local editor="${VISUAL:-${EDITOR:-vi}}"
	case "$(basename "${editor%% *}")" in
	# Keep plaintext out of swap, undo, backup and shada/viminfo files.
	nvim | vim | vi) $editor -n -i NONE --cmd 'set noundofile nobackup nowritebackup' "$tmp" ;;
	*) $editor "$tmp" ;;
	esac

	if [[ "$(shasum -a 256 <"$tmp")" == "$before" ]]; then
		echo "backup-codes: unchanged"
		return
	fi
	encrypt_to_codes <"$tmp"
	echo "backup-codes: re-encrypted ${codes#"$repo_root"/}; commit it"
}

# On a new machine: recover the local key from the passphrase-protected copy.
cmd_unlock() {
	[[ -e "$key" ]] && die "$key already exists"
	[[ -r "$protected_key" ]] || die "$protected_key does not exist"
	mkdir -p "$(dirname "$key")"
	(umask 077 && age --decrypt "$protected_key" >"$key.tmp")
	mv -f "$key.tmp" "$key"
	echo "backup-codes: wrote $key"
}

# One-time: create the key, its public recipient, and the passphrase copy.
cmd_init() {
	[[ -e "$key" ]] && die "$key already exists"
	mkdir -p "$(dirname "$key")"
	(umask 077 && age-keygen --output "$key" 2>/dev/null)
	age-keygen -y "$key" >"$recipient_file"
	echo "backup-codes: choose the passphrase that unlocks identity.age"
	age --encrypt --passphrase --armor --output "$protected_key" "$key"
	echo "backup-codes: wrote $key, ${recipient_file#"$repo_root"/} and ${protected_key#"$repo_root"/}"
}

# One-time: move the old ansible-vault file to age without touching disk in
# plaintext. ansible-vault runs through uvx, so Ansible need not be installed.
cmd_migrate() {
	[[ -r "$vault" ]] || die "no ansible vault at $vault"
	[[ -e "$codes" ]] && die "$codes already exists"
	command -v uvx >/dev/null || die "uvx is not installed (brew install uv)"
	echo "backup-codes: enter the ansible-vault password"
	local plain
	# Held in memory, and encrypted only once the vault opened successfully.
	plain="$(uvx --quiet --from ansible-core ansible-vault view "$vault")" ||
		die "ansible-vault could not open $vault"
	[[ -n "$plain" ]] || die "the vault decrypted to nothing; refusing to migrate"
	printf '%s\n' "$plain" | encrypt_to_codes
	unset plain
	# Prove the round trip before removing the vault.
	decrypt >/dev/null
	git -C "$repo_root" rm -q "$vault"
	echo "backup-codes: migrated to ${codes#"$repo_root"/}; check with \`just codes-show\`, then commit"
}

case "${1:-}" in
show | edit | unlock | init | migrate) "cmd_$1" ;;
*)
	echo "usage: $(basename "$0") show|edit|unlock|init|migrate" >&2
	exit 2
	;;
esac
