# 药品检测系统手机 App 方案资料包

本目录用于存放药品检测系统 Android App 云服务器方案的规划、开发、设计和部署资料。

当前实施方案：

- 手机端使用原生 Android WebView 加载云服务器上的 Vue 前端。
- Spring Boot、Flask YOLO、MySQL 部署到 4 核 8G 阿里云服务器。
- Nginx 作为统一入口，对外提供 HTTPS 域名，对内转发到 Spring Boot 和 Flask。
- App 不直接连接 MySQL，也不在手机端运行 YOLO 模型。

文档清单：

- [开发文档.md](./开发文档.md)：说明 Android App 改造、接口地址调整、Capacitor 打包和本地联调流程。
- [设计文档.md](./设计文档.md)：说明系统架构、模块划分、数据流、接口规划和安全设计。
- [部署文档.md](./部署文档.md)：说明阿里云 4 核 8G 服务器部署步骤、Nginx、systemd、数据库和上线检查。
- [android_webview](./android_webview)：Android 手机 App 工程，可用 Android Studio 打包 APK。

建议先阅读顺序：

1. 设计文档
2. 开发文档
3. 部署文档
