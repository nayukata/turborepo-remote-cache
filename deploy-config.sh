# =============================================================================
# deploy-config.sh
# デプロイ設定例 - プロジェクトに合わせてコピー&編集してください
# =============================================================================

# 基本設定（必須）
export PROJECT_ID="my-turbo-demo"                    # あなたのGCPプロジェクトID
export REGION="asia-northeast1"                      # デプロイリージョン
export GCS_BUCKET="turbo-demo-cache"             # GCSバケット名

# サービス設定（オプション - デフォルト値をオーバーライド）
export SERVICE_NAME="my-turbo-cache"         # Cloud Runサービス名
export ARTIFACT_REPO="turbo-cache"                   # Artifact Registryリポジトリ名
export IMAGE_NAME="turborepo-cache"                  # Dockerイメージ名
export TURBO_TEAM="my-team"                          # Turborepoチーム名

# リソース設定（オプション）
export MEMORY="2Gi"                                   # メモリ制限
export CPU="2"                                       # CPU制限
export MIN_INSTANCES="1"                             # 最小インスタンス数（常時起動）
export MAX_INSTANCES="20"                           # 最大インスタンス数
export TIMEOUT="600"                                 # タイムアウト（秒）

# 環境設定（オプション）
export NODE_ENV="production"                         # Node.js環境
export LOG_LEVEL="debug"                            # ログレベル（debug/info/warn/error）

# =============================================================================
# 使用方法:
# 1. このファイルを deploy-config.sh にコピー
# 2. 上記の値をプロジェクトに合わせて編集
# 3. source deploy-config.sh で読み込み
# 4. ./deploy.sh で実行
# =============================================================================