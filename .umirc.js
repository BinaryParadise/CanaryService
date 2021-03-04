// ref: https://umijs.org/config/

var headers = ""
export default {
  treeShaking: true,
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
          path: '/mock/param',
          component: '../pages/mock/param'
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
  plugins: [
    // ref: https://umijs.org/plugin/umi-plugin-react.html
    [
      'umi-plugin-react',
      {
        antd: true,
        dva: true,
        dynamicImport: false,
        title: process.env.title ? process.env.title : '金丝雀 - 奶味蓝的乐园',
        dll: false,
        routes: {
          exclude: [
            /models\//,
            /services\//,
            /model\.(t|j)sx?$/,
            /service\.(t|j)sx?$/,
            /components\//,
          ],
        },
      },
    ],
  ],
  proxy: {
    '/api': {
      target: 'http://127.0.0.1:9001',
      // pathRewrite: { '^/api': '' },
      changeOrigin: false
    }
  }
};
