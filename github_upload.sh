#!/bin/bash

largefileneed=" filter=lfs diff=lfs merge=lfs -text\n"
largefilepath=""

#github 账号密码
username=""
password=""

#github远程仓库前面一段
premaster="MocorDroid6.0_Trunk_16b_rls2_W17.15.5_"


function addcode(){
    for dir in $(ls)
    do
        if [ -d $dir ] 
        then
            cd $dir
            path=$(find . -type f -size +99M)
            if [ ! -n "$path" ]; then
                echo "" #$dir have no more than 100M file"
            else
                for p in $path
                do
                    largefilepath="${largefilepath}""${p}""${largefileneed}"
                done
                echo "$largefilepath" > .gitattributes
                #echo "$largefilepath"
            fi
            
            git init
            git commit --allow-empty -q -m "[Droi/create code] init repo"
            git remote add origin git@github.com:ijianglingfeng/MocorDroid6.0_Trunk_16b_rls2_W17.15.5_$dir.git
            git add -f .
            git commit -m "add code"
            git push -f origin master
            
            largefilepath=""
            cd ..
        fi
    done
}

function createrepo(){
    for dir in $(ls)
    do
        if [ -d $dir ]
        then
            curl -u "$username:$password" -d "{\"name\":\"$premaster$dir\",\"description\":\"$dir\"}" https://api.github.com/user/repos
        fi
    done
}

#创建远程仓库
createrepo

#上传代码
addcode
