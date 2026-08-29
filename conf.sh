
# seting (for normal user)

# example arch i386 amd64 amhf 
arch="i386"

# example https://example.com/debian
address_mirror="https://deb.debian.org/debian"
address_security_mirror="http://security.debian.org/debian-security"




# Advance Seting (for developer)
path_origin="$(pwd)"

path_temp_deb=".temp_deb"

extracted=".extracted"

path_build="build"
path_build_target="${path_build}/${arch}"


path_shards_libs="${path_build_target}/shards_libs"


path_runtime="${path_build_target}/runtime"
path_lib_runtime="${path_runtime}/lib"
path_bin_runtime="${path_runtime}/bin"
path_methods_runtime="${path_runtime}/methods"

path_perl_base="${path_lib_runtime}/perl-base"
path_perl5="${path_lib_runtime}/perl5"
