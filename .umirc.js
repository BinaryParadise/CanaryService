// ref: https://umijs.org/config/

export default {
  treeShaking: true,
  routes: [
    {
      path: '/',
      component: '../layouts/index',
      routes: [
        {
          path: '/project',
          component: '../pages/project'
        },
        {
          path: '/logger',
          component: '../pages/logger',
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
          path: '/',
          component: '../pages/index',
        },
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
        title: '水月洞天',
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
      target: 'http://127.0.0.1:8082/japi',
      pathRewrite: { '^/api': '' },
      changeOrigin: true
    }
  }
  // cssLoaderOptions: {
  //   localIdentName: '[local]'
  // }
};
