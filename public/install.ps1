# ============================================================================
# NyaTMC 一键安装脚本（Windows）
# 功能：从 GitHub Releases 下载最新版二进制，安装到本地并自动加入用户 PATH
# 用法：irm <本脚本地址> | iex
# ============================================================================
$ErrorActionPreference = "Stop"

$Repo       = "Yuzumikonami/NyaTMC"
$Bin        = "nyatmc"
$InstallDir = Join-Path $env:USERPROFILE ".nyatmc\bin"

# ─── 1. 识别架构 ─────────────────────────────────────────────────
$Arch = $env:PROCESSOR_ARCHITECTURE
switch ($Arch) {
  "AMD64" { $Arch = "amd64" }
  "ARM64" { $Arch = "arm64" }
  default {
    Write-Host "✗ 不支持的架构: $Arch" -ForegroundColor Red
    exit 1
  }
}

# ─── 2. 查询最新 Release ─────────────────────────────────────────
Write-Host "› 正在获取 $Repo 最新版本 ..."
$Release = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest"
$Version = $Release.tag_name

# ↓ 与 Release 产物命名保持一致（goreleaser 模板）
$AssetName = "nyatmc-windows-$Arch.zip"
$Asset = $Release.assets | Where-Object { $_.name -eq $AssetName }
if (-not $Asset) {
  Write-Host "✗ 未找到 $AssetName，请到 $($Release.html_url) 手动下载" -ForegroundColor Red
  exit 1
}

# ─── 3. 下载并解压 ───────────────────────────────────────────────
$Tmp = Join-Path ([IO.Path]::GetTempPath()) ("nyatmc-install-" + [IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Force -Path $Tmp | Out-Null

Write-Host "› 下载 $($Asset.browser_download_url)"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Zip = Join-Path $Tmp $AssetName
Invoke-WebRequest -Uri $Asset.browser_download_url -OutFile $Zip
Expand-Archive -Path $Zip -DestinationPath $Tmp -Force

# ─── 4. 安装二进制 ───────────────────────────────────────────────
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

$Exe = Get-ChildItem -Path $Tmp -Recurse -Filter "$Bin.exe" | Select-Object -First 1
if (-not $Exe) {
  Write-Host "✗ 压缩包内未找到 $Bin.exe" -ForegroundColor Red
  exit 1
}
Copy-Item $Exe.FullName -Destination (Join-Path $InstallDir "$Bin.exe") -Force
Remove-Item -Recurse -Force $Tmp

# ─── 5. 加入用户 PATH ────────────────────────────────────────────
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
  [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", "User")
  Write-Host "› 已将 $InstallDir 加入用户 PATH（重新打开终端后生效）"
} else {
  Write-Host "› $InstallDir 已在 PATH 中"
}

Write-Host ""
Write-Host "✔ 安装完成: $InstallDir\$Bin.exe ($Version)" -ForegroundColor Green
Write-Host "  运行 nyatmc version 验证喵～"
