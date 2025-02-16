update_prompt() {
  VIM_STATUS_INDICATOR=$(jobs | grep -q 'vim' && echo "#" || echo "$")
  PS1=""\[\e[3;90m\]\u@\h:\W ${VIM_STATUS_INDICATOR} \[\e[0m\]"
}

export PROMPT_COMMAND=update_prompt
