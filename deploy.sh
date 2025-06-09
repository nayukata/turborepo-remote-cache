#!/bin/bash
# 正しいGCS設定でデプロイ

echo "🔧 正しいGCS設定でデプロイ"

# 変数設定
PROJECT_ID="my-turbo-demo"
REGION="asia-northeast1"
SERVICE_NAME="ducktors-turbo-cache"
GCS_BUCKET="turbo-demo-cache"
IMAGE_NAME="asia-northeast1-docker.pkg.dev/my-turbo-demo/turbo-cache/turborepo-cache"

# TURBO_TOKENを取得
TURBO_TOKEN=$(grep TURBO_TOKEN .env | cut -d'=' -f2)

echo "📋 正しいGCS設定:"
echo "  STORAGE_PROVIDER: google-cloud-storage"
echo "  STORAGE_PATH: $GCS_BUCKET"
echo "  認証: Application Default Credentials (ADC)"

# GCS権限を確保
echo "🔐 GCS権限を設定中..."
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
    --role="roles/storage.objectAdmin" \
    --quiet

# 既存サービスを削除
echo "🗑️  既存サービスを削除..."
gcloud run services delete my-turbo-cache --region=$REGION --quiet 2>/dev/null || echo "サービスが存在しません"

# 正しい設定でデプロイ
echo "🚀 正しいGCS設定でデプロイ中..."
gcloud run deploy $SERVICE_NAME \
    --image $IMAGE_NAME \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --set-env-vars "STORAGE_PROVIDER=google-cloud-storage,STORAGE_PATH=$GCS_BUCKET,TURBO_TOKEN=$TURBO_TOKEN,NODE_ENV=production,LOG_LEVEL=info" \
    --memory 1Gi \
    --cpu 1 \
    --min-instances 0 \
    --max-instances 5 \
    --timeout 300 \
    --port 8080

# サービスURLを取得
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)" 2>/dev/null)

if [ -n "$SERVICE_URL" ]; then
    echo ""
    echo "✅ デプロイ成功！"
    echo ""
    echo "🔗 Turbo Cache Server URL: $SERVICE_URL"
    echo "🔑 TURBO_TOKEN: $TURBO_TOKEN"
    echo "👥 TURBO_TEAM: ducktors"
    echo ""
    echo "📝 GitHub Secretsに設定:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "TURBO_API=$SERVICE_URL"
    echo "TURBO_TOKEN=$TURBO_TOKEN"
    echo "TURBO_TEAM=ducktors"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🧪 テスト:"
    echo "curl $SERVICE_URL/health"
    echo ""
    echo "🧪 認証テスト:"
    echo "curl -H \"Authorization: Bearer $TURBO_TOKEN\" $SERVICE_URL/v2/user"
else
    echo ""
    echo "❌ デプロイ失敗"
    echo "ログを確認:"
    echo "gcloud logging read \"resource.type=cloud_run_revision AND resource.labels.service_name=$SERVICE_NAME\" --limit=10"
fi