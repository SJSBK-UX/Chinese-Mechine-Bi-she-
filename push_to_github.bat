@echo off
setlocal

cd /d "%~dp0"

where git >nul 2>nul
if errorlevel 1 (
  echo [错误] 当前电脑没有检测到 Git。
  echo 请先安装 Git for Windows: https://git-scm.com/download/win
  echo 安装完成后重新双击本脚本。
  pause
  exit /b 1
)

if not exist ".git" (
  git init
)

git branch -M main
git add .
git commit -m "Initial commit: YOLO11 Chinese medicine detection system"

git remote remove origin >nul 2>nul
git remote add origin git@github.com:SJSBK-UX/Chinese-Mechine-Bi-she-.git
git push -u origin main

if errorlevel 1 (
  echo.
  echo [提示] 推送失败。常见原因：
  echo 1. GitHub 没有配置 SSH Key；
  echo 2. 当前账号没有该仓库权限；
  echo 3. 网络连接 GitHub 失败。
  echo.
  pause
  exit /b 1
)

echo.
echo [完成] 源码已推送到 GitHub。
pause
