import { RequestPage } from './RequestPage'
import { HistoryPage } from './HistoryPage'
import { CollectionPage } from './CollectionPage'
import { SettingsPage } from './SettingsPage'

@Entry
@Component
struct Index {
  @StorageProp('currentBreakpoint') breakpoint: string = 'sm'
  pageStack: NavPathStack = new NavPathStack()
  @State pageNumber: number = 1

  build() {
    if (this.breakpoint == 'lg') {
      //TODO PC双栏布局
    } else {
      Navigation(this.pageStack) {
        if (this.pageNumber == 1) {
          RequestPage().width('90%')
        }
        if (this.pageNumber == 2) {
          HistoryPage().width('90%')
        }
        if (this.pageNumber == 3) {
          CollectionPage().width('90%')
        }
        if (this.pageNumber == 4) {
          SettingsPage().width('90%')
        }
      }.mode(NavigationMode.Stack).toolbarConfiguration([
        {
          value: "请求",
          icon: $r('app.media.startIcon'),
          action: () => {
            this.pageNumber = 1
          }
        },
        {
          value: "历史",
          icon: $r('app.media.startIcon'),
          action: () => {
            this.pageNumber = 2
          }
        },
        {
          value: "集合",
          icon: $r('app.media.startIcon'),
          action: () => {
            this.pageNumber = 3
          }
        },
        {
          value: "设置",
          icon: $r('app.media.startIcon'),
          action: () => {
            this.pageNumber = 4
          }
        }
      ])
    }
  }
}