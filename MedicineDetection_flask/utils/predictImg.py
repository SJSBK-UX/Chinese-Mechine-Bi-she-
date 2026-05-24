import json
import time
from ultralytics import YOLO


class ImagePredictor:
    def __init__(self, weights_path, img_path, save_path="./runs/resultBatch.jpg", conf=0.5):
        """
        初始化ImagePredictor类
        :param weights_path: 权重文件路径
        :param img_path: 输入图像路径
        :param save_path: 结果保存路径
        :param conf: 置信度阈值
        """
        # 直接加载模型，不进行设备转换
        self.model = YOLO(weights_path)
        self.conf = conf
        self.img_path = img_path
        self.save_path = save_path
        self.labels = ["白茯苓", "白芍", "白术", "蒲公英", "甘草", "栀子", "党参", "桃仁", "去皮桃仁", "地肤子",
                       "牡丹皮", "冬虫夏草", "杜仲", "当归", "杏仁", "何首乌", "黄精", "鸡血藤", "枸杞", "莲须", "莲肉",
                       "麦门冬", "木通", "玉竹", "女贞子", "肉苁蓉", "人参", "乌梅", "覆盆子", "瓜蒌皮", "肉桂",
                       "山茱萸", "山药", "酸枣仁", "桑白皮", "山楂", "天麻", "熟地黄", "小茴香", "泽泻", "竹茹",
                       "川贝母", "川芎", "玄参", "益智仁"]
    def predict(self):
        """
        预测图像并保存结果
        """
        start_time = time.time()
        # 使用 ONNX 模型进行推理
        results = self.model.predict(
            source=self.img_path,
            conf=self.conf,
            save_conf=True,
            device='cpu',  # 指定使用 CPU
            verbose=False  # 关闭详细输出
        )
        elapsed_time = time.time() - start_time

        all_results = {
            'labels': [],
            'confidences': [],
            'allTime': f"{elapsed_time:.3f}秒"
        }

        try:
            if len(results) == 0:
                return {
                    'labels': '预测失败',
                    'confidences': "0.00%",
                    'allTime': f"{elapsed_time:.3f}秒"
                }

            for result in results:
                confidences = result.boxes.conf if hasattr(result.boxes, 'conf') else []
                labels = result.boxes.cls if hasattr(result.boxes, 'cls') else []

                if confidences.numel() == 0 or labels.numel() == 0:
                    return {
                        'labels': '预测失败',
                        'confidences': "0.00%",
                        'allTime': f"{elapsed_time:.3f}秒"
                    }

                label_names = [self.labels[int(cls)] for cls in labels]
                predictions = list(zip(label_names, confidences))

                for label, conf in predictions:
                    all_results['labels'].append(label)
                    all_results['confidences'].append(f"{conf * 100:.2f}%")

                result.save(filename=self.save_path)

            return all_results
        except Exception as e:
            print(f"预测过程中发生异常: {e}")
            return {
                'labels': '预测失败',
                'confidences': "0.00%",
                'allTime': f"{elapsed_time:.3f}秒"
            }


if __name__ == '__main__':
    predictor = ImagePredictor(
        weights_path="../weights/best.onnx",
        img_path="../test.jpg",
        save_path="../runs/result.jpg",
        conf=0.1
    )
    result = predictor.predict()
    print(f"标签: {result['labels']}")
    print(f"置信度: {result['confidences']}")
    print(f"用时: {result['allTime']}")
