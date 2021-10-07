// This code was heavily inspired by the rails-ujs project.
// Copyright (c) 2007-2021 Rails Core team.
import { handleConfirm } from "./features/confirm"
import { disableElement, enableElement, handleDisabledElement } from "./features/disable"
import { formSubmitButtonClick, handleRemote, preventInsignificantClick } from "./features/remote"
import { buttonClickSelector, buttonDisableSelector, formInputClickSelector, formSubmitSelector } from "./selectors"

import { delegate } from "./utils/event"

export const getDefaultAssetPath = () => {
  const rootUrl = (document.currentScript as any).src.replace(/\/packs.*$/, "")

  return `${rootUrl}/packs/js/`
}

export const startUjs = () => {
  delegate(document, buttonDisableSelector, "ajax:complete", enableElement)
  delegate(document, buttonDisableSelector, "ajax:stopped", enableElement)

  delegate(document, buttonClickSelector, "click", preventInsignificantClick)
  delegate(document, buttonClickSelector, "click", handleDisabledElement)
  delegate(document, buttonClickSelector, "click", handleConfirm)
  delegate(document, buttonClickSelector, "click", disableElement)
  delegate(document, buttonClickSelector, "click", handleRemote)

  delegate(document, formSubmitSelector, "sl-submit", handleDisabledElement)
  delegate(document, formSubmitSelector, "sl-submit", handleConfirm)
  delegate(document, formSubmitSelector, "sl-submit", handleRemote)

  // simulates a normal form submit:
  delegate(document, formSubmitSelector, "ajax:send", disableElement)
  delegate(document, formSubmitSelector, "ajax:complete", enableElement)

  delegate(document, formInputClickSelector, "click", preventInsignificantClick)
  delegate(document, formInputClickSelector, "click", handleDisabledElement)
  // delegate(document, formInputClickSelector, "click", handleConfirm)
  delegate(document, formInputClickSelector, "click", formSubmitButtonClick)
}
