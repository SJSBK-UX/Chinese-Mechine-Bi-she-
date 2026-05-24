<template>
	<div v-if="isShowBreadcrumb" class="layout-navbars-breadcrumb">
		<SvgIcon
			class="layout-navbars-breadcrumb-icon"
			:class="{ 'layout-navbars-breadcrumb-icon-mobile': isMobileWidth }"
			:name="isMobileWidth ? 'ele-Menu' : themeConfig.isCollapse ? 'ele-Expand' : 'ele-Fold'"
			:size="isMobileWidth ? 20 : 16"
			@click="onThemeConfigChange"
		/>
		<div class="layout-navbars-mobile-title">{{ currentPageTitle }}</div>
		<el-breadcrumb class="layout-navbars-breadcrumb-hide">
			<transition-group name="breadcrumb">
				<el-breadcrumb-item v-for="(v, k) in state.breadcrumbList" :key="!v.meta.tagsViewName ? v.meta.title : v.meta.tagsViewName">
					<span v-if="k === state.breadcrumbList.length - 1" class="layout-navbars-breadcrumb-span">
						<SvgIcon :name="v.meta.icon" class="layout-navbars-breadcrumb-iconfont" v-if="themeConfig.isBreadcrumbIcon" />
						<div v-if="!v.meta.tagsViewName">{{ $t(v.meta.title) }}</div>
						<div v-else>{{ v.meta.tagsViewName }}</div>
					</span>
					<a v-else @click.prevent="onBreadcrumbClick(v)">
						<SvgIcon :name="v.meta.icon" class="layout-navbars-breadcrumb-iconfont" v-if="themeConfig.isBreadcrumbIcon" />{{ $t(v.meta.title) }}
					</a>
				</el-breadcrumb-item>
			</transition-group>
		</el-breadcrumb>
	</div>
</template>

<script setup lang="ts" name="layoutBreadcrumb">
import { reactive, computed, onMounted, onUnmounted, ref } from 'vue';
import { onBeforeRouteUpdate, useRoute, useRouter } from 'vue-router';
import { Local } from '/@/utils/storage';
import other from '/@/utils/other';
import { storeToRefs } from 'pinia';
import { useThemeConfig } from '/@/stores/themeConfig';
import { useRoutesList } from '/@/stores/routesList';

// 定义变量内容
const stores = useRoutesList();
const storesThemeConfig = useThemeConfig();
const { themeConfig } = storeToRefs(storesThemeConfig);
const { routesList } = storeToRefs(stores);
const route = useRoute();
const router = useRouter();
const clientWidth = ref(document.body.clientWidth);
const state = reactive<BreadcrumbState>({
	breadcrumbList: [],
	routeSplit: [],
	routeSplitFirst: '',
	routeSplitIndex: 1,
});
const isMobileWidth = computed(() => clientWidth.value <= 768);
const currentPageTitle = computed(() => other.setTagsViewNameI18n(<RouteToFrom>route));

// 动态设置经典、横向布局不显示
const isShowBreadcrumb = computed(() => {
	initRouteSplit(route.path);
	const { layout, isBreadcrumb } = themeConfig.value;
	if (layout === 'classic' || layout === 'transverse') return false;
	else return isBreadcrumb ? true : false;
});
// 面包屑点击时
const onBreadcrumbClick = (v: RouteItem) => {
	const { redirect, path } = v;
	if (redirect) router.push(redirect);
	else router.push(path);
};
// 展开/收起左侧菜单点击
const onThemeConfigChange = () => {
	themeConfig.value.isCollapse = !themeConfig.value.isCollapse;
	setLocalThemeConfig();
};
// 存储布局配置
const setLocalThemeConfig = () => {
	Local.remove('themeConfig');
	Local.set('themeConfig', themeConfig.value);
};
// 处理面包屑数据
const getBreadcrumbList = (arr: RouteItems) => {
	arr.forEach((item: RouteItem) => {
		state.routeSplit.forEach((v: string, k: number, arrs: string[]) => {
			if (state.routeSplitFirst === item.path) {
				state.routeSplitFirst += `/${arrs[state.routeSplitIndex]}`;
				state.breadcrumbList.push(item);
				state.routeSplitIndex++;
				if (item.children) getBreadcrumbList(item.children);
			}
		});
	});
};
// 当前路由字符串切割成数组，并删除第一项空内容
const initRouteSplit = (path: string) => {
	if (!themeConfig.value.isBreadcrumb) return false;
	state.breadcrumbList = [routesList.value[0]];
	state.routeSplit = path.split('/');
	state.routeSplit.shift();
	state.routeSplitFirst = `/${state.routeSplit[0]}`;
	state.routeSplitIndex = 1;
	getBreadcrumbList(routesList.value);
	if (route.name === 'home' || (route.name === 'notFound' && state.breadcrumbList.length > 1)) state.breadcrumbList.shift();
	if (state.breadcrumbList.length > 0)
		state.breadcrumbList[state.breadcrumbList.length - 1].meta.tagsViewName = other.setTagsViewNameI18n(<RouteToFrom>route);
};
// 页面加载时
onMounted(() => {
	initRouteSplit(route.path);
	window.addEventListener('resize', onWindowResize);
});
const onWindowResize = () => {
	clientWidth.value = document.body.clientWidth;
};
onUnmounted(() => {
	window.removeEventListener('resize', onWindowResize);
});
// 路由更新时
onBeforeRouteUpdate((to) => {
	initRouteSplit(to.path);
});
</script>

<style scoped lang="scss">
.layout-navbars-breadcrumb {
	flex: 1;
	height: inherit;
	display: flex;
	align-items: center;
	.layout-navbars-breadcrumb-icon {
		cursor: pointer;
		font-size: 18px;
		color: var(--next-bg-topBarColor);
		height: 100%;
		width: 40px;
		opacity: 0.8;
		&:hover {
			opacity: 1;
		}
	}
	.layout-navbars-breadcrumb-icon-mobile {
		width: 50px;
		opacity: 1;
	}
	.layout-navbars-mobile-title {
		display: none;
		min-width: 0;
		flex: 1;
		font-size: 15px;
		font-weight: 600;
		color: var(--next-bg-topBarColor);
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	.layout-navbars-breadcrumb-span {
		display: flex;
		opacity: 0.7;
		color: var(--next-bg-topBarColor);
	}
	.layout-navbars-breadcrumb-iconfont {
		font-size: 14px;
		margin-right: 5px;
	}
	:deep(.el-breadcrumb__separator) {
		opacity: 0.7;
		color: var(--next-bg-topBarColor);
	}
	:deep(.el-breadcrumb__inner a, .el-breadcrumb__inner.is-link) {
		font-weight: unset !important;
		color: var(--next-bg-topBarColor);
		&:hover {
			color: var(--el-color-primary) !important;
		}
	}
}

@media screen and (max-width: 768px) {
	.layout-navbars-breadcrumb {
		flex: 1 1 auto;
		min-width: 0;

		.layout-navbars-mobile-title {
			display: block;
		}

		.layout-navbars-breadcrumb-hide {
			display: none;
		}
	}
}
</style>
