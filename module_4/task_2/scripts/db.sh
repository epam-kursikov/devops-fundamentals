#!/bin/bash

dbName=users.db
dbPath=./../data
dbFullPath="$dbPath/$dbName";

if [[ "$#" -gt 0 && "$1" != "help" && "$1" != "restore" && ! -f "$dbFullPath" ]];
then
    read -p "DB file does not exist. Do you want to create it? [y/n] " answer
    if [[ "$answer" == "y" ]];
    then
        touch $dbFullPath
    else
        echo "DB file will not be created, operation cancelled."
        exit 0
    fi
fi

function validate {
  if [[ $1 =~ ^[a-zA-Z]+$ ]];
  then
    return 0;
  else
    return 1;
  fi
}


add () {
  echo Enter user name
  read name
  validate $name
  if [[ "$?" == 1 ]];
  then
    echo "Name is invalid. It must have only latin letters."
    exit 1
  fi
  
  echo Enter user role
  read role
  validate $role
  if [[ "$?" == 1 ]];
  then
    echo "Role is invalid. It must have only latin letters."
    exit 1
  fi
  echo  $name, $role >> $dbFullPath
}

function backup {
  backupName=$(date +'%Y-%m-%d-%H-%M-%S')-$dbName.backup
  cp $dbFullPath $dbPath/$backupName

  echo "Backup $backupName has been created."
}

function restore {
  latestBackup=$(ls $dbPath/*-$dbName.backup | tail -n 1)

  if [[ ! -f $latestBackup ]];
  then
    echo "No backup file found."
    exit 0
  fi

  cp $latestBackup $dbFullPath

  echo "Backup is restored from $latestBackup."
}

function find {
  read -p "Enter username to search: " username
  result=$(grep "$username, *" $dbFullPath)

  if [[ "$result" == '' ]];
  then
    echo "User $username not found."
    exit 1
  else
    echo "$result"
  fi
}

inverse="$2"
function list {
  if [[ $inverse == "--inverse" ]]
  then
    cat --number $dbFullPath | tac
  else
    cat --number $dbFullPath
  fi
}

help () {
  echo "add       Adds new user to the DB"
  echo "backup    Creates a backup of the DB"
  echo "restore   Restore DB from the latest backup"
  echo "find      Finds user by username"
  echo "list      Prints all users"
}

case $1 in
  add) add ;;
  backup) backup ;;
  restore) restore ;;
  find) find ;;
  list) list ;;
  help | *) help ;;
esac
