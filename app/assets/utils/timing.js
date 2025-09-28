export function throttle (fn, delay = 1000) {
  let timeoutId = null

  return (...args) => {
    if (!timeoutId) {
      fn(...args)
      timeoutId = setTimeout(() => { timeoutId = null }, delay)
    }
  }
}

export function debounce (fn, delay = 1000) {
  let timeoutId = null

  return (...args) => {
    clearTimeout(timeoutId)
    timeoutId = setTimeout(() => { fn.apply(this, args) }, delay)
  }
}
