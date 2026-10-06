/**
 * 平台检测：识别访问者操作系统，用于安装模块自动选中对应命令。
 *
 * 检测优先级（仅在客户端 onMounted 后执行，避免 SSR 水合不匹配）：
 *   1. navigator.userAgentData.platform  —— Chromium 系（现代标准，UA-CH）
 *   2. navigator.platform                —— Safari / Firefox / 旧浏览器
 *   3. navigator.userAgent               —— 兜底字符串解析
 *
 * 规则：
 *   - 包含 "win"                          → Windows
 *   - 包含 "mac" / "darwin" / "iphone" / "ipad" → macOS
 *   - 其余（linux / android(Termux) / cros）    → Linux
 */
export type Platform = 'windows' | 'macos' | 'linux'

export function detectPlatform(): Platform {
  if (typeof navigator === 'undefined') return 'linux'

  const uaData = (navigator as Navigator & { userAgentData?: { platform?: string } }).userAgentData
  const plat = (uaData?.platform ?? navigator.platform ?? navigator.userAgent).toLowerCase()

  if (plat.includes('win')) return 'windows'
  if (plat.includes('mac') || plat.includes('darwin') || plat.includes('iphone') || plat.includes('ipad')) return 'macos'
  // Linux 桌面、Android（Termux）与 ChromeOS 都归入 Linux 分支
  return 'linux'
}

export function usePlatform() {
  const platform = ref<Platform>('linux')
  const detected = ref(false)

  onMounted(() => {
    platform.value = detectPlatform()
    detected.value = true
  })

  return { platform, detected }
}
