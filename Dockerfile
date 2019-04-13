# GPUの場合
#FROM tensorflow/tensorflow:1.12.0-gpu-py3
# CPUの場合
FROM tensorflow/tensorflow:1.12.0-py3
COPY into_container/requirements.txt /root/

# 環境変数設定
ENV PROXY_ID ooo
ENV PROXY_PASS ooo
ENV PROXY_HOST ooo
ENV PROXY_PORT ooo
ENV PROXY_SERVER http://"$PROXY_ID":"$PROXY_PASS"@"PROXY_HOST":"PROXY_PORT"
ENV http_proxy "$PROXY_SERVER"
ENV https_proxy "$PROXY_SERVER"
ENV ftp_proxy "$PROXY_SERVER"
ENV HTTP_PROXY "$PROXY_SERVER"
ENV HTTPS_PROXY "$PROXY_SERVER"
ENV FTP_PROXY "$PROXY_SERVER"

# apt.confの作成
RUN echo "Acquire::ftp::proxy \"""$PROXY_SERVER""\";" > /etc/apt/apt.conf \
 && echo "Acquire::fttp::proxy \"""$PROXY_SERVER""\";" >> /etc/apt/apt.conf \
 && echo "Acquire::fttps::proxy \"""$PROXY_SERVER""\";" >> /etc/apt/apt.conf

# パッケージインストール
RUN add-apt-repository -y ppa:jonathonf/vim \
 && apt-get update \
 && apt-get install -y git vim xterm sudo python3-tk \
 && pip3 install --upgrade pip \
 && pip3 install -r /root/requirements.txt

# ユーザーの切り替え
RUN groupadd -g 1000 developer && \
    useradd  -u 1000 -g 1000 --groups sudo --create-home --shell /bin/bash developer && \
    echo 'developer:P@ssw0rd' | chpasswd
USER developer
WORKDIR /home/developer
