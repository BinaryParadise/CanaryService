const baseURI = "http://127.0.0.1:8082/japi"
const nickname = "Rake Yang"
export {
  // 基础 URI
  baseURI,
  nickname
}

const prj = localStorage.getItem('projectInfo')
window.__config__ = {}
if (prj != undefined) {
  window.__config__.projectInfo = JSON.parse(prj)
}