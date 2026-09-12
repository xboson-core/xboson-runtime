# 该指南讲解 install.sh 的其他功能

为了方便, 你可以把 `https://raw.githubusercontent.com/xboson-core/xboson-runtime/refs/heads/main/install.sh` 这个脚本下载到一个空文件甲中.


## 默认行为

该脚本会执行拉起镜像并启动一个单节点服务, 立即可用和授予免费不现时评估授权.
该脚本不能再已经安装的目录中再次安装, 这会覆盖保存密码的文件, 脚本会报错退出.
所有的密码和上下文配置保存在 .env 文件中, 
生成的 docker-compose.yml 用于 docker compose 命令进行管理.
`install.sh --help` 查看可用命令,

> 没有将容器中的数据卷导出, 如果你删除了 mysql 容器, 则所有数据都会丢失

一下功能只支持用 `install.sh` 创建的容器


## 数据备份

备份web文件:
`install.sh --backup web`
备份mysql
`install.sh --backup mysql`
备份mongodb
`install.sh --backup mongo`


## 数据恢复

> 注意: 这有会覆盖当前数据, 恢复前应该备份

恢复 web 文件:
`install.sh --restore web web.tar.gz`
恢复 mysql 数据
`install.sh --restore mysql data.sql`
恢复 mongodb 数据
`install.sh --restore mongo data.db`

## 授权许可

1. 执行 `install.sh --license show` 会看到授权请求文件内容.
2. 将文件内容复制到邮件中, 发送给 `yanmingsohu@gmail.com`.
3. 您会收到邮件答复包含 `license.txt` 的附件
4. 将 `license.txt` 复制到 `install.sh` 所在目录
5. 执行 `install.sh --license install` 授权即被安装

[About authorization](./authorization.md)