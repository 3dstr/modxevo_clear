#!/bin/bash
#https://habrahabr.ru/post/188878/

search_dir=$(pwd)

echo "------------------"
echo ">>>>git status:"

git status

echo "------------------"
echo ">>>>last modifed php:"
echo "find . -type f -name '*.php' -not -name 'docid*' -printf '%T@ %p\n' | sort -n | tail -30 (| xargs rm -rf)"
find . -type f -name '*.php' -not -name "docid*" -printf '%T@ %p\n' | sort -n | tail -30 | cut -f2- -d" "

echo ">>>>last created  100 day:"
echo "find -ctime -100 -type f -name '*.php' -not -name 'docid*' | sort -n | tail -30"
find . -ctime -100 -type f -name '*.php' -not -name "docid*" | sort -n | tail -30

echo "------------------"
echo ">>>>find in 7777:"

writable_dirs=$(find $search_dir -type d -perm 0777)

for dir in $writable_dirs
do
    echo "${dir}"
    find $dir -type f -name '*.php'
    find $dir -type f -name '*.php' | xargs grep -l "eval *" --color
    find $dir -type f -name '*.php' | xargs grep -l "base64_decode *" --color
    find $dir -type f -name '*.php' | xargs grep -l "gzinflate *" --color
#    find $dir -type f -name '*.php' | xargs grep -l "GLOBALS *" --color
done


#find . -type f -name '*.php' | xargs grep -l "eval *" --color
#find . -type f -name '*.php' | xargs grep -l "base64_decode *" --color
#find . -type f -name '*.php' | xargs grep -l "gzinflate *(" --color


echo ">>>>All delete?[y/n]:" 
read YES

if [ "$YES" == "y" ]; 

then 

#echo ">>>>>>>NO. Exit<<<<<<"; exit 1; fi


for dir in $writable_dirs
do
    echo $dir
    find $dir -type f -name '*.php' | xargs rm -rf
    find $dir -type f -name '*.php' | xargs grep -l "eval *" --color | xargs rm -rf 
    find $dir -type f -name '*.php' | xargs grep -l "base64_decode *" --color | xargs rm -rf 
    find $dir -type f -name '*.php' | xargs grep -l "gzinflate *" --color | xargs rm -rf 
done


fi


echo ">>>>set right chmod?[y/n]:" 
read YES

if [ "$YES" = "y" ]; then


#echo "!---------------UPDATE CHMOD----------------------!" 

#chown -R $USERNAME:$USERNAME $PATHNEW

find $search_dir -type d -exec chmod 755 {} \; ;STATUS
find $search_dir -type f -exec chmod 644 {} \; ;STATUS

find $search_dir/assets/cache -name "*.php" -not -name "siteCache.idx.php" -not -name "sitePublishing.idx.php" -delete

#if [ -f "$PATHNEW" ]; then find $PATHNEW/webstat -delete ; fi
#if [ -f "$PATHNEW" ]; then find $PATHNEW/cgi-bin -delete ; fi

chmod -R 777 $search_dir/assets/cache
chmod -R 777 $search_dir/assets/export
chmod -R 777 $search_dir/assets/files
chmod -R 777 $search_dir/assets/galleries
chmod -R 777 $search_dir/assets/images
chmod -R 777 $search_dir/assets/media
chmod -R 777 $search_dir/assets/flash
chmod -R 777 $search_dir/assets/cache/siteCache.idx.php
chmod -R 777 $search_dir/assets/cache/sitePublishing.idx.php
chmod -R 666 $search_dir/manager/includes/config.inc.php

chmod 755 $search_dir 

chmod 777 $search_dir/assets/plugins/managermanager/mm_rules.inc.php
chmod -R 777 $search_dir/assets/.thumbs
chmod -R 777 $search_dir/assets/backup

rm $search_dir/index-ajax.php

echo "CHMOD OK" 


else

echo ">>>>set read only?[y/n]:" 
read YES

if [ "$YES" != "y" ]; then echo ">>>>>>>NO. Exit<<<<<<"; exit 1; fi

#echo "!---------------UPDATE CHMOD----------------------!" 

#find $search_dir/assets -type d -exec chmod o+x {} \;

find $search_dir -type d -exec chmod 755 {} \;
chmod -R 777 $search_dir/assets/cache

find $search_dir -type f -exec chmod 644 {} \;
chmod -R 666 $search_dir/manager/includes/config.inc.php

ls . -l

fi
