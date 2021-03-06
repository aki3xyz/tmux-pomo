#!/usr/bin/env bash

# feature
# - [x] p で status-bar で文字入力を行い、その名前のセッションをスタート
# - [x] start time を変数に保存し、差分で残り時間を num で表示する
# - [x] P で stop
# - [ ] pomo-session-time で何分か設定できる
# - [ ] pomo が start してないときに、option で表示した文字列を氷頭する
# - [ ] pomodoro finish 時に、tmux 画面上に時計を出す
# - [ ] pomodoro finish 時に、message 通知を出す
#   - [ ] Mac
#   - [ ] Windows

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR/scripts/helpers.sh

tmux bind-key p run-shell "$CURRENT_DIR/scripts/pomo.sh start"
tmux bind-key P run-shell "$CURRENT_DIR/scripts/pomo.sh stop"

pomo_interpolation=(
  "\#{pomo_status}"
  "\#{pomo_name}"
  "\#{pomo_color}"
)
pomo_commands=(
  "#($CURRENT_DIR/scripts/pomo.sh status)"
  "#($CURRENT_DIR/scripts/pomo.sh name)"
  "#($CURRENT_DIR/scripts/pomo.sh color)"
)


do_interpolation() {
  local all_interpolated="$1"
  for ((i=0; i<${#pomo_commands[@]}; i++)); do
    all_interpolated=${all_interpolated//${pomo_interpolation[$i]}/${pomo_commands[$i]}}
  done
  echo "$all_interpolated"
}

update_tmux_option() {
  local option=$1
  local option_value=$(get_tmux_option "$option")
  local new_option_value=$(do_interpolation "$option_value")
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}
main

