<template>
	<div class="chat-container">
		<div class="chat-header">
			<h3 class="chat-title">中药材识别 AI 助手</h3>
		</div>

		<div class="chat-messages" ref="messageContainer">
			<div v-for="(message, index) in messages" :key="index"
				:class="['message', message.role === 'user' ? 'user-message' : 'assistant-message']">
				<div class="message-content">
					<div class="avatar">
						{{ message.role === 'user' ? '👤' : '🤖' }}
					</div>
					<div class="text" v-html="renderMarkdown(message.content)"></div>
				</div>
			</div>
			<div v-if="loading" class="message assistant-message">
				<div class="message-content">
					<div class="avatar">🤖</div>
					<div class="text" v-html="renderMarkdown(currentAssistantMessage || '思考中...')"></div>
				</div>
			</div>
		</div>

		<div class="suggested-questions" v-if="messages.length === 1">
			<div class="suggested-title" style="font-size: 1.2rem; font-weight: 550;">猜你想问</div>
			<div class="suggested-list">
				<div v-for="(question, index) in suggestedQuestions" :key="index" class="suggested-item"
					@click="selectQuestion(question)">
					{{ question }}
				</div>
			</div>
		</div>

		<div class="chat-input">
			<el-input v-model="userInput" type="textarea" :rows="3" placeholder="请输入您的问题..."
				@keyup.enter.ctrl="sendMessage" />
			<el-button type="primary" :loading="loading" @click="sendMessage" :disabled="!userInput.trim()">
				发送
			</el-button>
		</div>
	</div>
</template>

<script>
import { marked } from 'marked'

export default {
	name: 'SmartChat',
	data() {
		return {
			messages: [{
				role: 'assistant',
				content: '你好，我是中药材识别智能助手，可以帮你解读检测结果、分析药材特征和提供使用参考。'
			}],
			userInput: '',
			loading: false,
			suggestedQuestions: [
				'如何解读检测结果中的置信度？',
				'识别出多个中药材时应该怎么看？',
				'如何区分外观相似的中药材？',
				'上传图片时怎样提高识别准确率？',
				'检测结果不准确时应该怎么办？',
				'AI 建议可以作为哪些参考？',
				'中药材保存需要注意什么？'
			],
			currentAssistantMessage: ''
		}
	},
	methods: {
		selectQuestion(question) {
			this.userInput = question
			this.sendMessage()
		},
		async sendMessage() {
			if (!this.userInput.trim() || this.loading) return

			const userMessage = this.userInput.trim()
			this.messages.push({
				role: 'user',
				content: userMessage
			})

			this.userInput = ''
			this.loading = true
			this.currentAssistantMessage = ''

			try {
				this.currentAssistantMessage = '请在图像检测页面选择 DeepSeek 或 Qwen 生成检测建议；本页面仅保留中药材识别常见问题说明，不在前端直接保存或调用第三方模型密钥。'
				this.messages.push({
					role: 'assistant',
					content: this.currentAssistantMessage
				})
			} catch (error) {
				this.$message.error('发送消息失败，请稍后重试')
				console.error('Error:', error)
			} finally {
				this.loading = false
				this.currentAssistantMessage = ''
				this.$nextTick(() => {
					this.scrollToBottom()
				})
			}
		},
		scrollToBottom() {
			const container = this.$refs.messageContainer
			container.scrollTop = container.scrollHeight
		},
		renderMarkdown(text) {
			return marked(text)
		}
	}
}
</script>

<style scoped>
.chat-container {
	height: calc(100vh - 60px);
	display: flex;
	flex-direction: column;
	background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
}

.chat-header {
	padding: 10px 0;
	background: rgba(255, 255, 255, 0.9);
	backdrop-filter: blur(10px);
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
	border-bottom: 1px solid rgba(0, 0, 0, 0.05);
	display: flex;
	justify-content: center;
	align-items: center;
}

.chat-title {
	margin: 0;
	color: #4CAF50;
	font-size: 1.1rem;
	font-weight: 550;
	text-align: center;
}

.chat-messages {
	flex: 1;
	overflow-y: auto;
	padding: 20px;
	scroll-behavior: smooth;
	width: 100%;
}

.message {
	margin-bottom: 24px;
	opacity: 0;
	transform: translateY(20px);
	animation: messageAppear 0.3s ease forwards;
	display: flex;
	justify-content: flex-start;
	width: 100%;
}

@keyframes messageAppear {
	to {
		opacity: 1;
		transform: translateY(0);
	}
}

.message-content {
	display: flex;
	align-items: flex-start;
	max-width: 70%;
	gap: 12px;
	word-break: break-word;
}

.user-message .message-content {
	flex-direction: row-reverse;
	margin-left: auto;
	padding-left: 10%;
}

.assistant-message .message-content {
	margin-right: auto;
	padding-right: 10%;
}

.avatar {
	width: 36px;
	height: 36px;
	min-width: 36px;
	flex-shrink: 0;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	background: rgba(255, 255, 255, 0.9);
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	font-size: 1.1rem;
	transition: transform 0.2s ease;
}

.user-message .avatar {
	margin-right: 8px;
}

.assistant-message .avatar {
	margin-left: 8px;
}

.text {
	padding: 12px 16px;
	border-radius: 12px;
	background: rgba(255, 255, 255, 0.9);
	box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
	line-height: 1.6;
	font-size: 0.95rem;
	position: relative;
	transition: all 0.3s ease;
	flex: 1;
	min-width: 0;
	white-space: normal;
	word-wrap: break-word;
}

