# 🌐 Mira Browser — AI-Accelerated Chromium Mobile Web Browser (`v2.0.0`)

[![GitHub Release](https://img.shields.io/github/v/release/apravint/mira-browser-android?color=cyan&label=Latest%20Release)](https://github.com/apravint/mira-browser-android/releases/tag/v2.0.0)
[![CI/CD Status](https://github.com/apravint/mira-browser-android/actions/workflows/build-apk.yml/badge.svg)](https://github.com/apravint/mira-browser-android/actions/workflows/build-apk.yml)
[![Target SDK](https://img.shields.io/badge/Target%20SDK-35%20(Android%2015)-green.svg)](https://developer.android.com/about/versions/15)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Mira Browser** is an open-source, hardware-accelerated mobile web browser for Android built with Flutter and Chromium WebView (`androidx.webkit`). It combines an intelligent Omnibox, a multi-tab card manager, the **Mira Shield** privacy blocker, the **Mira AI Assistant**, and sharp brutalist glassmorphic styling.

Developed by **Ayyappa Pravin** (<apravint@gmail.com>).

---

## ⚡ Key Features

- 🌐 **Native Chromium WebView Engine**: Hardware-accelerated GPU web rendering with zero iframe restrictions or CORS limits. Supports real-world web applications (Google, YouTube, GitHub, Wikipedia, Reddit, ChatGPT, DuckDuckGo).
- 🗂️ **Multi-Tab Card Grid Manager**: Open unlimited simultaneous tabs, switch between pages with live card previews, close tabs with a tap, and launch isolated **Incognito / Private Browsing** sessions.
- 🛡️ **Mira Shield (Ad & Tracker Blocker)**: Native domain-level network request interceptor blocking 40+ tracking networks, telemetry pixels, and intrusive ad scripts before transmission—increasing page load speeds by up to 3x.
- ⚡ **Mira AI Assistant Drawer**: Slide-out neural copilot that reads active page titles and URLs to provide:
  - 📌 **One-Tap Page Summarization** (Instant key bullet points)
  - 🎯 **Actionable Takeaways Extraction**
  - 🌐 **Multi-Language Translation**
  - 💡 **Interactive Prompting & Q&A**
- 🚀 **Speed Dial Start Hub**: High-contrast dashboard with top site shortcuts (Google, YouTube, DuckDuckGo, Wikipedia, GitHub, Reddit, ChatGPT, HackerNews, X), live privacy shield statistics, and search engine integration.
- 🔒 **Security & Omnibox**: Real-time SSL padlock badge (`https` lock vs `http` warning), auto-detects URL vs search queries, and instant clear/reload triggers.
- 🎨 **6 Handcrafted Themes**: Tokyo Night, Cyberpunk Neon, OLED Stealth, Nord Frost, Catppuccin Mocha, and Solar Amber with strict sharp brutalist geometry (`BorderRadius.zero`).
- ⭐ **Bookmarks & History Manager**: Instant bookmarking with search, timestamped history logs, and one-tap history clearing.
- 💻 **Desktop Mode Switch**: Toggle between mobile and desktop user agents on the fly.

---

## 🎨 Design System & FigCraft Mockups

All interface mockups are authored in **FigCraft** (Storytold Craft Suite):
- Native project file: [`design/mira_browser.figcraft`](design/mira_browser.figcraft)
- High-res preview: [`design/mira_browser_preview.png`](design/mira_browser_preview.png)
- Vector frames:
  - `Start Hub (Speed Dial & Shield)` (412 × 915)
  - `Multi-Tab Card Manager` (412 × 915)
  - `Mira AI Assistant Drawer` (412 × 915)

---

## 📦 Direct Downloads

Download precompiled release APKs directly from **[GitHub Releases v2.0.0](https://github.com/apravint/mira-browser-android/releases/tag/v2.0.0)**:

| Architecture | Package |
| :--- | :--- |
| **64-bit ARM (Recommended)** | `MiraBrowser-arm64-v8a.apk` |
| **32-bit ARM** | `MiraBrowser-armeabi-v7a.apk` |
| **Universal All-in-One** | `MiraBrowser-Universal.apk` |

---

## 🛠️ Build from Source

```bash
# Clone the repository
git clone https://github.com/apravint/mira-browser-android.git
cd mira-browser-android

# Fetch dependencies
flutter pub get

# Run code analyzer and test suite
flutter analyze
flutter test

# Build release APK
flutter build apk --release --split-per-abi
```

---

## 📄 License
Licensed under the [MIT License](LICENSE).
