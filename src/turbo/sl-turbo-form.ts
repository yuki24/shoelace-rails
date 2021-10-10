interface SlForm extends HTMLElement {
  getFormData: () => FormData
}

interface FormDataEvent extends Event {
  formData: FormData
}

interface SubmitEvent extends CustomEvent {
  submitter: Element
}

const SHADOW_DOM_TEMPLATE = `
  <sl-form>
    <slot></slot>
  </sl-form>
`

const isOnSafari = () => /Apple Computer/.test(navigator.vendor)

const cloneAttributes = (target, source) =>
  [...source.attributes]
    .filter(({ nodeName }) => !(['id', 'class'].includes(nodeName)))
    .forEach(({ nodeName, nodeValue }) => target.setAttribute(nodeName, nodeValue))

export class SlTurboFormElement extends HTMLElement {
  private readonly form: HTMLFormElement

  static get observedAttributes() {
    return ["action", "method", "enctype"]
  }

  constructor() {
    super()

    // The <sl-form> component needs to be rendered within the shadow DOM so we can safely use the <slot>, which
    // should contain shoelace form controls.
    const shadowRoot = this.attachShadow({ mode: "open" })
    shadowRoot.innerHTML = SHADOW_DOM_TEMPLATE

    // The normal <form> element needs to be rendered within the light DOM so we can emit a custom 'submit' event
    // with appropriate formdata, target, etc.
    this.form = document.createElement("form")
    this.form.style.display = "none"
    cloneAttributes(this.form, this)
    this.appendChild(this.form)
  }

  connectedCallback() {
    this.addEventListener("sl-submit", this.handleSubmit)
    this.addEventListener("formdata", this.handleFormData)
  }

  disconnectedCallback() {
    this.removeEventListener("sl-submit", this.handleSubmit)
    this.removeEventListener("formdata", this.handleFormData)
  }

  handleFormData = (event: FormDataEvent) => {
    const { formData, target } = event

    if (this.form === target) {
      const slForm = this.shadowRoot.querySelector("sl-form") as SlForm

      for (const [key, value] of slForm.getFormData().entries()) {
        formData.append(key, value)
      }
    }
  }

  handleSubmit = (event: CustomEvent) => {
    event.stopImmediatePropagation()
    const submitter = document.activeElement
    const submitEvent = new CustomEvent("submit", { bubbles: true, cancelable: true }) as SubmitEvent
    if (isOnSafari()) {
      Object.defineProperty(submitEvent, "submitter", { get: () => submitter })
    } else {
      submitEvent.submitter = submitter
    }

    const cancelled = this.form.dispatchEvent(submitEvent)
    if (cancelled) {
      if (isOnSafari()) {
        new FormData(this.form)
      }

      this.form.submit()
    }
  }
}
