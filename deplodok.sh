#!/usr/bin/env bash

#Color table
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


ShowUsage () {
   echo "Example usage";
   echo "./deplodok.sh --project=gp --buildя=14"
}

Error () {
    printf "${RED}$1${NC}\n"
}

Success () {
    printf "${GREEN}$1${NC}\n"
}

CheckNginx () {
#    file1=`md5 $1`
#    file2=`md5 $2`
#
#    if [ "$file1" = "$file2" ]
#    then
#        echo "Files have the same content"
#    else
#        echo "Files have NOT the same content"
#    fi
    echo "Перезагрузите nginx, если конфиги поменялись"
}

echo "Deplodok project deployer";

while [ $# -gt 0 ]; do
  case "$1" in
    --project=*)
      project="${1#*=}"
      ;;
    --build=*)
      build="${1#*=}"
      ;;
#    *)
#      printf "***************************\n"
#      printf "* Error: Invalid argument.*\n"
#      printf "***************************\n"
#      exit 1
  esac
  shift
done


if [ -z "$project" ]; then
    Error "Не указан проект";
    ShowUsage;
    exit 1
fi

if [ -z "$build" ]; then
    Error "Не указан билд";
    ShowUsage;
    exit 1
fi

Success "Начинаю выкладку. Проект $project, билд $build";

#BASE_DIR="/Users/cold/temp";
BASE_DIR="/data";

BUILD_DIR="${BASE_DIR}/builds";
RELEASE_DIR="${BASE_DIR}/releases/";
PROJECTS_DIR="${BASE_DIR}/projects/";

buildtar="${BUILD_DIR}/build-${build}.tar.gz";

if [ -e ${buildtar} ]
then
    echo "Фаил с билдом найден: ${buildtar}";
else
    Error "Не найден фаил с билдом: ${buildtar}"
    exit 1
fi

echo "Создаю папку с релизом";

releasefolder="${RELEASE_DIR}/${project}-${build}";

mkdir -p ${releasefolder}

echo "Распаковываю пакет";

tar -zxf ${buildtar} -C ${releasefolder}

projectfolder="${PROJECTS_DIR}/${project}";

#Сначал проверим фаилы нгинкса. поменялись ли, добавились ли
CheckNginx;

echo "Меняю или создаю симлинк"
ln -sfn ${releasefolder} ${projectfolder}

Success "Выкладка завершена";