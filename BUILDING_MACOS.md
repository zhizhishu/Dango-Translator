# 使用 GitHub Actions 分布式编译 macOS（支持 arm64 与 x64）

本仓库已提供完善的 GitHub Actions 工作流，可一键在 GitHub 云端构建可运行于 macOS 的 DangoTranslator 应用（.app）。
- 支持架构：Apple Silicon（arm64）与 Intel（x64）
- 支持分布式并行构建：一次点击同时出两套产物
- 支持打 Tag 自动出包并创建 Release

重要说明：GitHub 官方托管的 macOS Runner 目前主要提供 x64 环境。要生成原生 arm64 产物，推荐配置一台自托管的 Apple Silicon Runner（见下文“配置自托管 arm64 Runner”）。

---

## 一键触发构建（最简单）

1) 打开仓库页面 → Actions → 选择工作流 “Build macOS App (x64/arm64)”
2) 右侧点击 “Run workflow”，根据需要选择：
   - 架构 arch：arm64 / x64 / both（both 会并行构建两套产物）
   - create_release：是否在构建完成后自动创建 GitHub Release
3) 点击绿色 “Run workflow” 按钮开始。
4) 等待 3～15 分钟（取决于网络与 Runner 性能）。
5) 打开本次运行页面，向下找到 Artifacts：
   - DangoTranslator-macos-arm64.zip（Apple Silicon 原生）
   - DangoTranslator-macos-x64.zip（Intel）

提示：若你没有配置自托管 arm64 Runner，选择 arm64 或 both 时，arm64 任务会排队等待离线的 Runner。此时可先选择 x64 进行验证，或尽快配置自托管 Runner。

---

## 通过打 Tag 自动出包

向仓库推送以 `macos-v*` 开头的标签，会自动：
- 并行构建 x64 与 arm64 两套产物
- 创建同名 GitHub Release 并上传产物

示例：

```bash
# 在本地创建并推送一个 tag
git tag macos-v0.1.0
git push origin macos-v0.1.0
```

---

## 配置自托管 arm64 Runner（Apple Silicon）

要在 GitHub Actions 上原生构建 arm64，请准备一台 Apple Silicon Mac 并按以下步骤配置。

1) 准备环境（一次性）
   - 安装 Xcode Command Line Tools：`xcode-select --install`
   - 安装 Homebrew（可选）：`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

2) 在仓库中注册 Runner
   - 打开仓库 → Settings → Actions → Runners → New self-hosted runner
   - 选择 macOS，按照页面提示复制命令到你的 Apple Silicon 机器执行：
     - 下载 runner 压缩包
     - `./config.sh` 引导注册（建议追加自定义标签 `ARM64`，按提示输入）
     - 以服务方式运行：`./svc.sh install && ./svc.sh start`（或 `./run.sh` 前台运行）

3) 验证 Runner 在线
   - 回到 GitHub 页面，可见新的自托管 Runner 处于 Online 状态
   - 本仓库的工作流已将 arm64 任务的 runs-on 设置为：`[self-hosted, macos, ARM64]`
   - 若你使用了其它自定义标签，请保持工作流与 Runner 标签一致

完成后，再次在 Actions 中选择 `arch=arm64` 或 `arch=both` 运行，即可产出 arm64 包。

---

## 构建产物与使用

- 产物名称：
  - `DangoTranslator-macos-arm64.zip` → 解压后得到 `DangoTranslator.app`
  - `DangoTranslator-macos-x64.zip` → 解压后得到 `DangoTranslator.app`
- 运行方式：首次运行可能提示未签名，前往 系统设置 → 隐私与安全，允许来自未知开发者的应用，或在 Finder 中右键 → 打开。

---

## 依赖与打包要点（已在工作流自动处理）

- 自动过滤 Windows 专用依赖：`pywin32`、`winreglib`、`system_hotkey` 等
- 使用 macOS 兼容包：`opencv-python-headless`、`scikit-image`、`PyQt5>=5.15.10,<6`
- Homebrew 自动安装 OCR 相关依赖：`tesseract`, `leptonica`（以及可选的 `tesseract-lang`）
- 使用 PyInstaller 生成 `.app`，并打包 `config/` 与 `ui/static/` 资源目录

---

## 常见问题（FAQ）

- arm64 构建一直排队/等待：
  - 需要先配置自托管 Apple Silicon Runner；或先选择 x64 验证。
- 启动时提示未签名：
  - 本仓库默认不做签名/公证，属于开发者构建。请在 系统设置 → 隐私与安全 中允许运行，或右键 → 打开。
- OCR 简体中文识别缺少 `chi_sim`：
  - Runner 已尝试安装 `tesseract-lang`。若用户本机仍缺失，可执行：
    ```bash
    brew install tesseract
    brew install tesseract-lang || true
    ```
- 需要统一对外发布：
  - 建议打 `macos-v*` 标签触发构建与自动 Release。

---

## 本地验证（可选）

```bash
python3 -m venv .venv && source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
# 过滤 Windows 依赖
FILTERED=/tmp/requirements.macos.txt
grep -v -E '^(pywin32|winreglib|opencv_python|scikit_image|skimage|system_hotkey)=' requirements.txt > "$FILTERED" || true
pip install -r "$FILTERED" opencv-python-headless scikit-image pyinstaller

# 打包
pyinstaller --clean --noconfirm --windowed \
  --name DangoTranslator \
  --add-data "config:config" \
  --add-data "ui/static:ui/static" \
  app.py

open dist/DangoTranslator.app
```
