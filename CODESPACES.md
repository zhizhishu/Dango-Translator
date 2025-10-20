# 在 GitHub Codespaces 中开发与排错（超详细小白版）

本仓库已适配 GitHub Codespaces（云端 Linux 开发环境）。你只需要几步就能在浏览器里打开项目并开始改代码。
注意：这是一个 Windows 桌面应用（PyQt5）。Codespaces 是无图形界面的 Linux 环境，所以不适合运行完整 GUI 程序，但非常适合：改代码、跑非 GUI 脚本、写/跑测试、做代码检查。

---

## 一、快速开始（3 步）

1) 打开 Codespaces
- 打开 GitHub 仓库页面 -> 右上角绿色按钮 “<> Code” -> 选择 “Codespaces” 标签 -> “Create codespace on main/指定分支”。

2) 等待自动配置
- 首次创建会自动安装依赖（大约 2~5 分钟）。
- 安装日志会自动输出在终端窗口，耐心等待结束。
- 成功后你会看到类似提示：Environment setup complete.

3) 验证环境是否可用
在 VS Code 终端执行：

```bash
python --version
python -c "import PyQt5, cv2, PIL, yaml, requests; print('Python deps OK')"
```
看到 “Python deps OK” 就说明基础依赖安装好了。

---

## 二、遇到 “Recovery mode/恢复模式” 的解决办法
当 Codespace 创建失败时，会出现如下提示：
This codespace is currently running in recovery mode due to a container error/configuration error.

请按下面步骤排查：

1) 查看创建日志
- 按 Cmd/Ctrl + Shift + P -> 输入 “Codespaces: View Creation Log” -> 回车。
- 拉到日志底部，找到第一处报错（通常是某个 apt 包或 pip 包安装失败）。

2) 本仓库已修正的常见问题
- 先前 devcontainer 使用了 C++ 镜像和错误的 apt 包名 tesseract-ocr-sim，导致容器创建失败。
- 现在已改为 Python 镜像，并在 .devcontainer/post-create.sh 中：
  - 安装了通用的运行库：libgl1、libxrender1 等，避免 cv2/PyQt5 运行时缺库；
  - 安装 tesseract-ocr 与中文字体（fonts-noto-cjk）；
  - 自动用 pip 安装 requirements.txt 中的 Linux 兼容子集（自动跳过 Windows 专用包：pywin32、winreglib、system_hotkey）。

3) 修复并重试
- 如果你改过 .devcontainer 相关文件：保存更改 -> 推到仓库。
- 在 Codespaces 里按 Cmd/Ctrl + Shift + P -> “Codespaces: Rebuild Container”（重建容器）。
- 重建完成后，重复“一、快速开始”的第 3 步做验证。

---

## 三、在 Codespaces 里能做什么？
- 编辑与提交代码。
- 运行非 GUI 的脚本、处理数据、跑测试。
- 进行代码检查（比如运行 flake8、black、pytest 等）。

示例：
```bash
# 安装/升级你需要的 Python 包（按需）
pip install -U requests PyYAML Pillow opencv-python PyQt5

# 运行一个简单脚本（示例）
python - <<'PY'
import requests, yaml
print('Network OK:', requests.get('https://www.baidu.com', timeout=5).status_code)
print('PyYAML OK:', yaml.safe_load('a: 1'))
PY
```

---

## 四、注意事项（踩坑必看）
- 不能显示桌面 GUI：Codespaces 没有图形界面，运行 QApplication()/显示窗口会失败；建议仅做代码开发与非 GUI 测试。
- Windows 专用依赖：requirements.txt 里有 pywin32、winreglib、system_hotkey 等，仅在 Windows 可用；我们的脚本会在 Codespaces 中自动跳过这些包。
- OpenCV/PyQt5 运行库：我们已自动安装 libgl1、libxrender1、libxext6 等常见依赖，避免常见的 “libGL.so.1 not found” 等错误。

---

## 五、常见报错与对策
- ImportError: libGL.so.1 not found
  - 已在 post-create.sh 安装 libgl1，若仍报错：执行 `sudo apt-get update && sudo apt-get install -y libgl1`。

- ModuleNotFoundError: No module named 'PyQt5'（或其他包）
  - 执行 `pip install PyQt5==5.15.6`（或安装缺失包）。

- 网络安装慢/失败
  - 多重试几次，或者等几分钟再 “Rebuild Container”。

- No space left on device
  - 删除不用的 Codespaces 实例或仓库缓存，释放空间。

---

## 六、我只想本地（Windows）完整运行 GUI 怎么办？
- 本项目主要面向 Windows 桌面环境。要运行完整 GUI，请在 Windows 上安装依赖并运行 `python app.py`。
- Codespaces 仅作为云端编辑/非 GUI 调试环境。

---

## 七、相关文件说明
- .devcontainer/devcontainer.json：指定容器镜像（Python）与创建后执行脚本。
- .devcontainer/post-create.sh：安装系统运行库 + pip 安装 Python 依赖（自动跳过 Windows-only 包）。

如果你仍然卡在恢复模式，可以把创建日志里“第一个报错”复制出来到 issue，我们再一起看。
