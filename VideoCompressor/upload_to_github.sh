#!/bin/bash
echo "🛠️ 初始化 Git 仓库..."
git init
git remote add origin https://github.com/QiSDK/iOS_VideoCompressSDK.git
git add .
git commit -m "Initial commit: Add VideoCompressor SDK"
git branch -M main
git push -u origin main
echo "✅ 上传完成！"