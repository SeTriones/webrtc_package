#!/bin/bash -e

dir=${PWD}/package
objdir=${dir}/lib
headerdir=${dir}/include
rm -rf ${dir}
mkdir -p ${dir}
mkdir -p ${objdir}
mkdir -p ${headerdir}

find src/webrtc src/chromium/src/third_party/jsoncpp -name *.h -exec cp --parents '{}' ${headerdir} ';'
mv ${headerdir}/src/* ${headerdir}
mv ${headerdir}/chromium/src/third_party/jsoncpp/source/include/* ${headerdir}
rm -rf ${headerdir}/src ${headerdir}/chromium
cd ./src/out/Default/obj/
#find . -name "*.o" |grep -v unittest | grep -v "/webrtc/test" | grep -v "/testing/" | xargs -t -i ar -crs ${objdir}/libwebrtc_full.a {} 1>log 2>&1
#find . -name "*.o" |grep -v unittest | grep -v "/webrtc/test" | grep -v "/testing/" | xargs -t -i cp --backup=existing --suffix=.old {} ${objdir}
#find . -name "*.a" | xargs -t -i cp --backup=existing --suffix=.old {} ${objdir}/"$(basename "$(dirname {})")".{}
lst=(`find . -name "*.o" |grep -v unittest | grep -v "/webrtc/test" | grep -v "/testing/" | grep -v "_test"`)
for file in ${lst[@]}; do
	echo ${file}
	p="$(basename "$(dirname ${file})")"
	f=`basename ${file}`
	newfile=${p}.${f}
	cp --backup=existing --suffix=.old ${file} ${objdir}/${newfile}
done
cd ${objdir}
ar -crs libwebrtc_full.a *.o
