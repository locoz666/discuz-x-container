#!/bin/sh

# 正常情况下，Discuz X允许用户修改的目录为config、data、uc_server/data、uc_client/data，所以这几个目录允许从容器外部直接挂载
# 但可能出现用户遗漏文件或有可能存在的版本更新，保险起见，构建镜像时将这些目录的原始文件备份了一份放到/tmp/discuz_x下，在容器启动时再覆盖回外部挂载的文件中
rsync -a /tmp/discuz_x/* /var/www/html

# 由于Discuz X本身年代久远，有些插件要实现功能会对其进行深度魔改，会存在部分正常情况下并非允许用户修改的目录也需要被修改的情况
# 所以允许用户挂载一个目录到/tmp/discuz_x_overwrite，里面放置需要用来添加或替换的文件，每次启动时再自动移至容器内部的网站目录
rsync -a /tmp/discuz_x_overwrite/* /var/www/html

# 如果已经对论坛做过了配置（安装完毕），就在启动时移除安装文件，避免被人恶意操作
if test -f "/var/www/html/config/config_global.php"; then
  rm /var/www/html/install/index.php
fi

# 回到php:7-apache原本的启动流程
/usr/local/bin/apache2-foreground
