import { HttpRequest } from '../../model/HttpRequest'

@Component
export struct UrlInput {
  @ObjectLink request: HttpRequest

  private getInputString(value: string) {
    this.request.url = value
  }

  build() {
    TextInput()
      .onChange((value: string) => {
        this.getInputString(value)
      })
      .onPaste((value: string) => {
        this.getInputString(value)
      })
      .margin(0)
      .padding(0)
      .borderRadius(0).height(30)
  }
}