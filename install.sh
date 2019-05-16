#!/bin/bash
INSTALL_DIR=$(pwd)
PATCH_DIR="${INSTALL_DIR}/patches"
PIHOLE_DATA_DIR="/etc/pihole"
PIHOLE_WEB_DATA_DIR="/var/www/html"
PIHOLE_PATCH="${PATCH_DIR}/pihole"
DNSMASQ_CONFIG_DIR="/etc/dnsmasq.d"
CACHE_DOMAINS_GIT="https://github.com/uklans/cache-domains.git"
CACHE_DOMAINS_DIR="${INSTALL_DIR}/cache-domains"
CACHE_DOMAINS_PATCH="${PATCH_DIR}/cache-domains"

echo "Checking required dependencies..."

echo "Checking pihole..."
PIHOLE=$(which pihole);
out=$?
if [ $out -gt 0 ] ; then
        echo "This script requires pihole to be installed."
        echo "Your package manager should be able to find it"
        exit 1
fi

echo "Checking git..."
GIT=$(which git);
out=$?
if [ $out -gt 0 ] ; then
        echo "This script requires git to be installed."
        echo "Your package manager should be able to find it"
        exit 1
fi

echo "Cloning required repositories..."
$GIT clone $CACHE_DOMAINS_GIT $CACHE_DOMAINS_DIR

echo "Applying patches..."
echo "Patching cache-domains..."
cd $CACHE_DOMAINS_DIR
find "${CACHE_DOMAINS_PATCH}" -name '*.patch' | xargs $GIT apply --whitespace=fix
#for file in "${CACHE_DOMAINS_PATCH}/*.patch"; do
    #[ -f "$file" ] || break
#    $GIT apply $file
#done

echo "Patching PiHole..."
cd $PIHOLE_WEB_DATA_DIR
find "${PIHOLE_PATCH}" -name '*.patch' | xargs $GIT apply --whitespace=fix
#for file in "${PIHOLE_PATCH}/*.patch"; do
    #[ -f "$file" ] || break
    #$GIT apply $file
#	echo $file
#done
