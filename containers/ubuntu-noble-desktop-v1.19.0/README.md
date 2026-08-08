# ubuntu-noble-desktop-v1.19.0

这个目录是 `ubuntu-noble-desktop-v1.19.0` 版本族的唯一构建定义。

Dockerfile 直接使用 BuildKit 构建，不通过模板或脚本生成。正式构建只在版本族专属的远程 CI 中执行。

镜像标签：

```text
ubuntu-noble-desktop-v1.19.0-latest
ubuntu-noble-desktop-v1.19.0-sha-<12位提交ID>
```

本地不提供镜像构建脚本。请从仓库根目录创建版本族构建 tag，交由 GitHub Actions 发布。
