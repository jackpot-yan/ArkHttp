import { HttpRequest } from '../model/HttpRequest'
import { MethodSelector } from '../components/request/MethodSelector'
import { UrlInput } from '../components/request/urlInput'

@Component
export struct RequestPage {
  @State requestInfo: HttpRequest = new HttpRequest()
  @State tabsIndex: number = 0

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
            Column() {
              this.Params()
            }
          }.tabBar('Params')

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
      }.height('45%').width('100%')
    }
  }

  @Builder
  private titleText(title: string) {
    Text(title)
      .fontColor('#ff1e2122')
      .fontSize(14)
      .lineHeight(19)
      .opacity(0.4)
      .margin(0)
      .padding(0)
  }


  @Builder
  Params() {
    Column() {
      this.titleText('Params')
      Button('添加Params')
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