<script setup lang="ts">
const cfg = useAppConfig().nyatmc

useSeoMeta({
  title: 'NyaTMC — Minecraft 服务器全能管理工具',
  description: '用 Go 编写的 Minecraft 服务器管理工具：TUI 主界面、CLI 脚本接口、Web 远程补充。单二进制、零依赖、跨平台（Linux / Windows / Termux）。',
  ogTitle: 'NyaTMC',
  ogDescription: '用 Go 编写的 Minecraft 服务器全能管理工具 —— 单二进制 · 零依赖 · 跨平台',
  ogType: 'website',
  twitterCard: 'summary_large_image',
})

useHead({
  link: [{ rel: 'canonical', href: 'https://nyatmc.konatonami.top/' }],
})
</script>

<template>
  <div>
    <HeroSection />
    <FeatureGrid />
    <InstallSection />
    <RoadmapSection />
  </div>
</template>
