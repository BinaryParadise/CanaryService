import React from 'react'
import DeviceLog from './logs'

export default class IndexPage extends React.Component {
  render() {
    const data = {deviceId: "faljeigjasleigj"}
    return (
        <DeviceLog data={data} />
    )
  }
}
