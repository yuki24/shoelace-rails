import { Snapshot, SnapshotRenderer, ErrorRenderer, uuid } from "turbolinks"
import { formSubmitSelector } from "./selectors"
import { matches } from "./utils/dom"
import { delegate } from "./utils/event"

const nullCallback = function () {}
const nullDelegate = {
  viewInvalidated: nullCallback,
  viewWillRender: nullCallback,
  viewRendered: nullCallback,
}

const renderWithTurbolinks = (htmlContent) => {
  const currentSnapshot = Snapshot.fromHTMLElement(document.documentElement)
  const newSnapshot = Snapshot.fromHTMLString(htmlContent)
  let renderer = new SnapshotRenderer(currentSnapshot, newSnapshot, false)

  if (!renderer.shouldRender()) {
    renderer = new ErrorRenderer(htmlContent)
  }

  renderer.delegate = nullDelegate
  renderer.render(nullCallback)
}

const findActiveElement = (shadowRoot: ShadowRoot) => {
  let el = shadowRoot.activeElement

  while (el && el.shadowRoot && el.shadowRoot.activeElement) {
    el = el.shadowRoot.activeElement
  }

  return el
}

export const addShadowDomSupportToTurbolinks = (turbolinksController) => {
  // From https://github.com/turbolinks/turbolinks/blob/71b7a7d0546a573735af99113b622180e8a813c2/src/util.ts#L9
  // © 2019 Basecamp, LLC.
  const originalClosest: typeof turbolinksController.closest = turbolinksController.closest

  turbolinksController.closest = (node, selector) => {
    if (!!node.shadowRoot) {
      const rootActiveElement = findActiveElement(node.shadowRoot) || node

      if (matches(rootActiveElement, selector)) {
        return rootActiveElement
      }
    } else {
      return originalClosest(node, selector)
    }
  }
}

export const handleResponse = (turbolinksInstance) => {
  return (event: CustomEvent<[XMLHttpRequest, string]>) => {
    const [xhr, _status] = event.detail

    if (xhr.getResponseHeader("Content-Type").startsWith("text/html")) {
      turbolinksInstance.restorationIdentifier = uuid()
      turbolinksInstance.clearCache()
      turbolinksInstance.dispatch("turbolinks:before-cache")
      turbolinksInstance.controller.pushHistoryWithLocationAndRestorationIdentifier(
        xhr.responseURL,
        turbolinksInstance.restorationIdentifier
      )
      renderWithTurbolinks(xhr.responseText)
      window.scroll(0, 0)
      turbolinksInstance.dispatch("turbolinks:load")
    }
  }
}

export const startTurbolinks = (turbolinksInstance) => {
  delegate(document, formSubmitSelector, "ajax:complete", handleResponse(turbolinksInstance))
  addShadowDomSupportToTurbolinks(turbolinksInstance)
}
