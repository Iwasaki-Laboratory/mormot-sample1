# ==============================================================================
#   Stage 1: Builder (ビルド環境 - FPC 3.2.2 を明示的に使用)
# ==============================================================================
FROM ubuntu:22.04 AS builder

# 必要なパッケージのインストール: FPC本体（バージョン固定）、make、スクリプト依存ツール
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        fpc=3.2.2+dfsg-9ubuntu1 \
        make \
        wget \
        ca-certificates \
        p7zip-full \
        unzip && \
    rm -rf /var/lib/apt/lists/*

# mORMot2 を GitHub から取得
RUN wget -q -O /tmp/mormot2.zip https://github.com/synopse/mORMot2/archive/refs/tags/2.3.stable.zip && \
    unzip /tmp/mormot2.zip -d /opt/ && \
    rm /tmp/mormot2.zip

# mORMot2 static を公式サイトから取得
RUN wget -q -O /tmp/mormot2static.7z https://synopse.info/files/mormot2static.7z && \
    7za x /tmp/mormot2static.7z -o./opt/static && \
    rm /tmp/mormot2static.7z

# ホストからアプリケーションソースコードのコピー
COPY app /app

# mORMot2 関連のシンボリックリンクを作成
RUN ln -s /opt/mORMot2-2.3.stable /app/mORMot2 && \
    ln -s /opt/static /app/mORMot2/static

# Makefile を使用したアプリケーションのビルド
WORKDIR /app
RUN make all

# ==============================================================================
#   Stage 2: Runtime (実行環境 - 軽量化とCloud Run向け)
# ==============================================================================
FROM ubuntu:22.04

# 実行ディレクトリの設定
WORKDIR /usr/bin/

# 実行ファイルのコピー
COPY --from=builder /app/build/release/webapp /usr/bin/webapp

# ポートの公開
EXPOSE 8080

# コンテナ起動時に実行するコマンド
CMD ["/usr/bin/webapp"]