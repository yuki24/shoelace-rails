import { formSubmitSelector } from "../selectors"
import { ajax, href, isCrossDomain } from "../utils/ajax"
import { getData, matches, setData } from "../utils/dom"
import { fire, stopEverything } from "../utils/event"

const isRemote = function (element) {
  const value = element.getAttribute("data-remote")
  return value != null && value !== "false"
}

export const handleRemote = function (event: CustomEvent<{ formData: FormData; formControls: HTMLElement[] }>) {
  const element = this

  if (!isRemote(element)) {
    return true
  }

  if (!fire(element, "ajax:before")) {
    fire(element, "ajax:stopped")
    return false
  }

  let method, url, data

  const withCredentials = element.getAttribute("data-with-credentials")
  const dataType = element.getAttribute("data-type") || "script"

  if (matches(element, formSubmitSelector)) {
    // memoized value from clicked submit button
    method = getData(element, "ujs:submit-button-formmethod") || element.getAttribute("method") || "GET"
    url = getData(element, "ujs:submit-button-formaction") || element.getAttribute("action") || location.href

    // strip query string if it's a GET request
    if (method.toUpperCase() === "GET") {
      url = url.replace(/\?.*$/, "")
      data = Array.from<Array<string>, string>(event.detail.formData as any, (e) =>
        e.map(encodeURIComponent).join("=")
      ).join("&")
    } else {
      data = event.detail.formData
    }

    setData(element, "ujs:submit-button", null)
    setData(element, "ujs:submit-button-formmethod", null)
    setData(element, "ujs:submit-button-formaction", null)
  } else {
    method = element.getAttribute("data-method")
    url = href(element)
    data = element.getAttribute("data-params")
  }

  ajax({
    type: method,
    url,
    data,
    dataType,
    // stopping the "ajax:beforeSend" event will cancel the ajax request
    beforeSend: (xhr, options) => {
      if (fire(element, "ajax:beforeSend", [xhr, options])) {
        return fire(element, "ajax:send", [xhr])
      } else {
        fire(element, "ajax:stopped")
        return false
      }
    },
    success: (...args) => fire(element, "ajax:success", args),
    error: (...args) => fire(element, "ajax:error", args),
    complete: (...args) => fire(element, "ajax:complete", args),
    crossDomain: isCrossDomain(url),
    withCredentials: withCredentials != null && withCredentials !== "false",
  })

  return stopEverything(event)
}

export const formSubmitButtonClick = (event) => {
  const button: HTMLButtonElement = event.target
  const { form } = button

  if (!form) {
    return
  }

  if (button.name) {
    setData(form, "ujs:submit-button", { name: button.name, value: button.value })
  }

  setData(form, "ujs:formnovalidate-button", button.formNoValidate)
  setData(form, "ujs:submit-button-formaction", button.getAttribute("formaction"))
  return setData(form, "ujs:submit-button-formmethod", button.getAttribute("formmethod"))
}

export const preventInsignificantClick = (event) => {
  const link: HTMLElement = event.target

  const method = (link.getAttribute("data-method") || "GET").toUpperCase()
  const data = link.getAttribute("data-params")
  const metaClick = event.metaKey || event.ctrlKey
  const insignificantMetaClick = metaClick && method === "GET" && !data
  const nonPrimaryMouseClick = event.button != null && event.button !== 0

  if (nonPrimaryMouseClick || insignificantMetaClick) {
    return event.stopImmediatePropagation()
  }
}
