#!/bin/bash

if [[ "$1" -ne "" ]]; then
  ./wg-setup.sh $1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo ". $(pwd)/.bashrc" >> ~/.bashrc
