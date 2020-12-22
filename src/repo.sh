#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------------------------------------
# removendo arquivos do diretorio para a pasta /tmp/deb-copiler
rm -rfv '.git*'
rm -rfv 'LICENSE*'
rm -rfv 'README*'
rm -rfv '*.md'
rm -rfv '*.txt'

# Pre script - build

if [ -e $INPUT_SCRIPT ]
then
 dos2unix $INPUT_SCRIPT
 bash $INPUT_SCRIPT
 rm -rf $INPUT_SCRIPT
fi

#----------------------------------------------------------------------------------------------------------------------------------------------------
# Nome do Pacotes

[ -d DEBIAN ] && DEBIAN_DIR=DEBIAN
[ -d debian ] && DEBIAN_DIR=debian

echo "Diretorio do arquivos do Debian Package: $DEBIAN_DIR "

NAME="$(cat $DEBIAN_DIR/control | grep 'Package:' | sed 's|Package: ||g' | sed 's|Package:||g')"
VERSION="$(cat $DEBIAN_DIR/control | grep 'Version: ' | grep -v 'Standards-Version' | sed 's|Version: ||g')"
ARQUITETURA="$(cat $DEBIAN_DIR/control | grep 'Architecture: ' | sed 's|Architecture: ||g')"

# postinst
if [ -e $DEBIAN_DIR/postinst ]
then
 chmod 775 $DEBIAN_DIR/postinst
fi
# preinst
if [ -e $DEBIAN_DIR/preinst ]
then 
 chmod 775 $DEBIAN_DIR/preinst
fi
# prerme
if [ -e $DEBIAN_DIR/prerme ]
then
 chmod 775 $DEBIAN_DIR/prerme
fi
# postrm
if [ -e $DEBIAN_DIR/postrm ]
then
 chmod 755 $DEBIAN_DIR/postrm
fi

# Execute in all bin foldes 
for abin in $(find . -name '*bin')
do
 chmod -R a+x ${abin}
 chmod -R 775 ${abin}
done

#----------------------------------------------------------------------------------------------------------------------------------------------------
# Informações do pacote
echo "Nome do Pacote:                        - $NAME "
echo "Versão do Pacote:                      - $VERSION "
echo "Arquitetura do processador suportados: - $ARQUITETURA "

DEB_OUTPUT="$(echo "$NAME $VERSION $ARQUITETURA" | sed 's| |_|g').deb"

#----------------------------------------------------------------------------------------------------------------------------------------------------
# Copilando o arquivo
echo "vamos criar um pacote com as seguintes configurações: $DEB_OUTPUT"
dpkg-deb --build . /tmp/$DEB_OUTPUT && success=0 || exit 23

#----------------------------------------------------------------------------------------------------------------------------------------------------
#Publish
if [ $success == 0 ]
then
    echo "DEB_PATH=/tmp/$DEB_OUTPUT" >> $GITHUB_ENV
    echo 'Use ${{ env.DEB_PATH }} to get the file'
    echo "DEB_PATH=/tmp/$DEB_OUTPUT"
    exit 0
else
    exit 1
fi
exit 0