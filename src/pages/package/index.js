import React from 'react'

export default class PackagePage extends React.Component {
    render() {
        const { projectInfo } = window.__config__
        return (<div>
            <img src={require(`../../assets/${projectInfo.identify}.png`)} style={{ width: 300, height: 390 }} ></img>
            <div style={{ color: 'orange', marginTop: 8, marginLeft: 10 }}><b>测试包（包含金丝雀）</b></div>
        </div>)
    }
}