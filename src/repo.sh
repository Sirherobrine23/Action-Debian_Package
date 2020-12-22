#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------------------------------------
# removendo arquivos do diretorio para a pasta /tmp/deb-copiler
rm -rf .git*
rm -rf LICE*
rm -rf README*
rm -rf *.md

# Pre script - build

if [ $SCRIPT = 'true' ]
then
 dos2unix $PRESCRIPT
 bash $PRESCRIPT
 rm -rf $PRESCRIPT
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
 chmod a+x ${abin}/*
 chmod 775 ${abin}/*
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
mkdir -p /tmp/exports
if [ $FTP = 'true' ];then
    curl -T /tmp/$DEB_OUTPUT ftp://$FTPURL/$FTPDIR/ --user $USERSMB:$PASSSMB || ftp-upload --debug --passive -h $FTPURL -u "$USERSMB" --password "$PASSSMB" -d "$FTPDIR" "$DEB_OUTPUT.deb"
elif [ $GIT = 'true' ];then
    GITURL="$(echo $GITURL | sed 's|https://||g')"
    git config --global user.email "srherobrine20@gmail.com"
    git config --global user.name "Sirherobrine23"

    echo "Atuamente só suportamos links com https://. , o git:// não esta funcionanod por enquanto"
    echo "estamos clonando com as seguintes informações: https://$GITUSER:*****@$GITURL ,Branch: $GITBRANCH"
    git clone https://$GITUSER:$GITPASS@$GITURL -b $GITBRANCH /tmp/exports/publish/
    cd /tmp/exports/publish/
    cp -f /tmp/$DEB_OUTPUT /tmp/exports/publish/$GITDIR/$DEB_OUTPUT
    git add .
    git commit -m "$NAME - Upload by Debian_docker By sh23"
    git push
else
 echo 'Não foi informado um metodo para subir o arquivo !!!'
 exit 23
fi