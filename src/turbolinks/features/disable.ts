// This code was heavily inspired by the rails-ujs project.
// Copyright (c) 2007-2021 Rails Core team.
import { buttonDisableSelector, formDisableSelector, formEnableSelector, formSubmitSelector } from "../selectors"
import { getData, matches, setData } from "../utils/dom"
import { stopEverything } from "../utils/event"
import { formElements } from "../utils/form"

export const handleDisabledElement = (event) => {
  const element: HTMLInputElement | HTMLFormElement = event.target

  if (element.disabled) {
    return stopEverything(event)
  }
}

// Unified function to enable an element (link, button and form)
export const enableElement = function (e) {
  let element

  if (e instanceof Event) {
    if (isXhrRedirect(e)) {
      return
    }
    element = e.target
  } else {
    element = e
  }

  if (matches(element, buttonDisableSelector) || matches(element, formEnableSelector)) {
    return enableFormElement(element)
  } else if (matches(element, formSubmitSelector)) {
    return enableFormElements(element)
  }
}

// Unified function to disable an element (link, button and form)
export const disableElement = function (e) {
  const element = e instanceof Event ? e.target : e

  if (matches(element, buttonDisableSelector) || matches(element, formDisableSelector)) {
    return disableFormElement(element)
  } else if (matches(element, formSubmitSelector)) {
    return disableFormElements(element)
  }
}

// Disables form elements:
//  - Caches element value in 'ujs:enable-with' data store
//  - Replaces element text with value of 'data-disable-with' attribute
//  - Sets disabled property to true
const disableFormElements = (form) => formElements(form, formDisableSelector).forEach(disableFormElement)

const disableFormElement = function (element) {
  if (getData(element, "ujs:disabled")) {
    return
  }

  const replacement = element.getAttribute("data-disable-with")
  if (replacement != null) {
    if (matches(element, "button")) {
      setData(element, "ujs:enable-with", element.innerHTML)
      element.innerHTML = replacement
    } else {
      setData(element, "ujs:enable-with", element.value)
      element.value = replacement
    }
  }
  element.disabled = true
  return setData(element, "ujs:disabled", true)
}

// Re-enables disabled form elements:
//  - Replaces element text with cached value from 'ujs:enable-with' data store (created in `disableFormElements`)
//  - Sets disabled property to false
const enableFormElements = (form) => formElements(form, formEnableSelector).forEach(enableFormElement)

const enableFormElement = function (element) {
  const originalText = getData(element, "ujs:enable-with")
  if (originalText != null) {
    if (matches(element, "button")) {
      element.innerHTML = originalText
    } else {
      element.value = originalText
    }
    setData(element, "ujs:enable-with", null) // clean up cache
  }
  element.disabled = false
  return setData(element, "ujs:disabled", null)
}

const isXhrRedirect = function (event) {
  const xhr = event.detail != null ? event.detail[0] : undefined
  return (xhr != null ? xhr.getResponseHeader("X-Xhr-Redirect") : undefined) != null
}
