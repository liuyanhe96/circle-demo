#!/bin/sh

# 相当于函数回调 若没有收到非零数值的话 就退出shell脚本的运行
# 整个shell脚本可以理解为一个function，func会有个return，不同return的值代表着shell脚本是否成功的执行，return 0 代表成功执行
set -e

# 打印当前的工作路径
pwd
# 设置远程仓库地址q
remote=$(git config remote.origin.url)

echo 'remote is: '$remote

# 新建一个发布目录
mkdir gh-pages-branch
# 进入临时目录中
cd gh-pages-branch

# 创建新仓库
# 配置了要去提交的用户名和邮箱
git config --global user.email "$GH_EMAIL" >/dev/null 2>&1
git config --global user.name "$GH_NAME" >/dev/null 2>&1
# 初始化临时的git仓库
git init
git remote add --fetch origin "$remote"

echo 'email is: '$GH_EMAIL
echo 'name is: '$GH_NAME
echo 'siteSource is: '$siteSource

# 切换gh-pages分支
if  git rev-parse --verify origin/gh-pages >/dev/null 2>&1; then
    git checkout gh-pages
    # 删除掉旧文件内容
    git rm -rf .
else
  git checkout --orphan gh-pages
fi

# 把构建好的文件目录拷贝进来 ${siteSource}为构建的目录名称
cp -a "../${siteSource}/." .
ls -la

# 把所有文件添加到git
git add -A
# 添加一条提交内容
git commit --allow-empty -m 'Depoly to Github pages [ci skip]'
# 推送文件
git push --force --quiet origin gh-pages
# 资源回收，删除临时分支与目录
cd ..
rm -rf gh-pages-branch

echo 'Finished Depolyment!!!!'
