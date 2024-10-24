#!/bin/sh

CleanUp() {
    rm -rf /tmp/deepin_*
}

Failed() {
    echo -e "\033[1;32mfailed!\033[0m"
}

Done() {
    echo -e "\033[1;32mdone.1\033[0m"
}

Red() {
    echo -n "\033[31m$1\033[0m"
}

Green() {
    echo -ne "\033[32m$1\033[0m"
}

Yellow() {
    echo -e "\033[33m$1\033[0m"
}

BoldBlue() {
    echo -e "\033[1;34m$1\033[0m"
}

PACKAGE_REPO_URL="https://gh.hitcs.cc/github.com/deepin-community"
package_name=$1

BoldBlue "Testing package ${package_name}."

echo "---" >> verify.log
echo "${package_name}" >> verify.log

Green "Creating repo folder..."
cd /tmp/
mkdir "deepin_${package_name}"

if [ $? -ne 0 ]; then
    Failed
    Red "Failed to directory deepin_${package_name}!"
    echo "Failed to directory deepin_${package_name}!" >> /home/deepin/verify.log
    exit 64
else
    Done
fi

Green "Cloning repo..."
cd "deepin_${package_name}"
git clone "${PACKAGE_REPO_URL}/${package_name}"

if [ $? -ne 0 ]; then
    Failed
    Red "Failed to cloning ${package_name}!"
    echo "Failed to cloning ${package_name}!" >> /home/deepin/verify.log
    CleanUp
    exit 64
else
    Done
fi

Green "Checking dep..."
cd "${package_name}"
res=$(sudo apt-get build-dep . --dry-run|grep -A 10000 "unmet dependencies")

if [ $? -ne 100 ]; then
    Done
    Yellow "$res"
    echo "$res" >> /home/deepin/verify.log
elif [ $? -ne 0 ]; then
    Done
    Green "No Problem"; echo ""
else
    Red "Unknown Error!"
    echo "Failed to cloning ${package_name}!" >> /home/deepin/verify.log
fi

CleanUp