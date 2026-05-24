import { defineStore } from 'pinia';

/**
 * 布局配置
 * 修改配置时：
 * 1、需要每次都清理 `window.localStorage` 浏览器永久缓存
 * 2、或者点击布局配置最底部 `一键恢复默认` 按钮即可看到效果
 */
export const useThemeConfig = defineStore('themeConfig', {
    state: (): ThemeConfigState => ({
        themeConfig: {
            // 是否开启布局配置抽屉
            isDrawer: false,

            /**
             * 全局主题
             */
            // 默认 primary 主题颜色
            primary: '#2f8f68',
            // 是否开启深色模式
            isIsDark: false,

            /**
             * 顶栏设置
             */
            // 默认顶栏导航背景颜色
            topBar: '#ffffff',
            // 默认顶栏导航字体颜色
            topBarColor: '#172b4d',
            // 是否开启顶栏背景颜色渐变
            isTopBarColorGradual: false,

            /**
             * 菜单设置
             */
            // 默认菜单导航背景颜色
            menuBar: '#ffffff',
            // 默认菜单导航字体颜色
            menuBarColor: '#344563',
            // 默认菜单高亮背景色
            menuBarActiveColor: '#e7f4ed',
            // 是否开启菜单背景颜色渐变
            isMenuBarColorGradual: false,

            /**
             * 分栏设置
             */
            // 默认分栏菜单背景颜色
            columnsMenuBar: '#ffffff',
            // 默认分栏菜单字体颜色
            columnsMenuBarColor: '#344563',
            // 是否开启分栏菜单背景颜色渐变
            isColumnsMenuBarColorGradual: false,
            // 是否开启分栏菜单鼠标悬停预加载(预览菜单)
            isColumnsMenuHoverPreload: false,

            /**
             * 界面设置
             */
            // 是否开启菜单水平折叠效果
            isCollapse: false,
            // 是否开启菜单手风琴效果
            isUniqueOpened: true,
            // 是否开启固定 Header
            isFixedHeader: false,
            // 初始化变量，用于更新菜单 el-scrollbar 的高度，请勿删除
            isFixedHeaderChange: false,
            // 是否开启经典布局分割菜单（仅经典布局生效）
            isClassicSplitMenu: false,
            // 是否开启自动锁屏
            isLockScreen: false,
            // 开启自动锁屏倒计时(s/秒)
            lockScreenTime: 30,

            /**
             * 界面显示
             */
            // 是否开启侧边栏 Logo
            isShowLogo: true,
            // 初始化变量，用于 el-scrollbar 的高度更新，请勿删除
            isShowLogoChange: true,
            // 是否开启 Breadcrumb，强制经典、横向布局不显示
            isBreadcrumb: true,
            // 是否开启 Tagsview
            isTagsview: true,
            // 是否开启 Breadcrumb 图标
            isBreadcrumbIcon: false,
            // 是否开启 Tagsview 图标
            isTagsviewIcon: true,
            // 是否开启 TagsView 缓存
            isCacheTagsView: false,
            // 是否开启 TagsView 拖拽
            isSortableTagsView: true,
            // 是否开启 TagsView 共用
            isShareTagsView: false,
            // 是否开启 Footer 底部版权信息
            isFooter: false,
            // 是否开启灰色模式
            isGrayscale: false,
            // 是否开启色弱模式
            isInvert: false,
            // 是否开启水印
            isWartermark: true,
            // 水印文案
            wartermarkText: '林枫',

            /**
             * 其它设置
             */
            // Tagsview 风格：可选值"<tags-style-one|tags-style-four|tags-style-five>"，默认 tags-style-five
            tagsStyle: 'tags-style-five',
            // 主页面切换动画：可选值"<slide-right|slide-left|opacitys>"，默认 slide-right
            animation: 'slide-right',
            // 分栏高亮风格：可选值"<columns-round|columns-card>"，默认 columns-round
            columnsAsideStyle: 'columns-round',
            // 分栏布局风格：可选值"<columns-horizontal|columns-vertical>"，默认 columns-horizontal
            columnsAsideLayout: 'columns-vertical',

            /**
             * 布局切换
             */
            // 布局切换：可选值"<defaults|classic|transverse|columns>"，默认 defaults
            layout: 'defaults',

            /**
             * 后端控制路由
             */
            // 是否开启后端控制路由
            isRequestRoutes: false,

            /**
             * 全局网站标题 / 副标题
             */
            // 网站主标题（菜单导航、浏览器当前网页标题）
            globalTitle: '中药材检测系统',
            // 网站副标题（登录页顶部文字）
            globalViceTitle: '基于YOLO的中药材检测与识别系统',
            // 网站副标题（登录页顶部文字）
            globalViceTitleMsg: '图像检测、视频检测、摄像检测与AI建议',
            // 默认初始语言，可选值"<zh-cn|en|zh-tw>"，默认 zh-cn
            globalI18n: 'zh-cn',
            // 默认全局组件大小，可选值"<large|'default'|small>"，默认 'large'
            globalComponentSize: 'large',
        },
    }),
    actions: {
        setThemeConfig(data: ThemeConfigState) {
            this.themeConfig = data.themeConfig;
        },
        resetThemeConfig() {
            this.themeConfig = {
                isDrawer: false,
                primary: '#2f8f68',
                isIsDark: false,
                topBar: '#ffffff',
                topBarColor: '#172b4d',
                isTopBarColorGradual: false,
                menuBar: '#ffffff',
                menuBarColor: '#344563',
                menuBarActiveColor: '#e7f4ed',
                isMenuBarColorGradual: false,
                columnsMenuBar: '#ffffff',
                columnsMenuBarColor: '#344563',
                isColumnsMenuBarColorGradual: false,
                isColumnsMenuHoverPreload: false,
                isCollapse: false,
                isUniqueOpened: true,
                isFixedHeader: false,
                isFixedHeaderChange: false,
                isClassicSplitMenu: false,
                isLockScreen: false,
                lockScreenTime: 30,
                isShowLogo: true,
                isShowLogoChange: true,
                isBreadcrumb: true,
                isTagsview: true,
                isBreadcrumbIcon: false,
                isTagsviewIcon: true,
                isCacheTagsView: false,
                isSortableTagsView: true,
                isShareTagsView: false,
                isFooter: false,
                isGrayscale: false,
                isInvert: false,
                isWartermark: true,
                wartermarkText: '林枫',
                tagsStyle: 'tags-style-five',
                animation: 'slide-right',
                columnsAsideStyle: 'columns-round',
                columnsAsideLayout: 'columns-vertical',
                layout: 'defaults',
                isRequestRoutes: false,
                globalTitle: '中药材检测系统',
                globalViceTitle: '基于YOLO的中药材检测与识别系统',
                globalViceTitleMsg: '图像检测、视频检测、摄像检测与AI建议',
                globalI18n: 'zh-cn',
                globalComponentSize: 'large',
            };
        },
    },
});