.user-message .text {
	background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
	color: #fff;
	border-top-right-radius: 4px;
}

.assistant-message .text {
	border-top-left-radius: 4px;
}

.chat-input {
	padding: 10px 10px 0 10px;
	background: rgba(255, 255, 255, 0.9);
	backdrop-filter: blur(10px);
	box-shadow: 0 -4px 6px rgba(0, 0, 0, 0.05);
	display: flex;
	gap: 8px;
}

.chat-input :deep(.el-textarea__inner) {
	border-radius: 12px;
	border: 1px solid rgba(0, 0, 0, 0.1);
	padding: 8px;
	font-size: 0.9rem;
	resize: none;
	transition: all 0.3s ease;
}

.chat-input :deep(.el-textarea__inner:focus) {
	border-color: #4CAF50;
	box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.1);
}

.chat-input :deep(.el-button) {
	border-radius: 12px;
	padding: 0 16px;
	height: auto;
	background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
	border: none;
	transition: all 0.3s ease;
	font-size: 0.95rem;
}

.chat-input :deep(.el-button:hover) {
	transform: translateY(-1px);
	box-shadow: 0 4px 12px rgba(76, 175, 80, 0.2);
}

.chat-input :deep(.el-button:disabled) {
	background: #ccc;
	transform: none;
	box-shadow: none;
}

.loading-dots {
	display: inline-block;
	position: relative;
	color: #666;
}

.loading-dots::after {
	content: '...';
	animation: loading 1.5s infinite;
}

@keyframes loading {
	0% {
		content: '.';
	}

	33% {
		content: '..';
	}

	66% {
		content: '...';
	}
}

/* 自定义滚动条样式 */
.chat-messages::-webkit-scrollbar {
	width: 6px;
}

.chat-messages::-webkit-scrollbar-track {
	background: rgba(0, 0, 0, 0.05);
	border-radius: 3px;
}

.chat-messages::-webkit-scrollbar-thumb {
	background: rgba(0, 0, 0, 0.2);
	border-radius: 3px;
}

.chat-messages::-webkit-scrollbar-thumb:hover {
	background: rgba(0, 0, 0, 0.3);
}

.suggested-questions {
	padding: 10px 10px 20px 10px;
	background: rgba(255, 255, 255, 0.9);
	backdrop-filter: blur(10px);
	border-top: 1px solid rgba(0, 0, 0, 0.05);
}

.suggested-title {
	font-size: 0.95rem !important;
	margin-bottom: 6px;
	font-weight: 500;
}

.suggested-list {
	display: flex;
	flex-wrap: wrap;
	gap: 4px;
}

.suggested-item {
	padding: 5px 10px;
	background: rgba(76, 175, 80, 0.1);
	border-radius: 20px;
	font-size: 0.85rem;
	color: #4CAF50;
	cursor: pointer;
	transition: all 0.3s ease;
}

.suggested-item:hover {
	background: rgba(76, 175, 80, 0.2);
	transform: translateY(-1px);
}

/* Markdown 样式 */
.text :deep(h1) {
	font-size: 1.5em;
	margin: 0.5em 0;
	color: #2c3e50;
}

.text :deep(h2) {
	font-size: 1.3em;
	margin: 0.5em 0;
	color: #2c3e50;
}

.text :deep(h3) {
	font-size: 1.1em;
	margin: 0.5em 0;
	color: #2c3e50;
}

.text :deep(p) {
	margin: 0.5em 0;
	line-height: 1.6;
}

.text :deep(ul), .text :deep(ol) {
	margin: 0.5em 0;
	padding-left: 1.5em;
}

.text :deep(li) {
	margin: 0.3em 0;
}

.text :deep(code) {
	background-color: rgba(0, 0, 0, 0.05);
	padding: 0.2em 0.4em;
	border-radius: 3px;
	font-family: monospace;
}

.text :deep(pre) {
	background-color: rgba(0, 0, 0, 0.05);
	padding: 1em;
	border-radius: 5px;
	overflow-x: auto;
	margin: 0.5em 0;
}

.text :deep(pre code) {
	background-color: transparent;
	padding: 0;
}

.text :deep(blockquote) {
	border-left: 4px solid #4CAF50;
	margin: 0.5em 0;
	padding-left: 1em;
	color: #666;
}

.text :deep(a) {
	color: #4CAF50;
	text-decoration: none;
}

.text :deep(a:hover) {
	text-decoration: underline;
}

.text :deep(img) {
	max-width: 100%;
	height: auto;
	border-radius: 5px;
	margin: 0.5em 0;
}

.text :deep(table) {
	border-collapse: collapse;
	width: 100%;
	margin: 0.5em 0;
}

.text :deep(th), .text :deep(td) {
	border: 1px solid #ddd;
	padding: 0.5em;
	text-align: left;
}

.text :deep(th) {
	background-color: rgba(76, 175, 80, 0.1);
}

.text :deep(hr) {
	border: none;
	border-top: 1px solid #ddd;
	margin: 1em 0;
}

/* 用户消息中的 Markdown 样式覆盖 */
.user-message .text :deep(h1),
.user-message .text :deep(h2),
.user-message .text :deep(h3),
.user-message .text :deep(p),
.user-message .text :deep(li),
.user-message .text :deep(blockquote) {
	color: #fff;
}

.user-message .text :deep(code),
.user-message .text :deep(pre) {
	background-color: rgba(255, 255, 255, 0.1);
}

.user-message .text :deep(a) {
	color: #fff;
	text-decoration: underline;
}

.user-message .text :deep(blockquote) {
	border-left-color: #fff;
}
</style>
