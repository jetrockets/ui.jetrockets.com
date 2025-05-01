const booleanOptions = [
  'readonly',
  'autoApply',
  'inline',
  'header'
]

const stringOptions = [
  'lang',
  'date',
  'format'
]

const numberOptions = [
  'firstDay',
  'grid',
  'calendars',
  'zIndex'
]

const rangeStringOptions = [
  'startDate',
  'endDate',
  'delimiter'
]

const rangeBooleanOptions = [
  'repick',
  'strict',
  'tooltip'
]

const lockStringOptions = [
  'minDate',
  'maxDate'
]

const lockBooleanOptions = [
  'selectForward',
  'selectBackward',
  'presets',
  'inseparable',
  'filter'
]

const lockNumberptions = [
  'minDays',
  'maxDays'
]

const ampBooleanOptions = [
  'resetButton',
  'darkMode',
  'weekNumbers'
]

const ampObjectOptions = [
  'dropdown'
]

export const coreOptions = {
  string: stringOptions,
  boolean: booleanOptions,
  number: numberOptions
}

export const rangeOptions = {
  string: rangeStringOptions,
  boolean: rangeBooleanOptions
}

export const lockOptions = {
  string: lockStringOptions,
  boolean: lockBooleanOptions,
  number: lockNumberptions
}

export const ampOptions = {
  boolean: ampBooleanOptions,
  object: ampObjectOptions
}
