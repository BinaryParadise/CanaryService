const baseURI = "/api"
const nickname = "Rake Yang"
export {
  // 基础 URI
  baseURI,
  nickname
}

const prj = localStorage.getItem('projectInfo')
window.__config__ = {
  envTypeList: [{ 'type': 0, 'title': '测试', 'key': '0' }, { 'type': 1, 'title': '开发', 'key': '1' }, { 'type': 2, 'title': '生产', 'key': '2' }],
  platforms: [{ 'platform': 0, 'title': '全部' }, { 'platform': 1, 'title': 'iOS' }, { 'platform': 2, 'title': 'Android' }]
}
if (prj != undefined) {
  window.__config__.projectInfo = JSON.parse(prj)
}