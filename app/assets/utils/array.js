const addToArray = (arr, item) => [...arr, item]

const removeFromArray = (arr, item, getValue = item => item) => {
  const index = arr.findIndex(i => getValue(i) === getValue(item))
  if (index === -1) return arr
  return removeAtIndex(arr, index)
}

const toggleArrayElement = (arr, item, getValue = item => item) => {
  const index = arr.findIndex(i => getValue(i) === getValue(item))
  if (index === -1) return [...arr, item]
  return removeAtIndex(arr, index)
}

const removeAtIndex = (arr, index) => {
  const copy = [...arr]
  copy.splice(index, 1)
  return copy
}

export { addToArray, removeFromArray, toggleArrayElement, removeAtIndex }
