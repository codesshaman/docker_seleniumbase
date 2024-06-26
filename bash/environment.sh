#!/bin/bash

cp .env.example .env
echo -e "USER_ID=$(id -u)" >> .env
echo -e "GRUP_ID=$(id -g)" >> .env
git clone https://github.com/seleniumbase/SeleniumBase.git