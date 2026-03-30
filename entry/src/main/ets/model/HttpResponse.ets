@Observed
export class HttpResponse {
  statusCode: number = 200
  headers: Record<string, string> = {}
  body: string = ''
  duration: number = 0
  size: number = 0
  timestamp: number = 0
}