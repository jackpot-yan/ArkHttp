import { HttpResponse } from '../../model/HttpResponse'
import {
  getStatusColor, getStatusText, formatSize, formatDuration
} from '../../utils/StatusCodeCodeUtils'
import { prettyJson, tokenizeJson, JsonToken } from '../../utils/JsonHighlight'

type ResponseTab = 'body' | 'headers'

@Component
export struct ResponsePanel {
  @Prop response: HttpResponse = new HttpResponse()
  @Prop isLoading: boolean = false
  @State activeTab: ResponseTab = 'body'

  build() {
    Column() {
      if (this.isLoading) {
        this.LoadingView()
      } else if (this.response.statusCode === 0) {
        this.EmptyView()
      } else {
        this.ResponseView()
      }
    }
    .width('100%')
    .backgroundColor('#1E1E1E')
    .borderRadius(12)
  }

  // 加载中
  @Builder
  LoadingView() {
    Column({ space: 12 }) {
      LoadingProgress().width(32).height(32).color('#378ADD')
      Text('请求中...').fontSize(13).fontColor('#888888')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // 空状态
  @Builder
  EmptyView() {
    Column({ space: 8 }) {
      Text('发送请求后，响应结果将显示在这里')
        .fontSize(13)
        .fontColor('#666666')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(20)
  }

  // 响应内容
  @Builder
  ResponseView() {
    Column() {

      // 状态栏：状态码 + 耗时 + 大小
      Row({ space: 10 }) {
        // 状态码徽标
        Row({ space: 6 }) {
          Circle({ width: 8, height: 8 })
            .fill(getStatusColor(this.response.statusCode))
          Text(`${this.response.statusCode} ${getStatusText(this.response.statusCode)}`)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor(getStatusColor(this.response.statusCode))
        }
        .padding({
          left: 10,
          right: 10,
          top: 5,
          bottom: 5
        })
        .borderRadius(6)
        .border({
          width: 0.5,
          color: getStatusColor(this.response.statusCode)
        })

        // 耗时
        Row({ space: 4 }) {
          Text(formatDuration(this.response.duration))
            .fontSize(12)
            .fontColor('#888888')
          Text('·').fontSize(12).fontColor('#555555')
          Text(formatSize(this.response.size))
            .fontSize(12)
            .fontColor('#888888')
        }

        Blank()

        Text('复制')
          .fontSize(12)
          .fontColor('#378ADD')
          .onClick(() => {
            // TODO: 接入剪贴板
          })
      }
      .width('100%')
      .padding({
        left: 12,
        right: 12,
        top: 10,
        bottom: 10
      })
      .border({ width: { bottom: 0.5 }, color: '#333333' })

      Row() {
        Text('Body')
          .fontSize(13)
          .fontColor(this.activeTab === 'body' ? '#378ADD' : '#888888')
          .fontWeight(this.activeTab === 'body' ? FontWeight.Medium : FontWeight.Normal)
          .padding({ right: 16, top: 8, bottom: 8 })
          .border({
            width: { bottom: this.activeTab === 'body' ? 2 : 0 },
            color: '#378ADD'
          })
          .onClick(() => {
            this.activeTab = 'body'
          })

        Text('Headers')
          .fontSize(13)
          .fontColor(this.activeTab === 'headers' ? '#378ADD' : '#888888')
          .fontWeight(this.activeTab === 'headers' ? FontWeight.Medium : FontWeight.Normal)
          .padding({ right: 16, top: 8, bottom: 8 })
          .border({
            width: { bottom: this.activeTab === 'headers' ? 2 : 0 },
            color: '#378ADD'
          })
          .onClick(() => {
            this.activeTab = 'headers'
          })
      }
      .width('100%')
      .padding({ left: 12 })
      .border({ width: { bottom: 0.5 }, color: '#333333' })

      if (this.activeTab === 'body') {
        this.BodyView()
      } else {
        this.HeadersView()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  BodyView() {
    Scroll() {
      Column() {
        if (this.isJson()) {
          this.JsonView()
        } else {
          Text(this.response.body)
            .fontSize(12)
            .fontColor('#CCCCCC')
            .fontFamily('monospace')
            .width('100%')
            .lineHeight(20)
        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding(12)
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
  }

  @Builder
  JsonView() {
    // 把格式化后的 JSON 按行分割，逐行渲染
    ForEach(prettyJson(this.response.body).split('\n'), (line: string, index: number) => {
      Row() {
        // 行号
        Text(`${(index + 1)}`)
          .fontSize(11)
          .fontColor('#ffeae5e5')
          .fontFamily('monospace')
          .width(30)
          .textAlign(TextAlign.End)
          .padding({ right: 10 })

        Row() {
          ForEach(tokenizeJson(line), (token: JsonToken) => {
            Text(token.text)
              .fontSize(12)
              .fontColor(token.color)
              .fontFamily('monospace')
          }, (token: JsonToken, i: number) => `${index}-${i}`)
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)
    }, (line: string, i: number) => `line-${i}`)
  }

  @Builder
  HeadersView() {
    Scroll() {
      Column() {
        ForEach(Object.keys(this.response.headers), (key: string) => {
          Row() {
            Text(key)
              .fontSize(12)
              .fontColor('#9CDCFE')
              .fontFamily('monospace')
              .layoutWeight(1)
            Text(this.response.headers[key])
              .fontSize(12)
              .fontColor('#CE9178')
              .fontFamily('monospace')
              .layoutWeight(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }
          .width('100%')
          .padding({ top: 6, bottom: 6 })
          .border({ width: { bottom: 0.5 }, color: '#2A2A2A' })
        }, (key: string) => key)
      }
      .width('100%')
      .padding(12)
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .layoutWeight(1)
  }

  private isJson(): boolean {
    const body = this.response.body.trim()
    return (body.startsWith('{') || body.startsWith('['))
  }
}