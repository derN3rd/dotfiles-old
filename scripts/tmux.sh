#!/usr/bin/env bash

print_help() {
    echo "
Usage: tt name [command [command [command [command [command]]]]]

       Starts a new tmux session with a template.
       Templates exist for 2, 3 and 5 panes.
       Each pane can receive an initial command.

Templates:

       e      1 big editor pane split in half, 1 small console
       d      1 main window, 4 consoles
       3      1 big window, 2 unequal consoles"
}

if [[ -z $1 ]]; then
    print_help
    exit
fi

SESSIONNAME="$(pwd | sed 's/\W/_/g')_$1"

tmux has-session -t =$SESSIONNAME

if [ $? != 0 ]; then
    if [[ $1 = "d" ]]; then
        tmux new-session -s $SESSIONNAME -d
        tmux split-window -h -p 33 -t $SESSIONNAME
        tmux split-window -v -p 50 -t $SESSIONNAME
        tmux select-pane -t 1
        tmux split-window -v -p 33 -t $SESSIONNAME
        tmux split-window -h -p 50 -t $SESSIONNAME
        tmux select-pane -t 1
    elif [[ $1 = "3" ]]; then
        tmux new-session -s $SESSIONNAME -d
        tmux split-window -h -p 20 -t $SESSIONNAME
        tmux split-window -v -p 35 -t $SESSIONNAME
        tmux select-pane -t 2
        tmux select-pane -t 1
    elif [[ $1 = "e" ]]; then
        tmux new-session -s $SESSIONNAME -d
        tmux split-window -v -p 15 -t $SESSIONNAME
        tmux select-pane -t 1
        tmux send-keys -t $SESSIONNAME:1.1 "$EDITOR ." C-m
        tmux send-keys -t $SESSIONNAME:1.1 C-x 3 C-m
    else
        print_help
        exit
    fi

    [[ -n $2 ]] && tmux send-keys -t $SESSIONNAME:1.1 "$2" C-m
    [[ -n $3 ]] && tmux send-keys -t $SESSIONNAME:1.2 "$3" C-m
    [[ -n $4 ]] && tmux send-keys -t $SESSIONNAME:1.3 "$4" C-m
    [[ -n $5 ]] && tmux send-keys -t $SESSIONNAME:1.4 "$5" C-m
    [[ -n $6 ]] && tmux send-keys -t $SESSIONNAME:1.5 "$6" C-m
fi

tmux attach -t $SESSIONNAME
