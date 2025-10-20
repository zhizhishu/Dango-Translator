### 在 GitHub Codespaces 中一键开发/运行

此项目已提供 Codespaces Dev Container，首次启动会自动安装系统依赖（Qt 运行库、Tesseract 及简体中文语言包等）和 Python 依赖，并创建虚拟环境 `.venv`。

步骤：

1. 将配置文件添加到仓库：
   - `.devcontainer/devcontainer.json` 与 `.devcontainer/post-create.sh` 已包含本仓库中；若您 fork 了仓库，请确保一并推送。

2. 启动 Codespace：
   - 在 GitHub 仓库页面点击绿色的 `<> Code` 按钮。
   - 切换到 "Codespaces" 选项卡。
   - 点击 "Create codespace on main"。

3. 等待环境自动配置：
   - Codespaces 会自动执行 `./.devcontainer/post-create.sh` 完成环境安装。
   - 新打开的终端会自动激活虚拟环境 `.venv`。

4. 运行项目：

```bash
# 如未自动激活，可手动激活虚拟环境
source .venv/bin/activate

# 运行应用（Codespaces 无图形界面，窗口无法显示，仅用于验证依赖是否正确安装）
python app.py
```

5. 注意事项：
- Codespaces 为无图形界面环境，PyQt5 UI 窗口不会显示；您仍可进行代码编辑、依赖管理和非 UI 逻辑的调试。
- 脚本会自动忽略仅在 Windows 可用的依赖（如 `pywin32`、`winreglib`），并在 Linux 下安装兼容替代项（如 `opencv-python-headless`）。
- 已安装 `tesseract-ocr` 与 `tesseract-ocr-chi-sim`，可在无 UI 情况下测试 OCR 能力。
