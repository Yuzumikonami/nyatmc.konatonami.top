# NyaTMC Homepage

> [NyaTMC](https://github.com/Yuzumikonami/NyaTMC/) 项目主页 —— 用 Go 编写的 Minecraft 服务器全能管理工具的官方介绍站。
> 风格延续 [konatonami.top](https://www.konatonami.top/)，部署在 Cloudflare Workers 上。

**技术栈**：Nuxt 4 · Vue 3 · TypeScript · Tailwind CSS 4 · Nuxt UI 4 · pnpm

---

## 快速开始

```bash
pnpm install     # 安装依赖（postinstall 自动执行 nuxt prepare）
pnpm dev         # 本地开发 → http://localhost:3000
pnpm build       # 构建（cloudflare-module preset，产出 .output/）
pnpm preview     # 用 miniflare 本地预览 Worker
```

## 目录结构

```
nyatmc/
├── app/                          # Nuxt 4 srcDir
│   ├── app.vue                   # 根组件：UApp + NuxtLayout + NuxtPage
│   ├── app.config.ts             # 运行时配置（仓库/Release/安装脚本地址）
│   ├── assets/css/main.css       # Tailwind 4 + Nuxt UI 主题（蓝主色、动画、暗色）
│   ├── layouts/default.vue       # 全局布局：Navbar + 内容 + Footer
│   ├── pages/index.vue           # 唯一页面：组装各板块 + SEO meta
│   ├── composables/
│   │   └── usePlatform.ts        # 平台检测（Windows / macOS / Linux）
│   └── components/
│       ├── AppNavbar.vue         # 吸顶导航：logo、锚点、主题切换、GitHub
│       ├── HeroSection.vue       # 首屏：标题、标签、CTA、TUI 界面预览
│       ├── FeatureGrid.vue       # 特性网格 + 架构设计 + 跨平台说明
│       ├── InstallSection.vue    # ★ 安装模块：平台检测 + 命令 + 一键复制
│       ├── RoadmapSection.vue    # 阶段路线图与进度
│       ├── CommandBlock.vue      # 终端风格命令块（复制按钮）
│       └── AppFooter.vue         # 页脚
├── public/
│   ├── favicon.svg
│   ├── install.sh                # Linux/macOS/Termux 一键安装脚本
│   └── install.ps1               # Windows 一键安装脚本
├── .github/workflows/deploy.yml  # push main → 自动部署 Workers
├── nuxt.config.ts                # @nuxt/ui + cloudflare-module preset
├── wrangler.jsonc                # Cloudflare Workers 部署配置
├── tsconfig.json                 # Nuxt 4 references 式 TS 配置
└── package.json
```

## 页面结构与功能模块

单页布局，四个板块自上而下，锚点导航互跳：

| 模块 | 说明 | 实现要点 |
|---|---|---|
| **Navbar** | 吸顶 + 毛玻璃 | `sticky` + `backdrop-blur`；明暗切换走 `useColorMode`（`ClientOnly` 包裹避免水合不匹配） |
| **Hero** | 首屏 | 渐变标题、特性 UBadge、双 CTA；下方用 `<pre>` + box-drawing 字符 + 着色 span 还原 TUI 界面预览，光标 `animate-pulse` |
| **Features** | 9 个特性卡片 + 架构图 | 网格 `sm:grid-cols-2 lg:grid-cols-3`；状态徽章（开发中/计划）；ASCII 架构分层图强调「internal/app 唯一真相源」 |
| **Install** ★ | 平台检测安装模块 | 见下文 |
| **Roadmap** | 阶段 0-9 时间线 | 状态图标（✅/🚧 旋转/📋）+ 顶部进度统计卡 |
| **Footer** | 版权与链接 | 作者主页、GitHub、Releases、GPL-3.0 |

## 安装模块（核心）设计

### 平台检测方案

`app/composables/usePlatform.ts`，仅在客户端 `onMounted` 后检测（避免 SSR 水合不匹配）：

```
navigator.userAgentData.platform   ← Chromium 系（UA-CH，优先）
        ↓ 为空
navigator.platform                 ← Safari / Firefox
        ↓ 为空
navigator.userAgent                ← 兜底字符串解析
```

- 含 `win` → **Windows**
- 含 `mac` / `darwin` / `iphone` / `ipad` → **macOS**
- 其余（linux / android → Termux / cros）→ **Linux**

交互流程：进入页面自动选中检测到的平台并显示「已检测到你的系统」提示条；用户手动切换平台后提示条隐藏（`auto` 标记）。三个标签页始终可见，可自由切换对比。

### 命令展示方式

- **命令块** `CommandBlock.vue`：固定深色终端外观（两种主题下都保持终端质感），mac 三圆点 + `$` 提示符 + 闪烁光标块
- **一键复制**：右上角按钮，`navigator.clipboard.writeText` + `execCommand` 降级（兼容非安全上下文），复制成功后图标变 ✓「已复制」2 秒
- **SSR 安全**：标签页 + 命令区整体包在 `<ClientOnly>` 中，水合前显示骨架屏，彻底规避闪烁与水合告警
- 各平台命令（地址在 `app.config.ts` 中统一配置）：

| 平台 | 命令 |
|---|---|
| Windows | `irm <install.ps1 地址> \| iex` |
| macOS / Linux / Termux | `curl -fsSL <install.sh 地址> \| bash` |
| Go 用户（备选） | `go install github.com/Yuzumikonami/NyaTMC@latest`（不支持自动更新，附警示） |

### 安装脚本逻辑（`public/install.sh` / `install.ps1`）

两个脚本做同一件事：

1. 识别系统与 CPU 架构（amd64 / arm64），Termux 环境自动改用 `$PREFIX/bin`
2. 调 GitHub API 查最新 Release 版本号
3. 下载对应资产（`nyatmc-{os}-{arch}.tar.gz` / `.zip`）并解压
4. 安装到 `~/.local/bin`（Windows 为 `%USERPROFILE%\.nyatmc\bin`）
5. 不在 PATH 时写入 shell rc / 用户级注册表 PATH，提示 `source` 或重开终端

> 资产命名模板写在脚本顶部变量处，与 NyaTMC 的 goreleaser 配置对齐时只需改一处。

## Cloudflare Workers 部署

与 konatonami.top 同方案：`nitro.preset: 'cloudflare-module'`（Worker 模块格式），首页 `routeRules` 预渲染为静态 HTML，资产走 Workers Assets。

**`wrangler.jsonc` 关键项**：`main` 指向 `.output/server/index.mjs`，`assets.directory` 指向 `.output/public` 并绑定 `ASSETS`，`compatibility_flags: ["nodejs_compat"]`。

### 首次部署

```bash
pnpm build
npx wrangler login      # 浏览器授权
npx wrangler deploy     # 上线，得到 *.workers.dev 地址
```

### 自定义域名

Cloudflare Dashboard → Workers → `nyatmc-homepage` → Settings → Domains & Routes → Add → Custom domain（如 `nyatmc.konatonami.top`，前提域名在 CF 托管，自动配证书与路由）。

绑定域名后，建议把 `app/app.config.ts` 里的安装脚本地址换成短链（如 `https://nyatmc.konatonami.top/install.sh`），命令更清爽。

### CI 自动部署（可选）

`.github/workflows/deploy.yml` 已就绪，push `main` 自动构建部署。需在仓库 Settings → Secrets 配置：

- `CF_API_TOKEN`：Cloudflare 令牌（模板 *Edit Cloudflare Workers*）
- `CF_ACCOUNT_ID`：账户 ID（Dashboard 右侧可见）

## 配置速查

所有对外链接集中在 `app/app.config.ts` 的 `nyatmc` 字段：仓库地址、Releases、Issues、作者主页、两个安装脚本地址、Release 资产命名清单。换仓库 / 换域名只改这一个文件。

## 推送到 GitHub

```bash
git init && git add . && git commit -m "feat: init NyaTMC homepage"
# 在 GitHub 新建 nyatmc-homepage 仓库后：
git remote add origin https://github.com/Yuzumikonami/nyatmc-homepage.git
git push -u origin main
```

> 仓库名若不是 `nyatmc-homepage`，记得同步更新 `app.config.ts` 里安装脚本的 raw 链接。

---

<div align="center">

© Yuzumikonami（柚见小南） · 用 🐾 和 ❤️ 搭建喵w ~ 🐾

</div>
