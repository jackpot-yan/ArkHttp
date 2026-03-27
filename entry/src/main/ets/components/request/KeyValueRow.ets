import { KeyValuePair } from '../../model/KeyValuePair'

@Component
export struct KeyValueRow {
  @ObjectLink item: KeyValuePair
  onDelete: () => void = () => {
  }
  onToggle: () => void = () => {
  }

  build() {
    Row({ space: 8 }) {
      Circle({ width: 10, height: 10 }).fill(this.item.enabled ? '#52c41A' : '#888888').onClick(() => this.onToggle())
      TextInput({ text: this.item.key, placeholder: 'key' })
        .fontSize(13)
        .layoutWeight(1)
        .height(36)
        .borderRadius(8)
        .fontColor(this.item.enabled ? $r('sys.color.font_primary') : $r('sys.color.font_tertiary'))
        .onChange((val) => {
          this.item.key = val
        })
      TextInput({ text: this.item.value, placeholder: 'Value' })
        .fontSize(13)
        .layoutWeight(1.5)
        .height(36)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .borderRadius(8)
        .fontColor(this.item.enabled ? $r('sys.color.font_secondary') : $r('sys.color.font_tertiary'))
        .onChange((val) => {
          this.item.value = val
        })
      Text('x')
        .fontSize(18)
        .fontColor($r('sys.color.font_tertiary'))
        .width(24)
        .height(36)
        .textAlign(TextAlign.Center)
        .onClick(() => this.onDelete())
    }
  }
}