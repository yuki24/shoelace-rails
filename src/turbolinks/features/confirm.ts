// This code was heavily inspired by the rails-ujs project.
// Copyright (c) 2007-2021 Rails Core team.
import { fire, stopEverything } from "../utils/event"

export const handleConfirm = (event) => {
  const { target } = event

  if (!allowAction(target)) {
    return stopEverything(event)
  }
}

// For 'data-confirm' attribute:
// - Fires `confirm` event
// - Shows the confirmation dialog
// - Fires the `confirm:complete` event
//
// Returns `true` if no function stops the chain and user chose yes `false` otherwise.
// Attaching a handler to the element's `confirm` event that returns a `falsy` value cancels the confirmation dialog.
// Attaching a handler to the element's `confirm:complete` event that returns a `falsy` value makes this function
// return false. The `confirm:complete` event is fired whether or not the user answered true or false to the dialog.
const allowAction = (element) => {
  const message = element.getAttribute("data-confirm")

  if (!message) {
    return true
  }

  let callback = null,
    answer = false
  if (fire(element, "confirm")) {
    try {
      answer = confirm(message)
    } catch (error) {
      // no-op...
    }

    callback = fire(element, "confirm:complete", [answer])
  }

  return answer && callback
}
