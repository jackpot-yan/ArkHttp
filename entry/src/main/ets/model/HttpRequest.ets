import { KeyValuePair } from "./KeyValuePair"

export type BodyType = 'none' | 'json' | 'form-data' | 'urlencoded' | 'text'

@Observed
export class HttpRequest {
  id: string = Math.random().toString(36).slice(2)
  name: string = '新建请求'
  url: string = ''
  method: string = ''
  headers: KeyValuePair[] = []
  params: KeyValuePair[] = []
  bodyType: BodyType = 'none'
  body: string = ''
  timeout: number = 30000
  followRedirect: boolean = true
  verifySsl: boolean = true
  createAt: number = Date.now()
  updateAt: number = Date.now()
}