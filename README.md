# SeleniumAuth

*Все описанные шаги работают в unix-системах с установленной утилитой make*

## Step 0. Clone reposytory

``git clone https://github.com/codesshaman/docker_seleniumbase.git``

``cd docker_seleniumbase``

## Step 1. Create virtual environment

Command use only for first launch!

``make env``

This command create ``.env`` file by means of ``environment.sh`` script

## Step 3. Container build

Run

``make build``

Wait and relax!

## Step 4. Launch your script

Put your selenium script to ``sbase/scripts`` folder and run 

``make run <scriptname> <scriptargs>``

For launch this script. If your script launch
without arguments, you can use just 

``make run <scriptname>``
