# Gome Docker 部署

使用 Docker 和 Compose v2.20 或更新版本部署 Gome。默认拉取 [Gome v1.0.2](https://github.com/stingbo/gome/releases/tag/v1.0.2)，并启动 gRPC 服务、撮合进程、Redis 和 RabbitMQ。

## 快速开始

在本仓库目录复制配置示例。

```sh
cp .env.example .env
```

在 `.env` 填写 `RABBITMQ_PASSWORD`，然后拉取镜像并启动服务。可用 `openssl rand -hex 24` 生成密码。

```sh
docker compose pull
docker compose up -d --no-build --wait
docker compose ps
docker compose run --rm client
```

最后一条命令通过 gRPC 查询默认交易对 `btc2usdt` 的买盘。空订单簿返回零条记录是正常的。宿主机客户端可连接 `127.0.0.1:8088`。Redis 和 RabbitMQ 通过 Compose 网络访问。

可在 `.env` 修改 `GOME_SYMBOL`、`GOME_PORT` 和 `GOME_IMAGE`。客户端下单时使用与 `GOME_SYMBOL` 相同的交易对。每个交易对运行一个撮合进程。

## 中国大陆网络拉取

先在部署主机执行 `docker pull ghcr.io/stingbo/gome:v1.0.2`。如果 GHCR 拉取失败，可以在 `.env` 中将 `GOME_IMAGE` 改为以下 [毫秒镜像](https://1ms.run/) 加速地址。该地址固定了官方镜像的多架构摘要。

```dotenv
GOME_IMAGE=ghcr.1ms.run/stingbo/gome:v1.0.2@sha256:a80e9e6b0adbbe400ec7213a04efce615245fdf7b1feaf32531dfe54883c0791
```

修改后重新运行 `docker compose pull` 和 `docker compose up -d --no-build --wait`。镜像可达性取决于部署主机的网络。如果 Redis 或 RabbitMQ 的 Docker Hub 镜像也拉取失败，可通过 `REDIS_IMAGE` 和 `RABBITMQ_IMAGE` 指定可访问的同版本镜像地址。

## 查看日志和结果

```sh
docker compose logs -f server match
docker compose exec server tail -f /app/logs/info.log
```

如需在终端打印撮合结果，可启动示例消费者。它会从结果队列消费并确认消息。已有业务消费者的环境应由业务消费者接收回报。

```sh
docker compose --profile notice up -d notice
docker compose logs -f notice
```

## 停止和升级

`docker compose down` 会停止服务并保留 Redis 和 RabbitMQ 的命名卷。重新启动会使用原数据。Redis 启用了 Gome 要求的 AOF 持久化。RabbitMQ 的默认账号和密码仅在数据卷首次初始化时创建，已有数据卷需要先在 RabbitMQ 中更新账号，再同步修改 `.env`。

从旧版部署迁移时，先按 [Gome 升级说明](https://github.com/stingbo/gome/blob/v1.0.2/README_cn.md#消息恢复与升级) 排空旧队列并备份数据。旧版绑定挂载中的数据不会自动迁移到新命名卷。
