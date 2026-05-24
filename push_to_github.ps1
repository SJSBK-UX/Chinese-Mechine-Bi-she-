$ErrorActionPreference = 'Stop'

Set-Location -LiteralPath $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host '[错误] 当前电脑没有检测到 Git。' -ForegroundColor Red
    Write-Host '请先安装 Git for Windows: https://git-scm.com/download/win'
    Write-Host '安装完成后重新运行本脚本。'
    Read-Host '按回车退出'
    exit 1
}

if (-not (Test-Path '.git')) {
    git init
}

git branch -M main
git add .

$hasCommit = $false
try {
    git rev-parse --verify HEAD | Out-Null
    $hasCommit = $true
}
catch {
    $hasCommit = $false
}

if ($hasCommit) {
    git commit -m 'Update YOLO11 Chinese medicine detection system'
}
else {
    git commit -m 'Initial commit: YOLO11 Chinese medicine detection system'
}

git remote remove origin 2>$null
git remote add origin git@github.com:SJSBK-UX/Chinese-Mechine-Bi-she-.git
git push -u origin main

Write-Host '[完成] 源码已推送到 GitHub。' -ForegroundColor Green
