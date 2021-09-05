// This code was heavily inspired by the rails-ujs project.
// Copyright (c) 2007-2021 Rails Core team.
export const buttonClickSelector = {
  selector: "sl-button[data-remote]:not([form]), sl-button[data-confirm]:not([form])",
  exclude: "sl-form sl-button",
}

export const formSubmitSelector = "sl-form[data-remote]"

export const formInputClickSelector = [
  "sl-form sl-button[submit]",
  "sl-form sl-button:not([type])",
  "sl-button[submit][sl-form]",
  "sl-button[sl-form]:not([type])",
].join(", ")

export const formDisableSelector = [
  "sl-input[data-disable-with]:not([disabled])",
  "sl-button[data-disable-with]:not([disabled])",
  "sl-textarea[data-disable-with]:not([disabled])",
  "sl-input[data-disable]:not([disabled])",
  "sl-button[data-disable]:not([disabled])",
  "sl-textarea[data-disable]:not([disabled])",
].join(", ")

export const formEnableSelector = [
  "sl-input[data-disable-with][disabled]",
  "sl-button[data-disable-with][disabled]",
  "sl-textarea[data-disable-with][disabled]",
  "sl-input[data-disable][disabled]",
  "sl-button[data-disable][disabled]",
  "sl-textarea[data-disable][disabled]",
].join(", ")

export const buttonDisableSelector = [
  "sl-button[data-remote][data-disable-with]",
  "sl-button[data-remote][data-disable]",
].join(", ")
