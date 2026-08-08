# 250829-cr-kasmweb

基于 `kasmweb/ubuntu-noble-desktop:1.19.0` 的中文化 Kasm 桌面镜像。

## 镜像标签

这个仓库维护多个基础镜像版本族。当前版本族的镜像地址为：

```text
ghcr.io/lwmacct/250829-cr-kasmweb:ubuntu-noble-desktop-v1.19.0-latest
ghcr.io/lwmacct/250829-cr-kasmweb:ubuntu-noble-desktop-v1.19.0-sha-<12位提交ID>
```

`latest` 只在 `ubuntu-noble-desktop-v1.19.0` 版本族内滚动，不是仓库全局标签。SHA 标签用于固定某次源码构建。

## 检查与发布

本地只执行 Dockerfile 静态检查，不提供本地镜像构建入口：

```shell
task image:check
```

## 发布

影响镜像的文件合并到 `main` 后，GitHub Actions 会自动构建并发布版本族 `latest` 和对应的 12 位 SHA 标签。触发范围包括：

- `containers/ubuntu-noble-desktop-v1.19.0/**`，版本族 README 除外
- `.github/workflows/ubuntu-noble-desktop-v1.19.0.yml`
- `.github/workflows/publish-image.yml`

不修改源码时可以手动重建：

```shell
gh workflow run ubuntu-noble-desktop-v1.19.0.yml --ref main
```

## 开发环境

安装 pre-commit：

```shell
pre-commit install
```

查看所有任务：

```shell
task -a
```
