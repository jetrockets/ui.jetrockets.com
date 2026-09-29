const UNITS = ['B', 'KB', 'MB', 'GB', 'TB']

/** Icon names map to the classes generated in ~/stylesheets/tailwind/icons.css. */
const ICONS = [
  [/^image\//, 'photo'],
  [/^video\//, 'film'],
  [/^audio\//, 'musical-note'],
  [/^text\//, 'document-text'],
  [/pdf$/, 'document-text'],
  [/(zip|tar|rar|7z|gzip|compressed)/, 'archive-box'],
  [/(sheet|excel|csv)/, 'table-cells']
]

export const formatBytes = (bytes) => {
  if (!Number.isFinite(bytes) || bytes <= 0) return '0 B'

  const exponent = Math.min(Math.floor(Math.log(bytes) / Math.log(1024)), UNITS.length - 1)
  const value = bytes / 1024 ** exponent
  const precision = exponent === 0 ? 0 : 1

  return `${value.toFixed(precision)} ${UNITS[exponent]}`
}

export const fileIcon = (type) => {
  const match = ICONS.find(([pattern]) => pattern.test(type || ''))

  return match ? match[1] : 'paper-clip'
}
