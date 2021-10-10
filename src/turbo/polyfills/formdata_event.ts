// Most of the code originates from https://github.com/webcomponents/polyfills/issues/172#issuecomment-930011955
// Copyright (c) 2021 Nick Williams. All rights reserved.
//
// And the code was modified by YUki Nishijima.
// Copyright (c) 2021 YUki Nishijima. All rights reserved.
class FormDataEvent extends Event {
  formData: FormData

  constructor(formData, options) {
    super("formdata", options)
    this.formData = formData
  }
}

class FormDataPolyfilled extends FormData {
  form: HTMLFormElement

  constructor(form) {
    super(form)
    this.form = form
    form?.dispatchEvent(new FormDataEvent(this, { bubbles: true }))
  }

  append(name, value) {
    if (!this.form) {
      super.append(name, value)
      return
    }

    let input = this.form.elements[name] as HTMLInputElement

    if (!input) {
      input = document.createElement("input")
      input.type = "hidden"
      input.name = name
      this.form.appendChild(input)
    }

    // if the name already exists, there is already a hidden input in the dom
    // and it will have been picked up by FormData during construction.
    // in this case, we can't just blindly append() since that will result in two entries.
    // nor can we blindly delete() the entry, since there can be multiple entries per name (e.g. checkboxes).
    // so we must carefully splice out the old value, and add back in the new value
    if (this.has(name)) {
      const entries = this.getAll(name)
      const index = entries.indexOf(input.value)

      if (index !== -1) {
        entries.splice(index, 1)
      }

      entries.push(value)
      this.set(name, entries as any)
    } else {
      super.append(name, value)
    }

    input.value = value
  }
}

function supportsFormDataEvent({ document }) {
  let isSupported = false

  const form = document.createElement("form")
  document.body.appendChild(form)

  form.addEventListener("submit", e => {
    e.preventDefault()
    // this dispatches formdata event in browsers that support it
    new FormData(e.target)
  })

  form.addEventListener("formdata", () => {
    isSupported = true
  })

  form.dispatchEvent(new Event("submit"))
  form.remove()

  return isSupported
}

export function polyfillFormDataEvent(win) {
  if (!win.FormData || navigator.userAgent.includes("Firefox") || supportsFormDataEvent(win)) {
    return
  }

  window.FormData = FormDataPolyfilled
}
