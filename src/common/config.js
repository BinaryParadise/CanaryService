const DefaultConfig = {
  development: {
    baseURI: "/api",
    wsPath: "ws://127.0.0.1:9001/api/channel"
  },
  production: {
    baseURI: "/api",
    wsPath: "/api/channel"
  }
}

let config = DefaultConfig.development
if (process.env.NODE_ENV === "production") {
  config = DefaultConfig.production
}

const nickname = "Rake Yang"
const baseURI = config.baseURI
const wsPath = config.wsPath
export {
  baseURI,
  wsPath,
  nickname
}