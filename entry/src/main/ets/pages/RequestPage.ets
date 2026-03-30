import { HttpRequest } from '../model/HttpRequest'
import { MethodSelector } from '../components/request/MethodSelector'
import { UrlInput } from '../components/request/urlInput'
import { KeyValuePair } from '../model/KeyValuePair'
import { KeyValueEditor } from '../components/request/ParamsEditor'
import { HttpResponse } from '../model/HttpResponse'
import { ResponsePanel } from '../components/response/ResponsePanel'
import { HttpService } from '../services/HttpService'

@Component
export struct RequestPage {
  @State requestInfo: HttpRequest = new HttpRequest()
  @State tabsIndex: number = 0
  @State ParamsTable: Array<KeyValuePair> = [
    new KeyValuePair('', ''),
    new KeyValuePair('', '')
  ]
  @State response: HttpResponse = new HttpResponse()
  @State isLoading: boolean = false
  private httpService = HttpService.getInstance()

  private async sendRequest(): Promise<void> {
    if (!this.requestInfo.url) {
      return
    }
    this.isLoading = true
    try {
      this.response = await this.httpService.send(this.requestInfo)
    } finally {
      this.isLoading = false
    }
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
      ResponsePanel({
        response: this.response,
        isLoading: this.isLoading
      }).height('50%').width('100%').margin(0).padding(0)
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