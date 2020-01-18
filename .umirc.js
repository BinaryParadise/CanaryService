// ref: https://umijs.org/config/
import aliyunTheme from '@ant-design/aliyun-theme';

export default {
  "theme": aliyunTheme,
  treeShaking: true,
  routes: [
    {
      path: '/',
      component: '../layouts/index',
      routes: [
        {
          path: '/logger',
          component: './logger',
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
};
