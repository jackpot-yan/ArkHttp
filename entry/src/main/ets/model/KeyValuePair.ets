@Observed
export class KeyValuePair {
  id: string = Math.random().toString(36).slice(2)
  key: string = ''
  value: string = ''
  enabled: boolean = true
}