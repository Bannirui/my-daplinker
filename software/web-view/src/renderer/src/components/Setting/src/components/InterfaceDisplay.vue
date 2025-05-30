<script setup lang="ts">
import { ElSwitch, ElMessage } from 'element-plus'
import { useI18n } from '@/hooks/web/useI18n'
import { useAppStore } from '@/store/modules/app'
import { computed, ref, watch } from 'vue'
import { setCssVar } from '@/utils'
import { useDesign } from '@/hooks/web/useDesign'

const { getPrefixCls } = useDesign()

const prefixCls = getPrefixCls('interface-display')

const appStore = useAppStore()

const { t } = useI18n()

// 面包屑
const breadcrumb = ref<boolean>(appStore.getBreadcrumb)

const breadcrumbChange = (show: boolean | string | number) => {
  appStore.setBreadcrumb(Boolean(show))
}

// 面包屑图标
const breadcrumbIcon = ref(appStore.getBreadcrumbIcon)

const breadcrumbIconChange = (show: string | number | boolean) => {
  appStore.setBreadcrumbIcon(Boolean(show))
}

// 折叠图标
const hamburger = ref(appStore.getHamburger)

const hamburgerChange = (show: string | number | boolean) => {
  appStore.setHamburger(Boolean(show))
}

// 全屏图标
const screenfull = ref(appStore.getScreenfull)

const screenfullChange = (show: string | number | boolean) => {
  appStore.setScreenfull(Boolean(show))
}

// 尺寸图标
const size = ref(appStore.getSize)

const sizeChange = (show: string | number | boolean) => {
  appStore.setSize(Boolean(show))
}

// 多语言图标
const locale = ref(appStore.getLocale)

const localeChange = (show: string | number | boolean) => {
  appStore.setLocale(Boolean(show))
}

// 标签页
const tagsView = ref(appStore.getTagsView)

const tagsViewChange = (show: string | number | boolean) => {
  // 切换标签栏显示时，同步切换标签栏的高度
  setCssVar('--tags-view-height', show ? '35px' : '0px')
  appStore.setTagsView(Boolean(show))
}

// 标签页图标
const tagsViewIcon = ref(appStore.getTagsViewIcon)

const tagsViewIconChange = (show: string | number | boolean) => {
  appStore.setTagsViewIcon(Boolean(show))
}

// logo
const logo = ref(appStore.getLogo)

const logoChange = (show: string | number | boolean) => {
  appStore.setLogo(Boolean(show))
}

// 菜单手风琴
const uniqueOpened = ref(appStore.getUniqueOpened)

const uniqueOpenedChange = (uniqueOpened: string | number | boolean) => {
  appStore.setUniqueOpened(Boolean(uniqueOpened))
}

// 固定头部
const fixedHeader = ref(appStore.getFixedHeader)

const fixedHeaderChange = (show: string | number | boolean) => {
  appStore.setFixedHeader(Boolean(show))
}

// 页脚
const footer = ref(appStore.getFooter)

const footerChange = (show: string | number | boolean) => {
  appStore.setFooter(Boolean(show))
}

// 灰色模式
const greyMode = ref(appStore.getGreyMode)

const greyModeChange = (show: string | number | boolean) => {
  appStore.setGreyMode(Boolean(show))
}

// 动态路由
const dynamicRouter = ref(!!appStore.getDynamicRouter)

const dynamicRouterChange = (show: string | number | boolean) => {
  ElMessage.info(t('setting.reExperienced'))
  appStore.setDynamicRouter(Boolean(show))
}

// 服务端动态路由
const serverDynamicRouter = ref(appStore.getServerDynamicRouter)

const serverDynamicRouterChange = (show: string | number | boolean) => {
  ElMessage.info(t('setting.reExperienced'))
  appStore.setServerDynamicRouter(Boolean(show))
}

// 固定菜单
const fixedMenu = ref(appStore.getFixedMenu)

const fixedMenuChange = (show: string | number | boolean) => {
  appStore.setFixedMenu(Boolean(show))
}

const layout = computed(() => appStore.getLayout)

watch(
  () => layout.value,
  (n) => {
    if (n === 'top') {
      appStore.setCollapse(false)
    }
  }
)
</script>

<template>
  <div :class="prefixCls">
    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.breadcrumb') }}</span>
      <ElSwitch v-model="breadcrumb" @change="breadcrumbChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.breadcrumbIcon') }}</span>
      <ElSwitch v-model="breadcrumbIcon" @change="breadcrumbIconChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.hamburgerIcon') }}</span>
      <ElSwitch v-model="hamburger" @change="hamburgerChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.screenfullIcon') }}</span>
      <ElSwitch v-model="screenfull" @change="screenfullChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.sizeIcon') }}</span>
      <ElSwitch v-model="size" @change="sizeChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.localeIcon') }}</span>
      <ElSwitch v-model="locale" @change="localeChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.tagsView') }}</span>
      <ElSwitch v-model="tagsView" @change="tagsViewChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.tagsViewIcon') }}</span>
      <ElSwitch v-model="tagsViewIcon" @change="tagsViewIconChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.logo') }}</span>
      <ElSwitch v-model="logo" @change="logoChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.uniqueOpened') }}</span>
      <ElSwitch v-model="uniqueOpened" @change="uniqueOpenedChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.fixedHeader') }}</span>
      <ElSwitch v-model="fixedHeader" @change="fixedHeaderChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.footer') }}</span>
      <ElSwitch v-model="footer" @change="footerChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.greyMode') }}</span>
      <ElSwitch v-model="greyMode" @change="greyModeChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.dynamicRouter') }}</span>
      <ElSwitch v-model="dynamicRouter" @change="dynamicRouterChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.serverDynamicRouter') }}</span>
      <ElSwitch v-model="serverDynamicRouter" @change="serverDynamicRouterChange" />
    </div>

    <div class="flex justify-between items-center">
      <span class="text-14px">{{ t('setting.fixedMenu') }}</span>
      <ElSwitch v-model="fixedMenu" @change="fixedMenuChange" />
    </div>
  </div>
</template>
