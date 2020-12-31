### [gome(Golang+gRPC+ProtoBuf+RabbitMQ+Redis)](https://github.com/stingbo/gome)撮合引擎docker环境


### 快速开始

1. `copy docker-compose.example.yml docker-compose.yml`

2. `docker-compose up -d`

### 说明

- docker-comoser.yaml 文件里 gome 配置项区域 `./code/gome:/go/src/gome` 代表 [gome](https://github.com/stingbo/gome) 项目源码目录在code里

- docker-comoser.yaml 文件里 rabbitmq 配置项区域里可修改账号与密码，与 [gome](https://github.com/stingbo/gome) 里的配置对应
