#!/bin/bash 

gpg --full-gen-key

gpg --export-secret-keys --armor "Godwin Nweke" > secret-key-backup.asc

gpg --export-ownertrust > trustdb-backup.txt

gpg --list-secret-keys --keyid-format LONG nwekegodwin65@gmail.com

echo ""
echo ""

read -p "Enter your GPG key ID: " key

git config --global user.signingkey $key

git config --global commit.gpgsign true 

gpg --export -a $key > gnupg-key.asc

echo ""
echo ""

cat gnupg-key.asc | tee uploadable-keys.txt
echo -e "\n\n" | tee -a uploadable-keys.txt

echo ""
echo ""

ssh-keygen -t ed25519 -C "nwekegodwin65@gmail.com"

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_ed25519

echo ""
echo ""

cat ~/.ssh/id_ed25519.pub | tee -a uploadable-keys.txt
echo -e "\n\n" | tee -a uploadable-keys.txt

echo ""
echo ""