#!/usr/bin/env bash
# ============================================================================
# NyaTMC 一键安装脚本（Linux / macOS / Termux）
# 功能：从 GitHub Releases 下载最新版二进制，安装到本地并自动加入 PATH
# 用法：curl -fsSL <本脚本地址> | bash
# ============================================================================
set -euo pipefail

REPO="Yuzumikonami/NyaTMC"
BIN="nyatmc"
INSTALL_DIR="${HOME}/.local/bin"

# ─── 1. 识别系统与架构 ───────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"

case "${OS}" in
  Linux*)  OS="linux" ;;
  Darwin*) OS="darwin" ;;
  *) echo "✗ 不支持的系统: ${OS}" >&2; exit 1 ;;
esac

case "${ARCH}" in
  x86_64|amd64)  ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) echo "✗ 不支持的架构: ${ARCH}" >&2; exit 1 ;;
esac

# Termux：安装到 Termux 专用 bin 目录（已在 PATH 中）
if [ -n "${TERMUX_VERSION:-}" ]; then
  INSTALL_DIR="${PREFIX:-${HOME}}/bin"
fi

# ─── 2. 查询最新 Release ─────────────────────────────────────────
echo "› 正在获取 ${REPO} 最新版本 ..."
VERSION="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
  | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n1)" \
  || { echo "✗ 网络请求失败，请检查网络（或配置代理）" >&2; exit 1; }

if [ -z "${VERSION}" ]; then
  echo "✗ 未查询到 Release，可能尚未发布，请到 https://github.com/${REPO}/releases 查看" >&2
  exit 1
fi

# ↓ 与 Release 产物命名保持一致（goreleaser 模板）
ASSET="nyatmc-${OS}-${ARCH}.tar.gz"
URL="https://github.com/${REPO}/releases/download/${VERSION}/${ASSET}"

# ─── 3. 下载并解压 ───────────────────────────────────────────────
TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT

echo "› 下载 ${URL}"
curl -fL --progress-bar "${URL}" -o "${TMP}/${ASSET}"
tar -xzf "${TMP}/${ASSET}" -C "${TMP}"

# ─── 4. 安装二进制 ───────────────────────────────────────────────
BIN_SRC="$(find "${TMP}" -type f -name "${BIN}" | head -n1)"
if [ -z "${BIN_SRC}" ]; then
  echo "✗ 压缩包内未找到 ${BIN} 二进制" >&2
  exit 1
fi

mkdir -p "${INSTALL_DIR}"
install -m 0755 "${BIN_SRC}" "${INSTALL_DIR}/${BIN}"

# ─── 5. 加入 PATH ────────────────────────────────────────────────
case ":${PATH}:" in
  *":${INSTALL_DIR}:"*)
    echo "› ${INSTALL_DIR} 已在 PATH 中"
    ;;
  *)
    RC="${HOME}/.bashrc"
    if [ "${SHELL:-}" = */zsh ] && [ -f "${HOME}/.zshrc" ]; then
      RC="${HOME}/.zshrc"
    fi
    printf '\n# added by nyatmc installer\nexport PATH="%s:$PATH"\n' "${INSTALL_DIR}" >> "${RC}"
    echo "› 已将 ${INSTALL_DIR} 写入 ${RC}"
    echo "  请执行: source ${RC} （或重新打开终端）"
    ;;
esac

echo ""
echo "✔ 安装完成: ${INSTALL_DIR}/${BIN} (${VERSION})"
echo "  运行 nyatmc version 验证喵～"
