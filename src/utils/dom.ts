const elementPrototype = Element.prototype as any

const m: (this: Element, selector: string) => boolean =
  elementPrototype.matches ||
  elementPrototype.matchesSelector ||
  elementPrototype.mozMatchesSelector ||
  elementPrototype.msMatchesSelector ||
  elementPrototype.oMatchesSelector ||
  elementPrototype.webkitMatchesSelector

// Checks if the given native dom element matches the selector
// element::
//   native DOM element
// selector::
//   CSS selector string or
//   a JavaScript object with `selector` and `exclude` properties
//   Examples: "form", { selector: "form", exclude: "form[data-remote='true']"}
export const matches = (element, selector) => {
  if (selector.exclude != null) {
    return m.call(element, selector.selector) && !m.call(element, selector.exclude)
  } else {
    return m.call(element, selector)
  }
}

// get and set data on a given element using "expando properties"
// See: https://developer.mozilla.org/en-US/docs/Glossary/Expando
const expando = "_ujsData"

export const getData = (element, key) => (element[expando] != null ? element[expando][key] : undefined)

export const setData = (element, key, value) => {
  if (element[expando] == null) {
    element[expando] = {}
  }

  return (element[expando][key] = value)
}
