#!/bin/bash
# Download and configure the following
#
# Java SDK
# Apache Ant
# Android
# NPM
# Apache Cordova
# Ionic Framework

HOME_PATH=$(cd ~/ && pwd)
INSTALL_PATH=/opt
ANDROID_SDK_PATH=/opt/android-sdk
NODE_PATH=/opt/node

# x86_64 or i386
LINUX_ARCH="$(lscpu | grep 'Architecture' | awk -F\: '{print $2}' | tr -d ' ')"

# Latest Android Linux SDK for x64 and x86 as of 16-03-2016
ANDROID_SDK_X64="http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz"
ANDROID_SDK_X86="http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz"

# Latest NodeJS for x64 and x86 as of 16-10-2016
NODE_X64="http://nodejs.org/dist/latest/node-v5.8.0-linux-x64.tar.gz"
NODE_X86="http://nodejs.org/dist/latest/node-v5.8.0-linux-x86.tar.gz"

# Update all Ubuntu Software repository lists
apt-get update

cd ~/Desktop

if [ "$LINUX_ARCH" == "X86_64" ]; then

	wget "$NODE_x64" -O "nodejs.tgz"
	wget "$ANDROID_SDK_X64" -O "android-sdk.tgz"

	tar zxf "nodejs.tgz" -C "$INSTALL_PATH"
	tar zxf "android-sdk.tgz" -C "$INSTALL_PATH"

	cd "$INSTALL_PATH" && mv "android-sdk-linux" "android-sdk"
	cd "$INSTALL_PATH" && mv "node-v0.10.32-linux-x64" "node"

	# Android SDK requires some x86 architecture libraries even on x64 system
	apt-get install -qq -y libc6 i386 libgcc:i386 libstdc++6:i386 libz1:i386

else

	wget "$NODE_X86" -O "nodejs.tgz"
	wget "$ANDROID_SDK_X86" -O "android-sdk.tgz"

	tar zxf "nodejs.tgz" -C "$INSTALL_PATH"
	tar zxf "android-sdk.tgz" -C "$INSTALL_PATH"

	cd "$INSTALL_PATH" && mv "android-sdk-linux" "android-sdk"
	cd "$INSTALL_PATH" && mv "node-v0.10.32-linux-x86" "node"
fi

cd "$INSTALL_PATH" && chown root:root "android-sdk" -R
cd "$INSTALL_PATH" && chmod 777 "android-sdk" -R

cd ~/

# Add Android and NPM paths to the profile to preserve settings on boot
echo "export PATH=\$PATH:$ANDROID_SDK_PATH/tools" >> ".profile"
echo "export PATH=\$PATH:$ANDROID_SDK_PATH/platform-tools" >> ".profile"
echo "export PATH=\$PATH:$NODE_PATH/bin" >> ".profile"

# Add Android and NPM paths to the temporary user path to complete installation
export PATH=$PATH:$ANDROID_SDK_PATH/tools
export PATH=$PATH:$ANDROID_SDK_PATH/platform-tools
export PATH=$PATH:$NODE_PATH/bin

# Install JDK and Apache Ant
apt-get -qq -y install default-jdk ant

# Install Apache Cordova and Ionic Framework
npm install -g cordova
npm install -g ionic

# Clean up any files that were downloaded from the internet
cd ~/Desktop && rm "android-sdk.tgz"
cd ~/Desktop && rm "nodejs.tgz"

echo "-------------------------------------------------------"
echo "Restart your Ubuntu session for installation to complete......."
