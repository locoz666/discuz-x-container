# Discuz X 容器镜像自动构建

基于 Github Action，每日 0 点自动获取最新发布版本，并打包发布到 Docker Hub。

Docker Hub：https://hub.docker.com/r/locoz666666/discuz-x

## 使用说明

### 运行样例

`examples` 目录中有 Docker Compose 和 Kubernetes 原生 yaml 两种部署方式。

前者已经自带了数据库部分，可以直接使用，安装时数据库的地址设置为 `db` 即可；后者请自行搭配数据库使用。

### 关于容器中的文件

由于 Discuz X 本身年代久远，插件（应用）并不足够模块化，官方也并没有针对容器环境运行做优化，所以在安装插件时会出现两种情况：

1. 只需要在 Discuz X 安装时检测读写权限的目录（以下称为数据目录） `config`、`data`、`uc_server/data`、`uc_client/data` 下进行操作的插件
2. 需要对其他目录（以下称为非数据目录）比如 `source`、`template` 目录进行操作的插件

前者是 Discuz X 原本就允许用户读写且安装时还会检测读写权限的，属于数据目录，没有 Discuz X 本身的代码文件，所以直接把外部用于存储的目录挂载进去即可。

但后者由于混杂着大量 Discuz X 本身的代码文件，直接挂载外部目录会将镜像携带的代码文件替换掉，导致论坛程序无法正常运行。

而如果直接把整个主目录都挂载进容器内部，那就没有容器化的意义了，所以最优解是挂载一个临时目录用于存放需要覆盖进非数据目录的文件，并在容器运行时进行覆盖操作。

本镜像已经集成了这部分处理，每次启动时都会自动将容器内 `/tmp/discuz_x_overwirte` 目录下的所有文件覆盖到 Discuz X 的安装目录下，使用者只需挂载该目录并将需要覆盖的文件放进去即可。

比如如果需要在 `template` 目录下添加一个目录，那就在挂载到 `/tmp/discuz_x_overwirte` 的对应宿主机目录中添加目录并重启容器即可。