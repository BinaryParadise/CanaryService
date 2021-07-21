// ref: https://umijs.org/config/

var headers = ""
export default {
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
          path: '/device/log',
          component: '../pages/device/logger',
        },
        {
          path: '/device',
          component: '../pages/device'
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
  mfsu: {},
  antd: {},
  dva: {
    immer: false,
    hmr: false,
    skipModelValidate: true
  },
  dynamicImport: {},
  title: process.env.title ? process.env.title : '金丝雀 - 奶味蓝的乐园',
  mock: false,
  proxy: {
    '/api': {
      // target: 'http://127.0.0.1:9001',
      // pathRewrite: { '^/api': '' },
      changeOrigin: false
    }
  }
};
