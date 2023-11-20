#!/bin/sh 

gpg --import secret-key-backup.asc

gpg --import-ownertrust < trustdb-backup.txt
