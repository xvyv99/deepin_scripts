#!/bin/sh

CleanUp() {
    rm -rf /tmp/deepin_*
}

Failed() {
    echo "\033[1;32mfailed!\033[0m"
}

Done() {
    echo "\033[1;32mdone.\033[0m"
}

Red() {
    echo -n "\033[31m$1\033[0m"
}

Green() {
    echo -n "\033[32m$1\033[0m"
}

Yellow() {
    echo "\033[33m$1\033[0m"
}

BoldBlue() {
    echo "\033[1;34m$1\033[0m"
}

PACKAGE_REPO_URL="https://gh.hitcs.cc/github.com/deepin-community"
package_name=$1

BoldBlue "Testing package ${package_name}."

echo "---" >> /home/deepin/verify.log
echo "${package_name}" >> /home/deepin/verify.log

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
#res=$(sudo apt-get build-dep . --dry-run) #|grep -A 10000 "unmet dependencies")
sudo apt-get build-dep . --dry-run #|grep -A 10000 "unmet dependencies")

status=$?
if [ $status -eq 100 ]; then
    Done
    #Yellow "$res"
    #echo "$res" >> /home/deepin/verify.log
    echo "Unresolvable!!!" >> /home/deepin/verify.log
elif [ $status -eq 0 ]; then
    Done
    Green "No Problem."; echo ""
    echo "No Problem." >> /home/deepin/verify.log
else
    Red "Unknown Error!"
    echo "Error code: $status!" 
    echo "Error code: $status!" >> /home/deepin/verify.log
fi

