# syntax=docker/dockerfile:1

FROM kasmweb/ubuntu-noble-desktop:1.17.0@sha256:26da4f4c0ae5e713f5b6830e744b5ddc837a207b554dbe234cb2dc42f9aa15b4

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH
ARG BUILD_APT_MIRROR=https://mirrors.ustc.edu.cn/ubuntu
ARG BUILD_APT_PORTS_MIRROR=https://mirrors.ustc.edu.cn/ubuntu-ports
ARG RUNTIME_APT_MIRROR=https://mirrors.ustc.edu.cn/ubuntu
ARG RUNTIME_APT_PORTS_MIRROR=https://mirrors.ustc.edu.cn/ubuntu-ports
ARG IMAGE_CHANNEL=ubuntu-noble-desktop-v1.17.0
ARG VCS_REF=unknown

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root

RUN <<'RUN_EOF'
set -eux
__main() {
  _source=/etc/apt/sources.list.d/ubuntu.sources
  test -f "$_source"
  cp "$_source" /etc/apt/ubuntu.sources.origin
  case "$TARGETARCH" in
    amd64) _mirror="${BUILD_APT_MIRROR%/}" ;;
    arm64) _mirror="${BUILD_APT_PORTS_MIRROR%/}" ;;
    *) echo "不支持 TARGETARCH=$TARGETARCH" >&2; return 1 ;;
  esac
  sed -E -i "s@^URIs:.*@URIs: $_mirror@g" "$_source"
  cat "$_source"
  apt-get update
  apt-get install -y --no-install-recommends ca-certificates curl wget sudo
  apt-get clean
  rm -rf /var/lib/apt/lists/*
}
__main
RUN_EOF

RUN <<'RUN_EOF'
set -eux
__main() {
  echo "配置语言与时区"
  rm -rf /var/lib/locales/supported.d/*
  printf '%s\n' 'en_US.UTF-8 UTF-8' 'zh_CN.UTF-8 UTF-8' > /etc/locale.gen
  apt-get update
  apt-get install -y --no-install-recommends \
    locales \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    fonts-noto-cjk \
    fcitx-libpinyin \
    ibus-pinyin \
    tzdata
  locale-gen zh_CN.UTF-8 en_US.UTF-8
  update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 LANGUAGE="zh_CN:zh:en_US:en"
  ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  echo "Asia/Shanghai" > /etc/timezone
  apt-get clean
  rm -rf /var/lib/apt/lists/*
}
__main
RUN_EOF

RUN <<'RUN_EOF'
set -eux
__main() {
  echo "安装常用桌面与运维软件包"
  apt-get update
  apt-get install -y --no-install-recommends \
    virt-manager icedtea-netx \
    cron openssh-server rsyslog \
    jq bc tmux socat zip unzip vim git tree sshpass psmisc bash-completion \
    iproute2 iputils-ping net-tools telnet nfs-common
  apt-get clean
  rm -rf /var/lib/apt/lists/*
}
__main
RUN_EOF

RUN <<'RUN_EOF'
set -eux
__main() {
  echo "配置 kasm-user sudo 权限"
  printf '%s\n' 'kasm-user ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/kasm-user
  chmod 0440 /etc/sudoers.d/kasm-user
  visudo -cf /etc/sudoers.d/kasm-user
}
__main
RUN_EOF

RUN <<'RUN_EOF'
set -eux
__main() {
  echo "恢复运行期 apt 源"
  _source=/etc/apt/sources.list.d/ubuntu.sources
  case "$TARGETARCH" in
    amd64) _mirror="${RUNTIME_APT_MIRROR%/}" ;;
    arm64) _mirror="${RUNTIME_APT_PORTS_MIRROR%/}" ;;
    *) echo "不支持 TARGETARCH=$TARGETARCH" >&2; return 1 ;;
  esac
  cp /etc/apt/ubuntu.sources.origin "$_source"
  sed -E -i "s@^URIs:.*@URIs: $_mirror@g" "$_source"
  rm -f /etc/apt/ubuntu.sources.origin
  cat "$_source"
}
__main
RUN_EOF

ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh:en_US:en \
    LC_ALL=zh_CN.UTF-8 \
    TZ=Asia/Shanghai

USER kasm-user

LABEL org.opencontainers.image.source="https://github.com/lwmacct/250829-cr-kasmweb" \
      org.opencontainers.image.description="Kasm Ubuntu Noble desktop: ${IMAGE_CHANNEL}" \
      org.opencontainers.image.version="${IMAGE_CHANNEL}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.licenses="MIT"
