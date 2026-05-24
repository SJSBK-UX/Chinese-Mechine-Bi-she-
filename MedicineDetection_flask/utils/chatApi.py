from openai import OpenAI
import json
import os
import requests
class ChatAPI:
    def __init__(self, deepseek_api_key,qwen_api_key):
        self.deepseek_client = OpenAI(
            api_key=deepseek_api_key,
            base_url="https://api.deepseek.com",
            timeout=8.0,
            max_retries=0
        )
        self.qwen_headers = {
            "Authorization": f"Bearer {qwen_api_key}",
            "Content-Type": "application/json"
        }
        self.qwen_url = "https://api.siliconflow.cn/v1/chat/completions"
    def deepseek_request(self, messages, model="deepseek-chat", stream=False):
        """DeepSeek API请求方法"""
        try:
            response = self.deepseek_client.chat.completions.create(
                model=model,
                messages=messages,
                stream=stream
            )
            return response.choices[0].message.content
        except Exception as e:
            return f"AI建议生成失败，请稍后重试。错误信息：{str(e)}"
    def qwen_request(self, messages, model="Qwen/Qwen2.5-14B-Instruct",
                     max_tokens=512, temperature=0.7):
        """Qwen API请求方法"""
        payload = {
            "model": model,
            "messages": messages,
            "stream": False,
            "max_tokens": max_tokens,
            "temperature": temperature,
            "top_p": 0.7,
            "top_k": 50,
            "frequency_penalty": 0.5,
            "response_format": {"type": "text"}
        }

        try:
            response = requests.post(
                self.qwen_url,
                json=payload,
                headers=self.qwen_headers,
                timeout=8
            )
            response.raise_for_status()
            data = response.json()
            return data['choices'][0]['message']['content']
        except requests.exceptions.RequestException as e:
            return f"AI建议生成失败，请稍后重试。错误信息：{str(e)}"
        except KeyError:
            return "Error parsing API response"

if __name__ == "__main__":
    chat = ChatAPI(
        deepseek_api_key=os.getenv("DEEPSEEK_API_KEY", ""),
        qwen_api_key=os.getenv("QWEN_API_KEY", "")
    )

    messages = [
        {"role": "user", "content": "请说明中药材检测结果中置信度的含义。"}
    ]

    print("DeepSeek Response:")
    print(chat.deepseek_request([{"role": "system", "content": "你是中药材检测与识别系统的辅助分析助手。"}] + messages))
