#!/bin/sh

su $WORKSPACE_USER -c "${1:-tmux}"
