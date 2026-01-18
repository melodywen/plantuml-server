# PlantUML Server with Large HTTP Headers Support

这个 Dockerfile 基于 `plantuml/plantuml-server:jetty` 镜像,专门解决了 HTTP Header 过大的问题。

## 问题说明

默认的 Jetty 服务器 HTTP Header 大小限制是 8192 字节 (8KB),当请求头超过这个大小时会出现以下错误:

```
oejh.HttpParser:qtp2052915500-27: Header is too large 8193>8192
```

## 解决方案

本镜像将 HTTP Header 大小限制从 8192 字节增加到 65536 字节 (64KB),以支持更大的请求头。

## 构建镜像

```bash
docker build -f Dockerfile.jetty-large-headers -t plantuml-server-large-headers:latest .
```

## 运行容器

```bash
docker run -d -p 8080:8080 plantuml-server-large-headers:latest
```

## 验证配置

容器启动后,你可以通过以下方式验证配置是否生效:

1. 查看启动日志:
```bash
docker logs <container_id>
```

2. 进入容器检查配置:
```bash
docker exec -it <container_id> cat /var/lib/jetty/start.d/http-config.ini
```

应该看到:
```
# Custom Jetty configuration to increase HTTP header size limit
jetty.httpConfig.requestHeaderSize=65536
jetty.httpConfig.responseHeaderSize=65536
```

## 自定义配置

如果 64KB 仍然不够,你可以根据需要调整大小。修改 `Dockerfile.jetty-large-headers` 中的值:

```dockerfile
ENV JETTY_OPTS="-Djetty.httpConfig.requestHeaderSize=131072 -Djetty.httpConfig.responseHeaderSize=131072"
```

或者修改 `http-config.ini` 文件中的值。

## 技术细节

- 基于 `plantuml/plantuml-server:jetty` 镜像
- 通过环境变量 `JETTY_OPTS` 设置 JVM 参数
- 通过 `/var/lib/jetty/start.d/http-config.ini` 配置文件设置 Jetty 参数
- 两个配置方式都设置了相同的值,确保配置生效

## 注意事项

- 增加内存限制可能会影响性能,请根据实际需求设置合适的值
- 建议在生产环境中测试后再部署
