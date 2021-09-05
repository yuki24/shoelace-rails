// This code was heavily inspired by the rails-ujs project.
// Copyright (c) 2007-2021 Rails Core team.
import { matches } from "./dom"

// Triggers a custom event on an element and returns false if the event result is false
// obj::
//   a native DOM element
// name::
//   string that corresponds to the event you want to trigger
//   e.g. 'click', 'submit'
// data::
//   data you want to pass when you dispatch an event
export const fire = (obj, name, data = {}) => {
  const event = new CustomEvent(name, {
    bubbles: true,
    cancelable: true,
    detail: data,
  })

  obj.dispatchEvent(event)
  return !event.defaultPrevented
}

// Helper function, needed to provide consistent behavior in IE
export const stopEverything = (event) => {
  fire(event.target, "ujs:everythingStopped")

  event.preventDefault()
  event.stopPropagation()

  return event.stopImmediatePropagation()
}

// Delegates events
// to a specified parent `element`, which fires event `handler`
// for the specified `selector` when an event of `eventType` is triggered
// element::
//   parent element that will listen for events e.g. document
// selector::
//   CSS selector; or an object that has `selector` and `exclude` properties (see: Rails.matches)
// eventType::
//   string representing the event e.g. 'submit', 'click'
// handler::
//   the event handler to be called
export const delegate = (element, selector, eventType, handler) =>
  element.addEventListener(eventType, function (event) {
    let { target } = event

    while (!!(target instanceof Element) && !matches(target, selector)) {
      target = target.parentNode
    }

    if (target instanceof Element && handler.call(target, event) === false) {
      event.preventDefault()
      return event.stopPropagation()
    }
  })
