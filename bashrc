update_prompt() {
  # The "correct" way, which takes quite a while though.
  # CONDA_ENV=$(conda env list | grep '\*' | awk '{print $1}')
  CONDA_ENV=$CONDA_DEFAULT_ENV
  VIM_STATUS_INDICATOR=$(jobs | grep -q 'vim' && echo "#" || echo "$")
  PS1=""\[\e[3;90m\](${CONDA_ENV}) \u@\h:\W ${VIM_STATUS_INDICATOR} \[\e[0m\]"
}

export PROMPT_COMMAND=update_prompt
