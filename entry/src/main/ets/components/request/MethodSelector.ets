import { HttpRequest } from '../../model/HttpRequest'

@Component
export struct MethodSelector {
  @ObjectLink request: HttpRequest

  build() {
    Select([
      { value: 'GET' },
      { value: 'POST' },
      { value: 'DELETE' },
      { value: 'OPTIONS' },
      { value: 'PUT' },
      { value: 'PATCH' },
      { value: 'HEAD' },
    ])
      .font({ size: 12, weight: 300 })
      .backgroundColor('#ff65a5cf')
      .avoidance(AvoidanceMode.COVER_TARGET)
      .menuOutline({
        width: '1vp',
        color: '#ffc8d9ef'
      })
      .onSelect((index: number, value: string | undefined) => {
        if (value) {
          console.error(`打印选择: ${value}`)
          this.request.method = value
        }
      }).margin(0).padding(0).borderRadius(5).width('100%').height(10)
  }
}