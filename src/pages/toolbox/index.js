import React from 'react'
import { Layout, Breadcrumb, Input, Form, Row, Col } from "antd";

export default class ToolboxPage extends React.Component {

    onChange = () => {
        const { value } = this.jsonText.state
        if (value != undefined) {
            var jsonObj = JSON.parse(value)
            var arr = []
            Object.keys(jsonObj).forEach(item => {
                switch (typeof jsonObj[item]) {
                    case "string":
                        arr.push("@property (nonatomic, copy) NSString *" + item + ";");
                        break
                    case "number":
                        arr.push("@property (nonatomic, assign) NSInteger " + item + ";");
                        break;
                    case "boolean":
                        arr.push("@property (nonatomic, assign) BOOL " + item + ";");
                        break
                }
            })
            this.outText.setState({ value: arr.join("\n") })
        }

    }

    render() {
        return (<Layout>
            <Breadcrumb style={{ marginBottom: 12 }}>
                <Breadcrumb.Item>
                    <a href="/">首页</a>
                </Breadcrumb.Item>
                <Breadcrumb.Item>工具箱</Breadcrumb.Item>
            </Breadcrumb>

            <Row gutter={2}>
                <Col span={12}>
                    <Input.TextArea ref={(ref) => this.jsonText = ref} placeholder="输入JSON数据" onChange={this.onChange} autoSize={{ minRows: 30, maxRows: 30 }} />
                </Col>
                <Col span={12}>
                    <Input.TextArea ref={(ref) => this.outText = ref} placeholder="输出结果" autoSize={{ minRows: 30, maxRows: 30 }} />
                </Col>
            </Row>



        </Layout >)
    }
}