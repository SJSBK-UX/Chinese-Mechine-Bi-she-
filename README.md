# 基于 YOLO11 和 DeepSeek 的中药材检测与识别系统

## 项目简介

本项目是一个面向中药材图像检测与识别场景的毕业设计系统，围绕“中药材自动识别 + AI 文字说明 + 网页端与手机端访问”展开实现。系统支持单图识别、批量图片识别、视频识别、摄像头识别、历史记录管理和 Android WebView 手机端访问，能够形成从数据输入、模型推理、结果展示到记录保存的完整闭环。

项目核心思路如下：

- 使用 `YOLO11` 完成中药材目标检测，输出类别、置信度和检测框。
- 使用 `DeepSeek` 根据识别结果生成文字说明，提高结果可读性。
- 使用 `Vue3 + Spring Boot + Flask + MySQL + Android WebView` 搭建完整系统。

## 技术栈

| 层次 | 技术方案 | 说明 |
| --- | --- | --- |
| 前端 | Vue3、Vite、Element Plus | 负责页面展示、上传交互、结果渲染 |
| 业务后端 | Spring Boot、MyBatis Plus | 负责用户管理、文件上传、历史记录和接口转发 |
| AI 推理后端 | Flask、Ultralytics YOLO、OpenAI SDK | 负责图片、视频、摄像头推理和 AI 文本说明 |
| 数据库 | MySQL | 保存用户信息与识别记录 |
| 移动端 | Android WebView | 加载网页系统，实现手机端访问 |

## 系统架构

```text
用户图片 / 视频 / 摄像头画面
          |
          v
       Vue3 前端
          |
          v
  Spring Boot 业务后端
      |             |
      |             +----> MySQL 保存识别记录
      |
      v
   Flask 推理服务
      |        |
      |        +----> DeepSeek 生成说明
      |
      +----> YOLO11 模型检测
          |
          v
 返回类别、置信度、检测框和 AI 建议
```

## 主要功能

- 用户注册、登录和个人信息维护
- 单张中药材图片识别
- 批量图片识别
- 视频逐帧识别并生成结果视频
- 摄像头实时识别
- DeepSeek 文字说明生成
- 图片、视频、摄像头历史记录查询
- Android WebView 手机端访问

## 项目目录

```text
.
├─ MedicineDetection_vue              Vue3 前端源码
├─ MedicineDetection_springboot       Spring Boot 业务后端
├─ MedicineDetection_flask            Flask AI 推理后端
├─ MedicineDetection_mobile_app       Android WebView 手机端
├─ yoloai.sql                         数据库初始化脚本
├─ start_all.bat                      Windows 一键启动入口
├─ start_all.ps1                      PowerShell 一键启动脚本
├─ 项目说明书.md                       项目说明文档
└─ 项目说明书.pdf                      项目说明 PDF
```

## 运行环境

建议环境如下：

| 软件 | 版本建议 |
| --- | --- |
| Python | 3.8 及以上 |
| Node.js | 16 及以上 |
| npm | 7 及以上 |
| JDK | 8 或更高版本 |
| MySQL | 5.7 或 8.0 |

## 数据库配置

数据库初始化脚本：

```text
yoloai.sql
```

Spring Boot 配置文件：

```text
MedicineDetection_springboot/src/main/resources/application.properties
```

默认配置如下：

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/yolo?serverTimezone=Asia/Shanghai
spring.datasource.username=root
spring.datasource.password=123456
server.port=9999
```

如果本机 MySQL 用户名、密码或端口不同，请按实际环境修改。

## 快速启动

### 方式一：一键启动

在项目根目录直接运行：

```powershell
start_all.bat
```

脚本会自动启动：

- Flask AI 推理服务：`5000`
- Spring Boot 后端：`9999`
- Vue 前端：`8888`

启动后访问：

```text
http://localhost:8888
```

### 方式二：手动启动

#### 1. 启动 Flask

```powershell
cd MedicineDetection_flask
python main.py
```

#### 2. 启动 Spring Boot

```powershell
cd MedicineDetection_springboot
.\mvnw.cmd -DskipTests spring-boot:run
```

#### 3. 启动 Vue 前端

```powershell
cd MedicineDetection_vue
npm install
npm run dev
```

## 模型文件说明

模型权重位于：

```text
MedicineDetection_flask/weights/best.pt
MedicineDetection_flask/weights/best.onnx
```

- `best.pt`：PyTorch 权重文件，适合训练和 Python 环境推理
- `best.onnx`：ONNX 格式模型，适合后续部署优化

## 说明

- DeepSeek 和 Qwen 的 API Key 没有写入仓库，系统通过环境变量读取：

```text
DEEPSEEK_API_KEY
QWEN_API_KEY
```

- 若未配置 API Key，YOLO11 图像检测仍可运行，但 AI 文字说明可能无法生成。
- 本仓库为整理后的源码提交版，已排除 `node_modules`、`.venv`、`target`、`runs`、日志文件和本机构建缓存。

## 项目价值

本项目不是单独的模型训练实验，而是完成了从网页前端、业务后端、AI 推理后端、数据库到手机端访问的完整工程实现，具备一定的教学演示价值、原型验证价值和工程实践意义。
