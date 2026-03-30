import { JSON } from "@kit.ArkTS"

export interface JsonToken {
  text: string
  color: string
}

export function prettyJson(raw: string): string {
  try {
    return JSON.stringify(JSON.parse(raw), null, 2)
  } catch {
    return raw
  }
}

export function tokenizeJson(line: string): JsonToken[] {
  const tokens: JsonToken[] = []
  let i = 0
  while (i < line.length) {
    if (line[i] === '' || line[i] === '\t') {
      let s = ''
      while (i < line.length && (line[i] === '' || line[i] === '\t')) {
        s += line[i]
        i++
      }
      tokens.push({ text: s, color: '#CCCCCC' })
      continue
    }
    if (line[i] === '"') {
      let s = '"'
      i++
      while (i < line.length && line[i] !== '"') {
        if (line[i] === '\\') {
          s += line[i]
          i++
        }
        if (i < line.length) {
          s += line[i]
          i++
        }
      }
      s += '"'
      i++
      let j = i
      while (j < line.length && line[i] === ' ') {
        j++
      }
      if (j < line.length && line[j] === ':') {
        tokens.push({ text: s, color: '#9CDCFE' })
      } else {
        tokens.push({ text: s, color: '#CE9178' })
      }
      continue
    }
    if ((line[i] >= '0' && line[i] <= '9') || line[i] === '-') {
      let s = ''
      while (i < line.length && (
        (line[i] >= '0' && line[i] <= '9') ||
          line[i] === '.' || line[i] === '-' ||
          line[i] === 'e' || line[i] === 'E' ||
          line[i] === '+'
      )) {
        s += line[i]
        i++
      }
      tokens.push({ text: s, color: '#B5CEA8' })
      continue
    }
    if (line.startsWith('true', i)) {
      tokens.push({ text: 'true', color: '#569CD6' })
      i += 4
      continue
    }
    if (line.startsWith('false', i)) {
      tokens.push({ text: 'false', color: '#569CD6' })
      i += 5
      continue
    }
    if (line.startsWith('null', i)) {
      tokens.push({ text: 'null', color: '#569CD6' })
      i += 4
      continue
    }
    tokens.push({ text: line[i], color: '#CCCCCC' })
  }
  return tokens
}