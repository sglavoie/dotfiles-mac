if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

if [[ -d "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi
