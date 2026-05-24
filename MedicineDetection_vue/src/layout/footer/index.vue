<template>
	<div class="layout-footer pb15">
		<div class="layout-footer-warp">
			<div>基于 YOLO 与 DeepSeek 的中药材检测与识别系统</div>
			<div class="mt5">Copyright © 2026 MedicineDetection</div>
		</div>
	</div>
</template>

<script setup lang="ts" name="layoutFooter">
// 保持组件脚本区，避免 keep-alive 缓存异常。
</script>

<style scoped lang="scss">
.layout-footer {
	width: 100%;
	display: flex;
	&-warp {
		margin: auto;
		color: var(--el-text-color-secondary);
		text-align: center;
		animation: error-num 0.3s ease;
	}
}
</style>
