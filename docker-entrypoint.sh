#!/bin/bash

exec /sbin/setuser $WORKSPACE_USER "${1:-tmux}"
