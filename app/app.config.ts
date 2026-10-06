/**
 * NyaTMC 主站运行时配置
 *
 * installShUrl / installPs1Url：安装脚本地址。
 *   默认指向本仓库（nyatmc-homepage）raw 链接，push 到 GitHub 后即可直接使用；
 *   部署到自有域名后，可改成 "https://<你的域名>/install.sh" 这类短链接，
 *   脚本文件位于 public/install.sh 与 public/install.ps1。
 */
export default defineAppConfig({
  nyatmc: {
    github: 'https://github.com/Yuzumikonami/NyaTMC',
    releases: 'https://github.com/Yuzumikonami/NyaTMC/releases',
    issues: 'https://github.com/Yuzumikonami/NyaTMC/issues',
    authorSite: 'https://www.konatonami.top/',
    installShUrl: 'https://raw.githubusercontent.com/Yuzumikonami/nyatmc-homepage/main/public/install.sh',
    installPs1Url: 'https://raw.githubusercontent.com/Yuzumikonami/nyatmc-homepage/main/public/install.ps1',
    // Release 资产命名约定（与 install 脚本保持一致）
    assets: ['nyatmc-linux-amd64.tar.gz', 'nyatmc-linux-arm64.tar.gz', 'nyatmc-darwin-amd64.tar.gz', 'nyatmc-darwin-arm64.tar.gz', 'nyatmc-windows-amd64.zip', 'nyatmc-windows-arm64.zip'],
  },
})
