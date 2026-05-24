$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$flaskDir = Join-Path $root 'MedicineDetection_flask'
$springDir = Join-Path $root 'MedicineDetection_springboot'
$vueDir = Join-Path $root 'MedicineDetection_vue'
$yoloConfigDir = Join-Path $flaskDir '.ultralytics'
$mavenRepoDir = Join-Path $root '.m2repo'
$mavenUserHome = Join-Path $root '.m2wrapper'
$mavenSettings = Join-Path $root 'maven-settings.local.xml'

New-Item -ItemType Directory -Force -Path $yoloConfigDir, $mavenRepoDir, $mavenUserHome | Out-Null

function Write-Step {
    param([string]$Message)
    Write-Host "[启动脚本] $Message" -ForegroundColor Cyan
}

function Find-CommandPath {
    param([string[]]$Names)
    foreach ($name in $Names) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) {
            return $cmd.Source
        }
    }
    return $null
}

function Find-JavaHome {
    $candidates = @()

    if ($env:JAVA_HOME) {
        $candidates += $env:JAVA_HOME
    }

    $userHome = [Environment]::GetFolderPath('UserProfile')
    $candidates += @(
        (Join-Path $userHome '.jdks\corretto-1.8.0_482'),
        (Join-Path $userHome '.jdks\temurin-8'),
        (Join-Path $userHome '.jdks\temurin-17'),
        (Join-Path $userHome '.jdks\temurin-24')
    )

    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path (Join-Path $candidate 'bin\java.exe'))) {
            return $candidate
        }
    }

    $searchRoots = @(
        (Join-Path $userHome '.jdks'),
        'C:\Program Files\Java',
        'C:\Program Files\Eclipse Adoptium',
        'C:\Program Files\Amazon Corretto'
    )

    foreach ($searchRoot in $searchRoots) {
        if (-not (Test-Path $searchRoot)) {
            continue
        }
        $found = Get-ChildItem -LiteralPath $searchRoot -Directory -ErrorAction SilentlyContinue |
            Sort-Object Name |
            Where-Object { Test-Path (Join-Path $_.FullName 'bin\java.exe') } |
            Select-Object -First 1

        if ($found) {
            return $found.FullName
        }
    }

    return $null
}

function Test-PythonModule {
    param(
        [string]$PythonExe,
        [string]$ModuleName
    )

    & $PythonExe -c "import importlib.util; raise SystemExit(0 if importlib.util.find_spec('$ModuleName') else 1)" | Out-Null
    return $LASTEXITCODE -eq 0
}

function Ensure-PythonDependencies {
    param([string]$PythonExe)

    $required = @('flask', 'flask_socketio', 'ultralytics', 'openai')
    $missing = @()

    foreach ($module in $required) {
        if (-not (Test-PythonModule -PythonExe $PythonExe -ModuleName $module)) {
            $missing += $module
        }
    }

    if ($missing.Count -eq 0) {
        Write-Step "Python 依赖已就绪。"
        return
    }

    Write-Step "检测到缺少 Python 依赖：$($missing -join ', ')，开始自动安装。"
    & $PythonExe -m pip install @missing --default-timeout=1000
}

function Ensure-FrontendDependencies {
    param([string]$NpmCmd)

    if (Test-Path (Join-Path $vueDir 'node_modules')) {
        Write-Step "前端 node_modules 已存在，跳过安装。"
        return
    }

    Write-Step "前端依赖不存在，开始执行 npm install。"
    Set-Location -LiteralPath $vueDir
    & $NpmCmd install
    Set-Location -LiteralPath $root
}

function Test-PortListening {
    param([int]$Port)

    try {
        return [bool](Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction Stop | Select-Object -First 1)
    }
    catch {
        $pattern = ":(?:$Port)\s+.*LISTENING"
        return [bool]((netstat -ano | Select-String -Pattern $pattern) | Select-Object -First 1)
    }
}

