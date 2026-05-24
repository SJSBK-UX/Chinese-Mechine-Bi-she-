# 安卓 WebView App 工程

这个目录是手机 App 专用工程，采用云服务器方案：Android 原生 WebView 加载服务器上的 Vue 前端，业务接口仍由 Nginx 统一转发到 Spring Boot 和 Flask。

## 当前配置

- App 包名：`com.medicinedetection.app`
- 默认入口：`http://47.118.23.173/`
- 支持能力：网页访问、文件选择、图片/视频读取、相机权限、WebRTC/媒体权限请求。

## 构建方式

用 Android Studio 打开 `MedicineDetection_mobile_app/android_webview`，等待 Gradle 同步完成，然后执行：

```bash
./gradlew assembleDebug
```

生成的调试包通常位于：

```text
app/build/outputs/apk/debug/app-debug.apk
```

正式发布前建议先把服务器切到 HTTPS，再将 `MainActivity.java` 和 `network_security_config.xml` 中的地址改为 HTTPS 域名。
