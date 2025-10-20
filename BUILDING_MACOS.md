# 使用 GitHub Actions 编译 macOS 版本

本仓库已提供 GitHub Actions 工作流，会在 macOS Runner 上自动打包 PyQt5 应用为可执行的 `.app`，并上传构建产物。

## 触发构建

有两种方式触发：

1. 手动执行（推荐）：
   - 打开 GitHub 仓库页面 → Actions → 选择 "Build macOS App" → Run workflow。

2. 推送标签：
   - 推送以 `macos-v*` 开头的标签，将自动触发构建。例如：

```bash
git tag macos-v0.1.0
git push origin macos-v0.1.0
```

## 构建结果

- Workflow 会输出 `DangoTranslator-macos.zip` 归档包，其中包含 `DangoTranslator.app`。
- 在 Actions 的构建页面点击 "Artifacts" 即可下载。

## 注意事项

- 构建过程中会自动：
  - 过滤仅适用于 Windows 的依赖（pywin32、winreglib、system_hotkey 等）。
  - 使用 macOS 可用的替代包（opencv-python-headless、scikit-image）。
  - 通过 PyInstaller 打包，并附带 `config/` 与 `ui/static/` 资源目录。
- 该包为未签名应用，首次在 macOS 上运行可能需要在 系统设置 → 隐私与安全 中允许运行。
- 若 OCR 使用 tesseract 的简体中文语言包（chi_sim），已在 Runner 上安装；最终用户若本地缺失，可执行：

```bash
brew install tesseract
# 若系统缺少中文语言数据，可安装（可能随 Homebrew 版本变化）：
brew install tesseract-lang || true
```

## 本地验证（可选）

如需在本地 macOS 上验证：

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
