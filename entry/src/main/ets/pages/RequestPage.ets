import { HttpRequest } from '../model/HttpRequest'
import { MethodSelector } from '../components/request/MethodSelector'
import { UrlInput } from '../components/request/urlInput'
import { KeyValuePair } from '../model/KeyValuePair'
import { KeyValueEditor } from '../components/request/ParamsEditor'

@Component
export struct RequestPage {
  @State requestInfo: HttpRequest = new HttpRequest()
  @State tabsIndex: number = 0
  @State ParamsTable: Array<KeyValuePair> = [
    new KeyValuePair('', ''),
    new KeyValuePair('', '')
  ]

  private sendRequest() {
    console.log(`点击了send按钮, ${this.requestInfo.method}`)
  }

  build() {
    Column() {
      Row() {
        MethodSelector({ request: this.requestInfo }).width('20%')
        UrlInput({ request: this.requestInfo }).width('60%')
        Button('Send').borderRadius(3).margin(10).height(30).onClick((_: ClickEvent) => {
          this.sendRequest()
        })
      }.margin(0).padding(0).width('100%').height('10%')

      Column() {
        Tabs() {
          TabContent() {
            this.Params()
          }.tabBar('Params').margin(0).padding(0)

          TabContent() {
            Column() {
              this.Headers()
            }
          }.tabBar('Headers')

          TabContent() {
            Column() {
              this.Body()
            }
          }.tabBar('Body')

          TabContent() {
            Column() {
              this.Auth()
            }
          }.tabBar('Auth')
        }.vertical(false).scrollable(true)
      }.height('90%').width('100%')
    }
  }

  @Builder
  Params() {
    Column() {
      KeyValueEditor({ items: this.ParamsTable, label: 'Params' }).height('50%').padding(0).margin(0).width('100%')
      Divider().strokeWidth(1)       // 线宽（vp）
        .color('#E5E5E5')
    }.justifyContent(FlexAlign.Start).alignItems(HorizontalAlign.Start).width('100%').height('100%')
  }

  @Builder
  Headers() {
  }

  @Builder
  Auth() {
  }

  @Builder
  Body() {
    TextArea()
  }
}