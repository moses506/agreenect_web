#!/bin/bash
set -e

echo ""
echo "🌿 Agreenect — Build & Deploy"
echo "================================"

# ── 1. Build CLIENT (public website) ─────────────────────────────────────────
echo ""
echo "📦 Building CLIENT (public website)..."
flutter build web \
  --release \
  --web-renderer canvaskit \
  --dart-define=APP_MODE=client \
  --output build/web/client

echo "✓ Client built"

# ── 2. Build ADMIN (dashboard) ────────────────────────────────────────────────
echo ""
echo "📦 Building ADMIN (dashboard)..."
flutter build web \
  --release \
  --web-renderer canvaskit \
  --dart-define=APP_MODE=admin \
  --output build/web/admin

echo "✓ Admin built"

# ── 3. Deploy CLIENT to custom domain (agreenecttechnologies.co.zm) ───────────
echo ""
echo "🚀 Deploying CLIENT to Firebase Hosting (client target)..."
firebase deploy --only hosting:client

# ── 4. Deploy ADMIN to Firebase Hosting subdomain ────────────────────────────
echo ""
echo "🚀 Deploying ADMIN to Firebase Hosting (admin target)..."
firebase deploy --only hosting:admin

echo ""
echo "================================"
echo "✅ Deployment complete!"
echo ""
echo "  🌐 Client:  https://agreenecttechnologies.co.zm"
echo "  🔐 Admin:   https://https://agreenect-admin.web.app"
echo ""