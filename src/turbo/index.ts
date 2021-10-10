import { polyfillFormDataEvent } from "./polyfills/formdata_event"
import { SlTurboFormElement } from "./sl-turbo-form"

export const startTurbo = () => {
  polyfillFormDataEvent(window)
  customElements.define("sl-turbo-form", SlTurboFormElement)
}
