### 如何使用 GitHub Codespaces 进行开发

此项目已配置为在 GitHub Codespaces 中一键启动。

步骤：

1. 将配置文件添加到您的仓库：
   - 在仓库根目录下创建一个 `.devcontainer` 文件夹（若已存在可跳过）。
   - 将 `devcontainer.json` 和 `post-create.sh` 文件放入该文件夹。
   - 提交并推送这些更改。

2. 启动 Codespace：
   - 在您的 GitHub 仓库页面上，点击绿色的 `<> Code` 按钮。
   - 切换到 "Codespaces" 选项卡。
   - 点击 "Create codespace on main" 按钮。

3. 等待环境自动配置：
   - GitHub 将为您创建一个云端开发环境。请耐心等待，`.devcontainer/post-create.sh` 脚本会自动运行并安装所有依赖项。您可以在终端日志中看到安装过程。

4. 编译项目：
   - 当环境就绪后，在 VS Code 的终端中运行以下命令：

```bash
# 创建构建目录
mkdir -p build && cd build

# 运行 CMake 配置项目
cmake ..

# 执行编译
make
```

5. 运行（仅限测试）：
   - 编译成功后，您可以在 `build` 目录下找到生成的可执行文件，并在 Codespaces 的终端中运行它（注意：由于 Codespaces 没有图形界面，带 UI 的程序将无法显示，但此步骤可验证编译是否成功）。
