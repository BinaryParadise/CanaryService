const DefaultConfig = {
  development: {
    baseURI: "/api",
    wsPath: ":8082/v2/channel"
  },
  production: {
    baseURI: "/api",
    wsPath: "/channel"
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