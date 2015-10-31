#!/bin/bash

PROGRAMS_HOME=/opt
JAVA_STACK_MIRROR=http://apache.volia.net
MAVEN_VERSION=3.3.1
TMP_DOWNLOAD_DIR=/tmp/egov/download

function action()
{
    local LABEL=$1
    local COMMAND=$2
    local DELIMITER=`for i in {1..80}; do echo -n "="; done`
    echo -e "\n${DELIMITER}\n| ${LABEL}...\n${DELIMITER}"
    eval "${COMMAND}"
    local RESULT=$?
    echo -en "\n${DELIMITER}\n| ...${LABEL} [ "
    if [[ "${RESULT}" == 0 ]]
    then
        tput setaf 2
        echo -n "OK"
    else
        tput setaf 1
        echo -n "FAILED"
    fi
    tput sgr0
    echo -en " ]\n${DELIMITER}\n\n"
    read -n1 -t2 -r -p "" key
}

PKG="apt-get -y --no-install-recommends"

action "Updating all system packages" \
    "${PKG} update"

action "Installing generic tools" \
    "${PKG} install net-tools nano gcc make wget git screen"

JDK_PACKAGE="openjdk-7-jdk"
action "Installing JDK 7" \
    "${PKG} install ${JDK_PACKAGE}"

mkdir -p ${TMP_DOWNLOAD_DIR}
MAVEN_HOME=${PROGRAMS_HOME}/apache-maven-${MAVEN_VERSION}
if [ -e ${MAVEN_HOME} ]
then
    echo "Maven already installed, skipping"
else
    MAVEN_DIST=apache-maven-${MAVEN_VERSION}-bin.tar.gz
    action "Downloading Maven" \
        "wget -nv -P ${TMP_DOWNLOAD_DIR} ${JAVA_STACK_MIRROR}/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_DIST}"
    action "Unpacking Maven" \
        "tar -xzf ${TMP_DOWNLOAD_DIR}/${MAVEN_DIST} -C ${PROGRAMS_HOME}"
    rm -rf ${TMP_DOWNLOAD_DIR}/${MAVEN_DIST}
fi

TOMCAT_VERSION=`wget -qO - ${JAVA_STACK_MIRROR}/tomcat/tomcat-8/ | gawk 'match($0, /">v(.*?)\/</, a) { print a[1] }'`
TOMCAT_HOME=${PROGRAMS_HOME}/apache-tomcat-${TOMCAT_VERSION}
if [ -e ${TOMCAT_HOME} ]
then
    echo "Tomcat already installed, skipping"
else
    TOMCAT_DIST=apache-tomcat-${TOMCAT_VERSION}.tar.gz
    wget -nv -P ${TMP_DOWNLOAD_DIR} ${JAVA_STACK_MIRROR}/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/${TOMCAT_DIST}
    tar -xzf ${TMP_DOWNLOAD_DIR}/${TOMCAT_DIST} -C ${PROGRAMS_HOME}
    rm ${TMP_DOWNLOAD_DIR}/${TOMCAT_DIST}
fi

action "Installing Redis" \
    "${PKG} install redis-server"

action "Installing Nginx" \
    "${PKG} install nginx"

if [ ! `npm -v 2>/dev/null` ]
then
    action "Downloading npm and nodejs PPM" \
        "curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -"
    action "Installing NodeJS" \
        "${PKG} install nodejs"
    action "Installing NodeJS package build tool" \
        "${PKG} install build-essential"
fi

action "[npm] Updating global npm modules" \
    "npm -g update"

action "[npm] Installing Bower" \
    "npm install -g bower"

action "[npm] Installing Grunt" \
    "npm install -g grunt-cli"

action "[npm] Installing Yeoman" \
    "npm install -g yo"

action "Installing ruby" \
    "${PKG} install ruby"
action "[npm] Installing gem" \
    "npm install -g gem"

action "[gem] Installing SASS plugin" \
    "gem install sass"
