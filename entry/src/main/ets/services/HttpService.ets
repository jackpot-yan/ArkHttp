import http from '@ohos.net.http'
import { HttpRequest } from '../model/HttpRequest'
import { HttpResponse } from '../model/HttpResponse'
import { KeyValuePair } from '../model/KeyValuePair'
import { BusinessError } from '@ohos.base'
import { retrieval } from '@kit.DataAugmentationKit'

export class HttpService {
  private static instance: HttpService | null = null
  private globalHeaders: Record<string, string> = {}
  private cookieStore: Record<string, string> = {}

  private constructor() {
  }

  static getInstance(): HttpService {
    if (HttpService.instance === null) {
      HttpService.instance = new HttpService()
    }
    return HttpService.instance
  }

  private pairsToRecord(pairs: KeyValuePair[]): Record<string, string> {
    const record: Record<string, string> = {}
    pairs.filter(p => p.enabled && p.key.trim() !== '').forEach(p => {
      record[p.key.trim()] = p.value
    })
    return record
  }

  private buildUrl(request: HttpRequest): string {
    if (Object.keys(request.params).length === 0) {
      return request.url
    }
    const record = this.pairsToRecord(request.params)
    const queryString =
      Object.keys(record).map(k => `${encodeURIComponent(k)}=${encodeURIComponent(record[k])}`).join('&')
    const separator = request.url.includes('?') ? '&' : '?'
    return `${request.url}${separator}${queryString}`
  }

  private mergeHeaders(request: HttpRequest): Record<string, string> {
    const merged: Record<string, string> = {}
    for (const key of Object.keys(this.globalHeaders)) {
      merged[key] = this.globalHeaders[key]
    }
    const domain = this.extractDomain(request.url)
    const cookie = this.cookieStore[domain]
    if (cookie) {
      merged['Cookie'] = cookie
    }
    const customHeaders = this.pairsToRecord(request.headers)
    for (const key of Object.keys(customHeaders)) {
      merged[key] = customHeaders[key]
    }
    return merged
  }

  private extractDomain(url: string): string {
    const match = url.match(/^https?:\/\/([^\/]+)/)
    return match ? match[1] : ''
  }

  private saveCookieFromResponse(url: string, responseHeaders: object): void {
    const headers = responseHeaders as Record<string, string>
    const setCookie = headers['set-cookie'] ?? headers['Set-Cookie']
    if (!setCookie) {
      return
    }
    const domain = this.extractDomain(url)
    const cookieValue = setCookie.split(';')[0].trim()
    this.cookieStore[domain] = cookieValue
  }

  async send(request: HttpRequest): Promise<HttpResponse> {
    const startTime = Date.now()
    const finalUrl = this.buildUrl(request)
    const finalHeaders = this.mergeHeaders(request)
    const httpRequest = http.createHttp()
    try {
      const result = await httpRequest.request(finalUrl, {
        method: request.method as http.RequestMethod,
        header: finalHeaders,
        extraData: request.bodyType === 'none' ? '' : request.body,
        connectTimeout: request.timeout,
        readTimeout: request.timeout
      })
      const duration = Date.now() - startTime
      const bodyStr = typeof result.result === 'string' ? result.result : JSON.stringify(result.result)
      this.saveCookieFromResponse(request.url, result.header)
      const response = new HttpResponse()
      response.statusCode = result.responseCode as number
      response.headers = result.header as Record<string, string>
      response.body = bodyStr
      response.duration = duration
      response.timestamp = Date.now()
      return response
    } catch (err) {
      const error = err as BusinessError
      const response = new HttpResponse()
      response.statusCode = 0
      response.body = `请求失败: ${error.message}\nCode: ${error.code}}`
      response.duration = Date.now() - startTime
      return response
    } finally {
      httpRequest.destroy()
    }
  }

  setGlobalHeader(key: string, value: string): void {
    this.globalHeaders[key] = value
  }

  setCookie(domain: string, cookie: string): void {
    this.cookieStore[domain] = cookie
  }
}