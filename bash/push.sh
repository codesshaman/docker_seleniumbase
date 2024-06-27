#!/bin/bash

git status

read -p "Хотите выполнить пуш? (y/n): " answer

if [[ $answer == "y" || $answer == "Y" ]]; then
    git add .
    git status
    read -p "Введите коммит: " commit_message
    git commit -m "$commit_message"
    git push
fi

git status