#!/bin/bash

VERSIONS="buster|bullseye|bookworm"
BRANCHES="stable|devel|staging"

if [ "${UID}" -eq 0 ] ; then

ARCH=$(dpkg --print-architecture)

  if [ "${ARCH}" == "amd64" ] ; then
  
    echo "Adding i386 architecture..."
    dpkg --add-architecture i386
    
    echo -n "Select a version [${VERSIONS}]: " && read VERSION
    
    if echo ${VERSIONS} | grep "${VERSION}" >/dev/null 2>&1 ; then
    
      echo "deb https://dl.winehq.org/wine-builds/debian/ ${VERSION} main" >> /etc/apt/sources.list.d/winehq.list
      
      echo "Downloading and adding public key to APT repository..."
      wget -nc https://dl.winehq.org/wine-builds/winehq.key >/dev/null 2>&1
      apt-key add winehq.key >/dev/null 2>&1
      rm winehq.key
      
      echo "Updating repositories..."
      apt update >/dev/null 2>&1
      
    else
    
      echo "${VERSION} is not a valid entry"
      
    fi
    
    echo -n "Select a branch [stable|devel|staging]: " && read BRANCH
    
    if echo ${BRANCHES} | grep "${BRANCH}" >/dev/null 2>&1 ; then
    
      echo "Installing Wine ${BRANCH}..."
      apt install --install-recommends winehq-${BRANCH}
    
    fi
    
  else
  
    if [ "${ARCH}" -ne "i386" ] ; then
      echo "Wine is not supported yet for ${ARCH}"
    fi
    
  fi
  
else
  
  echo "You must run this script as superuser."
  
fi