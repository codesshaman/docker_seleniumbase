# SeleniumAuth

*Все описанные шаги работают в unix-системах с установленной утилитой make*

## Step 0. Clone reposytory

``git clone git@gitlab.askona.ru:dp-data-platform/seleniumauth.git``

``cd seleniumauth``

## Step 1. Create virtual environment

Command use only for first launch!

``make env``

This command create ``.env`` file by means of ``environment.sh`` script

## Step 3. Container build

Run

``make build``

Wait and relax!

## Step 4. Check building

Use 

``make ps``

To check launch container status

