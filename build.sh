#!/bin/bash

# Install cpanm to current directory
curl -L https://cpanmin.us -o cpanm
chmod +x cpanm

# Perl modules
# https://github.com/exiftool/exiftool/blob/master/windows_exiftool
# Build PAR::Packer from source to ensure compatibility
./cpanm Archive::Zip PAR IO::String

# Download and build PAR::Packer from source
wget https://cpan.metacpan.org/authors/id/R/RS/RSCHUPP/PAR-Packer-1.063.tar.gz
tar -xzf PAR-Packer-1.063.tar.gz
cd PAR-Packer-1.063
perl Makefile.PL
make
make install
cd ..
rm -rf PAR-Packer-1.063 PAR-Packer-1.063.tar.gz
zip -y -q -r cpanm-log.zip ~/.cpanm/

# Get repo
wget -O exiftool.zip https://github.com/exiftool/exiftool/archive/refs/tags/13.30.zip
unzip -q exiftool.zip
rm exiftool.zip
cd exiftool-*
rm -rf windows_exiftool html t

# Build
ARGS=`awk '!/^#/ && !/Win32|Brotli/' pp_build_exe.args | tr '\n' ' '`

pp $ARGS
mv exiftool.exe ../
echo 'Built successfully'
