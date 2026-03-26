import { KeyValuePair } from '../../model/KeyValuePair'

@Component
export struct KeyValueEditor {
  @ObjectLink items: KeyValuePair[]
  @Link label: string

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
    }
  }
}