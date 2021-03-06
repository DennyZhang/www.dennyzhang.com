#!/bin/bash -e
function my_test() {
   for f in $(find . -name README.org); do
        dirname=$(basename $(dirname $f))
        echo "Update for $f"
        # sed -ie "s/github.com\/DennyZhang\/challenges-leetcode-interesting\/tree\/master/github.com\/DennyZhang\/challenges-leetcode-interesting\/tree\/master\/problems/g" $f
        # sed -ie "s/url-external://g" $f
        # rm -rf $dirname/README.orge
        #exit
   done
}

function refresh_wordpress() {
    local max_days=${MAX_DAYS:-"7"}
    echo "Use emacs to update wordpress posts"
    for d in "posts" "docker" "aws" "devops" "kubernetes" "life" "jenkins" "pks" "build-k8s" "quiz"; do
        cd "$d"
        for f in $(find . -name 'README.org' -mtime -${max_days} | grep -v '^README.org$'); do
            echo "Update $f"
            dirname=$(basename $(dirname $f))
            cd $dirname
            /Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_10 --batch -l ../../emacs-update.el
            cd ..
        done
        cd ..
    done
}

function git_push() {
    for d in $(ls -1); do
        if [ -d "$d" ] && [ -f "$d/.git" ] ; then
            cd "$d"
            echo "In ${d}, git commit and push"
            git commit -am "update doc"
            git push origin
            cd ..
        fi
    done
    git commit -am "update doc"
    git push origin
}

function git_pull() {
     for d in $(ls -1); do
        if [ -d "$d" ] && [ -f "$d/.git" ] ; then
             cd "$d"
             echo "In ${d}, git commit and push"
             git pull origin
             cd ..
         fi
     done
    git pull origin
}

function refresh_link() {
    echo "refresh link"
    for d in "posts" "docker" "aws" "devops" "kubernetes" "life" "jenkins" "pks" "build-k8s" "quiz"; do
        cd "$d"
        for f in $(ls -1t */README.org); do
            dirname=$(basename $(dirname $f))
            if ! grep "<a href=\"https://github.com/dennyzhang/www.dennyzhang.com/tree/master/$d/$dirname" $f 1>/dev/null 2>&1; then
                if grep "https://github.com/dennyzhang/www.dennyzhang.com" $f 1>/dev/null 2>&1; then
                    echo "Update GitHub url for $f"
                    sed -ie "s/<a href=\"https:\/\/github.com\/dennyzhang\/www.dennyzhang.com\/tree\/master\/[^\"]*\"/<a href=\"https:\/\/github.com\/dennyzhang\/www.dennyzhang.com\/tree\/master\/$d\/$dirname\"/g" $f
                    rm -rf $dirname/README.orge
                fi
            fi

            if ! grep "Blog URL: https://www.dennyzhang.com/$dirname" $f 1>/dev/null 2>&1; then
                echo "Update Blog url for $f"
                sed -ie "s/Blog URL: https:\/\/www.dennyzhang.com\/.*/Blog URL: https:\/\/www.dennyzhang.com\/$dirname/g" $f
                rm -rf $dirname/README.orge
            fi
        done
        cd ..
    done
}

cd .

action=${1?}
eval "$action"
