import React from 'react'
import DeviceLog from './logs'

export default class IndexPage extends React.Component {
  render() {
    const data = {deviceId: "1B7F03BF-8C78-4229-AE8B-9432885AB11B"}
    return (
        <DeviceLog data={data} />
    )
  }
}