function Start-ServiceWindow {
    param(
        [string]$Title,
        [string]$CommandText
    )

    Start-Process -FilePath 'powershell.exe' -ArgumentList @(
        '-NoExit',
        '-ExecutionPolicy', 'Bypass',
        '-Command', $CommandText
    ) | Out-Null

    Write-Step "$Title 已在新窗口中启动。"
}

$pythonExe = Find-CommandPath -Names @('python', 'py')
if (-not $pythonExe) {
    throw '未检测到 Python，请先安装 Python 3。'
}

$npmCmd = Find-CommandPath -Names @('npm.cmd')
if (-not $npmCmd) {
    throw '未检测到 npm.cmd，请先安装 Node.js。'
}

$javaHome = Find-JavaHome
if (-not $javaHome) {
    throw '未检测到可用的 JDK，请先安装 Java 8 或更高版本。'
}

$javaHomeEscaped = $javaHome.Replace("'", "''")
$pythonExeEscaped = $pythonExe.Replace("'", "''")
$npmCmdEscaped = $npmCmd.Replace("'", "''")
$flaskDirEscaped = $flaskDir.Replace("'", "''")
$springDirEscaped = $springDir.Replace("'", "''")
$vueDirEscaped = $vueDir.Replace("'", "''")
$yoloConfigDirEscaped = $yoloConfigDir.Replace("'", "''")
$mavenRepoDirEscaped = $mavenRepoDir.Replace("'", "''")
$mavenUserHomeEscaped = $mavenUserHome.Replace("'", "''")
$mavenSettingsEscaped = $mavenSettings.Replace("'", "''")

$settingsContent = @"
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository>$mavenRepoDirEscaped</localRepository>
</settings>
"@
$settingsContent | Set-Content -LiteralPath $mavenSettings -Encoding UTF8

Write-Step "开始进行启动前检查。"
Ensure-PythonDependencies -PythonExe $pythonExe
Ensure-FrontendDependencies -NpmCmd $npmCmd

if (-not (Test-PortListening -Port 5000)) {
    $flaskCommand = @"
`$env:YOLO_CONFIG_DIR = '$yoloConfigDirEscaped'
Set-Location -LiteralPath '$flaskDirEscaped'
& '$pythonExeEscaped' 'main.py'
"@
    Start-ServiceWindow -Title 'Flask AI 服务' -CommandText $flaskCommand
}
else {
    Write-Step '检测到 5000 端口已被占用，默认认为 Flask 服务已启动，跳过。'
}

if (-not (Test-PortListening -Port 9999)) {
    $springCommand = @"
`$env:JAVA_HOME = '$javaHomeEscaped'
`$env:MAVEN_USER_HOME = '$mavenUserHomeEscaped'
`$env:Path = '$javaHomeEscaped\bin;' + `$env:Path
Set-Location -LiteralPath '$springDirEscaped'
& '.\mvnw.cmd' '-s' '$mavenSettingsEscaped' '-gs' '$mavenSettingsEscaped' '-DskipTests' 'spring-boot:run'
"@
    Start-ServiceWindow -Title 'Spring Boot 后端' -CommandText $springCommand
}
else {
    Write-Step '检测到 9999 端口已被占用，默认认为 Spring Boot 已启动，跳过。'
}

if (-not (Test-PortListening -Port 8888)) {
    $vueCommand = @"
Set-Location -LiteralPath '$vueDirEscaped'
& '$npmCmdEscaped' 'run' 'dev'
"@
    Start-ServiceWindow -Title 'Vue 前端' -CommandText $vueCommand
}
else {
    Write-Step '检测到 8888 端口已被占用，默认认为前端已启动，跳过。'
}

Write-Host ''
Write-Host '项目启动命令已经全部发出，请稍等几十秒后访问：' -ForegroundColor Green
Write-Host '前端地址: http://127.0.0.1:8888' -ForegroundColor Yellow
Write-Host 'Spring Boot: http://127.0.0.1:9999' -ForegroundColor Yellow
Write-Host 'Flask: http://127.0.0.1:5000' -ForegroundColor Yellow
Write-Host ''
Write-Host '如果是第一次启动，Spring Boot 和 Flask 可能需要更多时间下载依赖。' -ForegroundColor DarkYellow
