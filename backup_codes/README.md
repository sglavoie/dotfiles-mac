# Backup codes and recovery keys

`codes-and-keys.txt.age` is encrypted with [age](https://age-encryption.org)
to one dedicated key. Either of these unlocks it:

- **The key file** `~/.config/age/backup-codes.key` (mode 600, never committed):
  decryption is automatic on a Mac that has it.
- **The passphrase**: `identity.age` is that same key encrypted with a
  passphrase, so any machine with `age` can decrypt by typing it.

`recipient.txt` is the key's public half, used to re-encrypt after an edit.

## Usage (from the repo root)

```bash
just codes-show     # print the codes
just codes-edit     # edit in $VISUAL/$EDITOR, then re-encrypt; commit the result
just codes-unlock   # new machine: recover the key file from identity.age
```

Without the repo tooling, the passphrase alone is enough:

```bash
age -d -i identity.age codes-and-keys.txt.age
```

`scripts/backup-codes.sh` also has `init` (create the key, `recipient.txt` and
`identity.age`) and `migrate` (convert the old ansible-vault file without
writing plaintext to disk), used once when moving off ansible-vault.

`edit` decrypts to a mode-600 temporary file, removed on exit; with vim or
Neovim it also disables swap, undo, backup and shada files for that session.
