#!/usr/bin/env bash
# shellcheck disable=SC2317
# document https://www.yuque.com/lwmacct/docker/buildx

__main() {
  {
    _sh_path=$(realpath "$(ps -p $$ -o args= 2>/dev/null | awk '{print $2}')") # 当前脚本路径
    _pro_name=$(echo "$_sh_path" | awk -F '/' '{print $(NF-2)}')               # 当前项目名
    _dir_name=$(echo "$_sh_path" | awk -F '/' '{print $(NF-1)}')               # 当前目录名
    _image="${_pro_name}:$_dir_name"
  }

  _dockerfile=$(
    cat <<"EOF"
FROM kasmweb/ubuntu-noble-desktop:1.17.0

ENV DEBIAN_FRONTEND=noninteractive
USER root
RUN set -eux; echo "配置源 /etc/apt/sources.list 或 /etc/apt/sources.list.d/ubuntu.sources"; \
    rm -f /etc/localtime; \
    _source="/etc/apt/sources.list.d/ubuntu.sources"; \
    sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' "$_source"; \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' "$_source"; \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone; \
    apt-get update; apt-get install -y --no-install-recommends ca-certificates netbase curl wget sudo; \
    sed -i 's/http:/https:/g' "$_source"; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
    echo "删除已有语言设置"; \
    rm -f /etc/default/locale; \
    rm -rf /var/lib/locales/supported.d/*; \
    echo "设置语言包"; \
    apt-get update; \
    apt-get install -y --no-install-recommends locales fonts-wqy-zenhei fonts-wqy-microhei fonts-noto-cjk fcitx-libpinyin ibus-pinyin; \
    locale-gen zh_CN.UTF-8 en_US.UTF-8; \
    echo 'LANG=zh_CN.UTF-8' > /etc/default/locale; \
    echo 'LC_ALL=zh_CN.UTF-8' >> /etc/default/locale; \
    echo 'LANGUAGE="zh_CN:zh:en_US:en"' >> /etc/default/locale; \
    update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 LANGUAGE="zh_CN:zh:en_US:en"; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*
    
RUN set -eux; echo "常用软件包"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    virt-manager icedtea-netx \
    cron openssh-server rsyslog \
    jq bc tmux socat zip unzip vim git tree sshpass psmisc bash-completion \
    iproute2 iputils-ping net-tools telnet nfs-common; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; echo "设置 sudo 权限"; \
    echo "kasm-user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/kasm-user;

ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN.UTF-8:en_US
ENV LC_ALL=zh_CN.UTF-8
USER kasm-user

LABEL org.opencontainers.image.source="$_ghcr_source"
LABEL org.opencontainers.image.description="kasmweb/ubuntu-noble-desktop 0"
LABEL org.opencontainers.image.licenses="MIT"
EOF
  )
  {
    cd "$(dirname "$_sh_path")" || exit 1
    echo "$_dockerfile" >Dockerfile

    _ghcr_source=$(sed 's|git@github.com:|https://github.com/|' ../.git/config | grep url | sed 's|.git$||' | awk '{print $NF}')
    sed -i "s|\$_ghcr_source|$_ghcr_source|g" Dockerfile
  }
  {
    if command -v sponge >/dev/null 2>&1; then
      jq 'del(.credsStore)' ~/.docker/config.json | sponge ~/.docker/config.json
    else
      jq 'del(.credsStore)' ~/.docker/config.json >~/.docker/config.json.tmp && mv ~/.docker/config.json.tmp ~/.docker/config.json
    fi
  }
  {
    _registry="ghcr.io/lwmacct" # CR 服务平台
    _repository="$_registry/$_image"
    docker buildx build --builder default --platform linux/amd64 -t "$_repository" --network host --progress plain --load . && {
      if false; then
        docker rm -f sss
        docker run -itd --name=sss \
          --restart=always \
          --network=host \
          --privileged=false \
          "$_repository"
        docker exec -it sss bash
      fi
    }
    docker push "$_repository"

  }
}

__main

__help() {
  cat >/dev/null <<"EOF"
这里可以写一些备注

ghcr.io/lwmacct/250829-cr-kasmweb:ubuntu-noble-desktop-v1.17.0-t2508290

EOF
}
