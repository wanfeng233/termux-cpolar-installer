# Termux Cpolar Installer

一个用于在 Termux 上安装 [cpolar](https://cpolar.com) 的简单脚本。

## 项目简介

Termux Cpolar Installer 是一个自动化脚本，用于在 Termux 环境中安装 cpolar。通过这个脚本，你可以极速安装 cpolar 。

## 安装步骤

在 Termux 中运行以下命令下载脚本：

```bash
curl -sL https://raw.githubusercontent.com/wanfeng233/termux-cpolar-installer/main/install_cpolar_for_termux.sh -o install_cpolar_for_termux.sh && bash install_cpolar_for_termux.sh
```

## termux for cpolar 使用方法

安装完成后，你可以使用以下命令管理 cpolar：

- 启动 cpolar：

```bash
sv up cpolar
```

- 开启 cpolar 自启动：

```bash
sv-enable cpolar
```

- 停止 cpolar：

```bash
sv down cpolar
```

- 禁用 cpolar 自启动：

```bash
sv-disable cpolar
```

- 后台面板

开放端口默认为 9200

[http://127.0.0.1:9200/](http://127.0.0.1:9200)

## 致谢

感谢[cpolar](cpolar.com)和[Termux](termux.dev)团队提供的优秀工具。

