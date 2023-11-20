#!/bin/bash

ENTERED_DIR=0

enterPackageName() {
    echo ""
    echo ""

    read -p "Enter package name: " PACKAGE
    cloneAndDownloadUpstreamTarball
}

cloneAndDownloadUpstreamTarball() {

    if [ $ENTERED_DIR -eq 0 ]; then
        mkdir $PACKAGE-container
        if cd $PACKAGE-container; then
            ENTERED_DIR=1
        fi
    fi

    echo ""
    echo ""

    if ! gbp clone --pristine-tar git@salsa.debian.org:js-team/$PACKAGE.git; then
        echo ""
        echo "Error cloning the repo."
        echo "Check the repo name and try again (Hit Ctrl + C to terminated)"
        enterPackageName
    fi

    cd $PACKAGE

    if ! uscan --verbose; then
        echo ""
        echo "I'm so sorry this shouldn't happen but it did"
        echo "Please try again."
        exit
    fi

    importUpstreamTarballsAndContinue
}

importUpstreamTarballsAndContinue() {
    #Just space between commands output
    echo ""
    echo ""

    read -p "Enter upstream tarball name (Without path): " tarball

    #Just space between commands output
    echo ""
    echo ""

    if ! gbp import-orig --pristine-tar "../$tarball"; then
        echo "Error occured while importing source orig tarball."
        echo "Check the provided file name and try again (Hit Ctrl + C to terminated)"
        importUpstreamTarballsAndContinue
    fi

    gbp dch -a

    sudo apt build-dep $PACKAGE

    dpkg-buildpackage

    debclean

    lintian
}

if ! "$1"; then
    enterPackageName
else
    PACKAGE=$1
    cloneAndDownloadUpstreamTarball
fi
