import { KeyValuePair } from '../../model/KeyValuePair'
import { KeyValueRow } from './KeyValueRow'

@Component
export struct KeyValueEditor {
  @Link items: KeyValuePair[]
  label: string = ''

  private addRow(): void {
    this.items.push(new KeyValuePair())
  }

  private deleteRow(id: string): void {
    const index = this.items.findIndex(item => item.id === id)
    if (index !== -1) {
      this.items.splice(index, 1)
    }
  }

  private toggleRow(id: string): void {
    const item = this.items.find(item => item.id === id)
    if (item) {
      item.enabled = !item.enabled
    }
  }

  build() {
    Column({ space: 0 }) {
      Column() {
        Text(this.label)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_secondary'))
          .lineHeight(19)
          .opacity(0.4)
          .margin({ bottom: 5 })
          .padding(0)

        Scroll() {
          Column({ space: 0 }) {
            ForEach(this.items, (item: KeyValuePair) => {
              KeyValueRow({
                item: item,
                onDelete: () => this.deleteRow(item.id),
                onToggle: () => this.toggleRow(item.id)
              }).margin({ bottom: 8 })
            }, (item: KeyValuePair) => item.id)
            Row({ space: 6 }) {
              Text('+').fontSize(16).fontColor($r('sys.color.font_secondary'))
              Text(`添加${this.label}`).fontSize(13).fontColor($r('sys.color.font_secondary'))

            }.padding({ top: 10, bottom: 4 }).onClick(() => this.addRow())
          }.alignItems(HorizontalAlign.Start)
        }.scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Auto) // 有内容超出时自动显示滚动条
        .edgeEffect(EdgeEffect.Spring) // 滑到边缘有回弹效果
      }.width('100%').alignItems(HorizontalAlign.Start)
    }
  }
}