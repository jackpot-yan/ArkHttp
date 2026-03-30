export function getStatusColor(code: number): string {
  if (code >= 200 && code < 300) {
    return '#52C41A'
  }
  if (code >= 300 && code < 400) {
    return '#1890FF'
  }
  if (code >= 400 && code < 500) {
    return '#FABC16'
  }
  if (code > 500) {
    return '#FF4D4F'
  }
  return '#888888'
}

export function getStatusText(code: number): string {
  const map: Record<number, string> = {
    200: 'OK',
    201: 'Created',
    204: 'No Content',
    301: 'Moved Permanently',
    302: 'Found',
    304: 'Not Modified',
    400: 'Bad Request',
    401: 'Unauthorized',
    403: 'Forbidden',
    404: 'Not Found',
    405: 'Method Not Allowed',
    429: 'Too Many Requests',
    500: 'Internal Server Error',
    502: 'Bad Gateway',
    503: 'Service Unavailable',
  }
  return map[code] ?? 'Unkown'
}

export function formatSize(bytes: number): string {
  if (bytes < 1024) {
    return `${bytes}B`
  }
  if (bytes < 1024 * 1024) {
    return `${(bytes / 1024).toFixed(1)}KB`
  }
  return `${(bytes / 1024 / 1024).toFixed(1)}MB`
}

export function formatDuration(ms: number): string {
  if (ms < 1000) {
    return `${ms}ms`
  }
  return `${(ms / 1000).toFixed(2)}s`
}