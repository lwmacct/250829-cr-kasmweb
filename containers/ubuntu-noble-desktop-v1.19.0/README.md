# ubuntu-noble-desktop-v1.19.0

这个目录是 `ubuntu-noble-desktop-v1.19.0` 版本族的唯一构建定义。

Dockerfile 直接使用 BuildKit 构建，不通过模板或脚本生成。正式构建只在版本族专属的远程 CI 中执行。

镜像标签：

```text
ubuntu-noble-desktop-v1.19.0-latest
ubuntu-noble-desktop-v1.19.0-sha-<12位提交ID>
```

本地不提供镜像构建脚本。影响镜像的文件合并到 `main` 后，由 GitHub Actions 自动发布；也可以通过版本族 workflow 手动重建。
