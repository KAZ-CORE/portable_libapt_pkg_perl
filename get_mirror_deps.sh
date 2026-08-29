#!/bin/bash
 
# use or learn more -> https://github.com/KAZ-CORE/libnew_shell  
source libnew_shell

#for public varaible for example (path_temp_deb and path_target and ...)
source conf.sh 



get_deb() {
	
	local security_flag="$3"
	
	color:start ${blue}

	if [[ -n "$security_flag" ]]; then
		local url="${address_mirror}/pool/updates/main/${1}_${2}_${arch}.deb"
	else 
		local url="${address_mirror}/pool/main/${1}_${2}_${arch}.deb"
	fi
	
	printf "${url}\n"
	
	if ! curl -# -w "Downloaded: %{size_download} bytes, Speed: %{speed_download} B/s, Time: %{time_total} seconds\n" -O  "${url}"; then
		color:end
		
		log:failure "get_deb" "not can download ${url}" 
		exit 1
	fi

	color:end
	
	printf "\n" 

	
}

mkdir -p ${path_build}/ ${path_build_target}/ ${extracted}/ ${path_temp_deb}/ ${path_shards_libs}/ ${path_runtime}/ ${path_bin_runtime}/ ${path_lib_runtime}/ ${path_methods_runtime}/ ${path_perl_base}/ ${path_perl5}/

cd ${path_temp_deb}



color:print "1. Downloading Core Packages..." ${purple}


				#path							 							#version

get_deb  "a/apt/apt"									               "3.0.3"
get_deb  "a/apt/libapt-pkg7.0"  	  								   "3.0.3"
get_deb	 "liba/libapt-pkg-perl/libapt-pkg-perl"						   "0.1.42"
get_deb  "p/perl/perl"             									   "5.40.1-6"
get_deb  "p/perl/perl-base"        									   "5.40.1-6"
get_deb  "libx/libxcrypt/libcrypt1"  								   "4.4.38-1"
get_deb  "g/gcc-14/libstdc++6"	  	  								   "14.2.0-19"
get_deb  "g/gcc-14/libgcc-s1"	  	  								   "14.2.0-19"	
get_deb  "b/bzip2/libbz2-1.0"	  	  								   "1.0.8-6"
get_deb  "x/xz-utils/liblzma5"  	  								   "5.8.1-1+deb13u1"
get_deb  "l/lz4/liblz4-1"	      	  								   "1.10.0-4"
get_deb  "libz/libzstd/libzstd1" 	  								   "1.5.7+dfsg-1"
get_deb  "s/systemd/libudev1"         								   "257.13-1~deb13u1"
get_deb  "s/systemd/libsystemd0"	  								   "257.13-1~deb13u1"
get_deb  "o/openssl/libssl3t64"	  	  								   "3.5.6-1~deb13u2"
get_deb  "x/xxhash/libxxhash0"	  	  								   "0.8.3-2"
get_deb  "e/expat/libexpat1"	  	  								   "2.7.1-2"
get_deb  "libc/libcap2/libcap2"		  								   "2.75-10+deb13u1+b1"
get_deb  "z/zlib/zlib1g"		  	  								   "1.3.dfsg+really1.3.1-1+b1"

address_mirror="${address_security_mirror}"
get_deb "o/openssl/libssl3t64"	  "3.5.7-1~deb13u2"	 "true"


cd ..

color:print "2. Extracting Packages..." ${purple}

for deb in ${path_temp_deb}/*.deb; do
    if [ -f "${deb}" ]; then
    	if dpkg-deb -x "${deb}" ${extracted}/; then 
    		color:print "Extracted ${deb}" ${yellow}
		else 
			color:print "not can extract ${deb}" ${red}
			exit 1
		fi		
	else
		color:print "not found ${deb}" ${red}
		exit 1
	fi

done




color:print "3. Building Runtime Layer..." ${purple}

cp 	  ${extracted}/usr/bin/perl           			  ${path_bin_runtime}/
cp -r ${extracted}/usr/lib/apt/methods/* 			  ${path_methods_runtime}/
cp -r ${extracted}/usr/lib/*-linux-*/perl-base/*      ${path_perl_base}/ 
cp -r ${extracted}/usr/lib/*-linux-*/perl5/*/*        ${path_perl5}/ 


find ${extracted} \( -type f -o -type l \) \( -name "*.so" -o -name "*.so.*" \) ! -name "*.py" -exec cp -d {} ${path_shards_libs}/ \;

for bin in ${path_bin_runtime}/perl ${path_methods_runtime}/*; do
    if [ -f "${bin}" ]; then
        patchelf --force-rpath --set-rpath '$ORIGIN/../../shards_libs' "${bin}"
    fi
done

for lib in ${path_shards_libs}/*.so*; do
    if [ -f "${lib}" ] && [ ! -L "${lib}" ]; then
        patchelf --force-rpath --set-rpath '$ORIGIN' "${lib}"
    fi
done

rm -rf ${path_temp_deb} ${extracted}


color:print "Operation completed successfully. Output is available at: ${path_target}" ${green}
