#!/bin/zsh

templatePath=~/Library/Developer/Xcode/Templates
scriptPath=$(cd $(dirname $0); pwd;)

mkdir -p ${templatePath}
cd ${templatePath}

find ${scriptPath} -maxdepth 1 -name "*.xctemplate" | while read xctemplate; do
  templateName=`basename ${xctemplate}`
  if [ -e ${templateName} ]; then
    echo "File exists!"
    echo "Recreate template"
    rm ${templateName}
  fi
  echo "create link: ${templateName}"
  ln -s "${xctemplate}"
done