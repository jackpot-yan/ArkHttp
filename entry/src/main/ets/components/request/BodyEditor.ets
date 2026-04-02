import { KeyValuePair } from '../../model/KeyValuePair'
import { HttpRequest, BodyType } from '../../model/HttpRequest'

@Component
export struct BodyRow {
  @Link item: KeyValuePair[]
  @ObjectLink request: HttpRequest
  @State bodyRow: string = ''
  @State bodyType: BodyType = 'none'

  @Builder
  RadioItem(value: BodyType, label: string) {
    Row() {
      Radio({ value: value, group: 'bodyType' }).checked(this.bodyType === value)
      Text(label)
    }
  }

  build() {
    Column({ space: 0 }) {
      Column() {
        Text("Body")
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_secondary'))
          .lineHeight(19)
          .opacity(0.4)
          .margin({ bottom: 5 })
          .padding(0)
        Column() {
        }
      }
    }
  }
}