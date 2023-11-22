#!/bin/sh 

#Get the Unstable env up.
#Install the required packages:

sudo apt install devscripts git git-buildpackage lintian
#Create an account on Salsa- Debian’s Gitlab instance.
#Add the following to you .bashrc or .zshrc:
export DEBEMAIL=nwekegodwin65@gmail.com
export DEBFULLNAME='Godwin Nweke'
alias lintian='lintian -iIEcv --pedantic --color auto'
alias git-import-dsc='git-import-dsc --author-is-committer --pristine-tar'
alias clean='fakeroot debian/rules clean'


mkdir node-cookie-container
cd node-cookie-container
gbp clone --pristine-tar git@salsa.debian.org:mr.winz/node-cookie.git 

#Using git to clone instead of gbp
git clone git@salsa.debian.org:js-team/node-cookie.git 
git checkout upstream 
git checkout pristine-tar 
git checkout master 

#Next cd into the directory and download the new upstream release tarball using the command:
cd node-cookie
uscan --verbose

#Get the source from previous version incase you don't have the debian dir.. you can then copy from previous and modify
#apt source node-yaml

#If you used uscan to download the tarballs you should see a tarball named package-name_upstream-version.orig.tar.gz in the directory, you cloned the repo in. Import the orig.tar.gz using:
gbp import-orig --pristine-tar ../node-cookie_3.3.9.orig.tar.gz
#../node-yaml_2.3.3.orig.tar.gz 
#

#We need to tell the operating system that we have imported a new version into the repo. 
#We do that by adding an entry in the debian/changelog file. 
#We do so by running the following command: 
gbp dch -a

#What this will do is add an entry to debian/changelog file that looks something like this:

########################################################################
##ruby-health-check (3.0.0-1) UNRELEASED; urgency=medium			####
##																	####
##    * New upstream version 3.0.0									####
##    																####
##-- Abraham Raji <avronr@tuta.io>  Thu, 13 Aug 2020 16:17:14 +0000 ####
########################################################################

#Install build dependency 
sudo apt build-dep node-cookie 

#Now we build. Run:
dpkg-buildpackage

#Next, we look for policy violations using lintian. When you successfully build a package a file named package-name_version-number_debian-revision-architecture.changes is generated in the parent directory which if you pass it on as an argument to lintian will give you all the warnings and errors. Run
lintian ../node-yaml_2.3.3_amd64.changes

#Now remember 
gbp dch -a
#? once you’ve satisfied Lintian run it again. 
#Now if you look at the changelog you’ll find that all of your commit messages are listed as entries in the changelog. 
#Check if there are any duplicates and remove them. Now change the UNRELEASEDin the header to unstable. 
#Now your changelog should look something like this:

######################################################################
##																		##
## ruby-health-check (3.0.0-1) unstable; urgency=medium					##
##																		##
##     * Team Upload													##
##     * New upstream version 3.0.0										##
##     * Bumps debhelper-compat version to 13							##
##     * Bumps standards version to 4.5.0								##
##     * Added Rules-Requires-Root: no									##
##																		##
## -- Abraham Raji <avronr@tuta.io>  Thu, 13 Aug 2020 16:17:14 +0000	##
##																		##
######################################################################

#Remove autogenerate build file not required to be committed
debclean

git rebase -i HEAD~4

#Use gpb with sbuild as alternate to sbuild
gbp buildpackage

#Build in clean environment
sbuild

#Prepare to push
dch -r -D experimental 

git remote -v
git remote set-url origin git@salsa.debian.org:mr.winz/node-cookie.git 
git push -u --all --follow-tags

#Create merge request for forwarding patches to upstream
https://salsa.debian.org/mr.winz/node-cookie/-/merge_requests/new?merge_request%5Bsource_branch%5D=upstream%2Flatest
https://salsa.debian.org/mr.winz/node-yaml/-/merge_requests/new?merge_request%5Bsource_branch%5D=upstream

#Create merge request for patches for 
#https://salsa.debian.org/mr.winz/node-cookie/-/merge_requests/new?merge_request%5Bsource_branch%5D=pristine-tar