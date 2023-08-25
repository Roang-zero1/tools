#!/usr/bin/bash
# shellcheck disable=2016,2296,2034,2015
# WARNING: Do not edit this file.
# It was generated by processing {{ yadm.source }}

source "${XDG_DATA_HOME}/zinit/zinit.git/zinit.zsh"

zinit light zdharma-continuum/zinit-annex-patch-dl

zinit light-mode for \
  zdharma-continuum/zinit-annex-bin-gem-node

zinit ice wait lucid
zinit snippet OMZP::common-aliases

zinit wait lucid for \
  OMZP::extract

# Install fd from github
zinit wait"1" lucid from"gh-r" as"null" for \
    sbin"fzf"                 junegunn/fzf


if type "fd" >> /dev/null; then
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
fi

zinit ice wait lucid
zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh

# Compatibility fix direnv <> tmux
if [[ -n "${TMUX}" ]] && [[ -n "${DIRENV_DIR}" ]]; then
  # shellcheck disable=2086
  unset ${(Mk)parameters:#DIRENV*}  # unset env vars starting with DIRENV_
fi
# Install direnv from GitHub
zinit wait lucid from"gh-r" as"null" mv"direnv* -> direnv" \
    atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
    sbin"direnv" src="zhook.zsh" for \
        direnv/direnv

zinit wait lucid for \
  as'null' atinit'export PYENV_ROOT="$PWD"' \
  atclone'PYENV_ROOT="$PWD" ./libexec/pyenv init - > zpyenv.zsh' \
  atpull"%atclone" src"zpyenv.zsh" nocompile'!' sbin"bin/pyenv" \
    pyenv/pyenv \
  as-id"pyenv" link \
    is-snippet "${XDG_CONFIG_HOME}/zsh/pyenv.zsh"


zinit wait lucid for \
  from"gh-r" sbin"lazydocker" nocompile if'[[ -n "$commands[docker]" ]]'\
  jesseduffield/lazydocker

zinit ice as"none" sbin"code_connect.py -> code" nocompile
zinit snippet https://raw.githubusercontent.com/chvolkmann/code-connect/main/bin/code_connect.py

zinit wait"1" lucid for\
  pick"misc/quitcd/quitcd.bash_zsh" \
  sbin"nnn" make"O_NERD=1 O_GITSTATUS=1 O_NAMEFIRST=1" \
  atpull"%atclone" atclone"cd ${XDG_CONFIG_HOME}/nnn/plugins && curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh" \
  jarun/nnn\
  is-snippet link "${XDG_CONFIG_HOME}/nnn/env.zsh"

zinit ice wait lucid pip'git+https://github.com/powerline/powerline.git@develop' as"none" id-as"powerline" sbin"venv/bin/powerline" sbin"venv/bin/powerline-config" sbin"venv/bin/powerline-daemon" sbin"venv/bin/powerline-render" sbin"venv/bin/powerline-lint"
zinit load zdharma-continuum/null

zinit ice wait lucid pip'gitline' as"none" id-as"powerline" sbin"venv/bin/gitlint"
zinit load zdharma-continuum/null

zinit light "chrissicool/zsh-256color"

# Improvements for git
zinit ice wait"1" lucid atload"path+=( \$PWD/bin )"
zinit light wfxr/forgit
zinit ice wait"1" lucid as"null" from"gh-r" mv"delta* -> delta" sbin"delta/delta -> delta"
zinit light dandavison/delta

zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

zinit wait lucid nocompile link for  \
  is-snippet "${XDG_CONFIG_HOME}/zsh/config/aliases.zsh" \
  is-snippet "${XDG_CONFIG_HOME}/zsh/config/bindkeys.zsh" \
  is-snippet "${XDG_CONFIG_HOME}/zsh/config/create_dirs.zsh"

# shellcheck disable=2154
if (( $+commands[carapace] )) ; then
  zinit ice wait lucid atclone"carapace _carapace > carapace-generated.zsh" nocompile pick"carapace-generated.zsh" id-as"carapace"
  zinit load zdharma-continuum/null
else
  if [[ ! -e "${XDG_CONFIG_HOME}/.zsh/IGNORE_MISSING_CARAPACE" ]]; then
    printf "\033[0;31m'carapace' binary is missing, install it (https://github.com/rsteube/carapace-bin), or silence this warning with \`touch %s/.zsh/IGNORE_MISSING_CARAPACE\`" "${XDG_CONFIG_HOME}"
  fi
fi

zinit wait lucid for \
  light-mode "Aloxaf/fzf-tab" \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions\
  as-id"yadm" as"completion" \
    is-snippet https://raw.githubusercontent.com/TheLocehiliosan/yadm/master/completion/zsh/_yadm \
  as-id"yadm" as"completion" \
    is-snippet https://raw.githubusercontent.com/jarun/nnn/master/misc/auto-completion/zsh/_nnn

unalias fd 2>/dev/null

# Update history settings to provide larger shared history
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=SAVEHIST=5000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS
setopt incappendhistory
setopt sharehistory
setopt extendedhistory

# Change autosuggestions colour
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=4
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

zinit ice atclone"dircolors -b .dircolors > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}'
zinit light dracula/dircolors

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' query-string ''

# Make fzf searches more usefull
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules"
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

typeset -U path

# Export for tmux
export EDITOR='vim'

[[ -d "${HOME}/.yarn/bin" ]] && path+=("${HOME}/.yarn/bin")
if [[ -d "/usr/local/go" ]]; then
  export GOROOT=/usr/local/go
  export GOPATH="${HOME}/go"
  path+=("${GOROOT}/bin")
fi
