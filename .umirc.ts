// ref: https://umijs.org/config/

import { defineConfig } from "umi"

export default defineConfig({
  nodeModulesTransform: {
    type: 'none',
  },
  routes: [
    {
      path: '/',
      component: '../layouts/index',
      routes: [
        {
          path: '/login',
          component: '../pages/login'
        },
        {
          path: '/user',
          component: '../pages/user'
        },
        {
          path: '/project',
          component: '../pages/project'
        },
        {
          path: '/device/monitor',
          component: '../pages/device/logger',
        },
        {
          path: '/device',
          component: '../pages/device'
        },
        {
          path: '/crash/:deviceid',
          component: '../pages/crash'
        },
        {
          path: '/crash/info/:id',
          component: '../pages/crash/crashlog'
        },
        {
          path: '/env',
          component: '../pages/envconfig'
        },
        {
          path: '/envitem',
          component: '../pages/envparam'
        },
        {
          path: '/mock/data',
          component: '../pages/mock'
        },
        {
          path: '/mock/scene',
          component: '../pages/mock/scene'
        },
        {
          path: '/',
          component: '../pages/envconfig',
        },
        {
          path: '/tool',
          component: '../pages/toolbox'
        },
        {
          path: '/request',
          component: '../pages/device/request'
        },
        {
          path: '/log/snapshot/:identify',
          component: '../pages/device/logger/snapshot'
        }
      ],
    },
  ],
  locale: { antd: true },
  mfsu: {},
  antd: {},
  history: { type: "browser" },
  // exportStatic: {},
  // dynamicImport: {},
  title: process.env.title ? process.env.title : '金丝雀 - 奶味蓝的乐园',
});
