interface SlForm extends HTMLElement {
  getFormData: () => FormData
}

interface SlButton extends HTMLElement {
  submit: boolean
}

interface FormDataEvent extends Event {
  formData: FormData
}

interface SubmitEvent extends CustomEvent {
  submitter: Element
}

const submittersByForm: WeakMap<HTMLFormElement, HTMLElement> = new WeakMap()

const cloneAttributes = (target, source) =>
  [...source.attributes]
    .filter(({ nodeName }) => !["id", "class"].includes(nodeName))
    .forEach(({ nodeName, nodeValue }) => target.setAttribute(nodeName, nodeValue))

const findSubmitterFromClickTarget = (target: EventTarget | null): HTMLElement => {
  const element = target instanceof Element ? target : target instanceof Node ? target.parentElement : null

  if (element?.tagName === "SL-BUTTON") {
    const slButton = element as SlButton
    return slButton.submit ? slButton : null
  } else {
    const candidate = element?.closest("input, button") as HTMLInputElement | HTMLFormElement
    return candidate?.type === "submit" ? candidate : null
  }
}

export class SlTurboFormElement extends HTMLElement {
  private readonly form: HTMLFormElement
  private called: boolean

  static template = `
    <sl-form>
      <slot></slot>
    </sl-form>
  `

  static get observedAttributes() {
    return ["action", "method", "enctype", "accept-charset", "data"]
  }

  constructor() {
    super()

    // The <sl-form> component needs to be rendered within the shadow DOM so we can safely use the <slot>, which
    // should contain shoelace form controls.
    const shadowRoot = this.attachShadow({ mode: "open" })
    shadowRoot.innerHTML = SlTurboFormElement.template

    // The normal <form> element needs to be rendered within the light DOM so we can emit a custom 'submit' event
    // with appropriate formdata, target, etc.
    this.form = document.createElement("form")
    this.form.style.display = "none"
    cloneAttributes(this.form, this)
    this.appendChild(this.form)
  }

  connectedCallback() {
    this.addEventListener("click", this.clickCaptured, true)
    this.addEventListener("sl-submit", this.handleSubmit)
    this.addEventListener("formdata", this.handleFormData)
  }

  disconnectedCallback() {
    this.removeEventListener("click", this.clickCaptured, true)
    this.removeEventListener("sl-submit", this.handleSubmit)
    this.removeEventListener("formdata", this.handleFormData)
  }

  handleFormData = (event: FormDataEvent) => {
    const { formData, target } = event

    if (this.form === target && !this.called) {
      this.called = true
      const slForm = this.shadowRoot.querySelector("sl-form") as SlForm

      for (const [key, value] of slForm.getFormData().entries()) {
        formData.append(key, value)
      }
    }
  }

  handleSubmit = (event: CustomEvent) => {
    event.stopImmediatePropagation()
    const submitEvent = new CustomEvent("submit", { bubbles: true, cancelable: true }) as SubmitEvent
    let submitter = document.activeElement

    // The behaviour of the `document.activeElement` is inconsistent so we have to check if the element is the body
    // tag or not. For more retails, see https://zellwk.com/blog/inconsistent-button-behavior/
    if (submitter instanceof HTMLBodyElement) {
      submitter = submittersByForm.get(this.form)
      Object.defineProperty(submitEvent, "submitter", { get: () => submitter })
    } else {
      submitEvent.submitter = submitter
    }

    const cancelled = this.form.dispatchEvent(submitEvent)
    if (cancelled) {
      this.form.submit()
    }
  }

  clickCaptured = (event: Event) => {
    const submitter = findSubmitterFromClickTarget(event.target)

    if (submitter) {
      submittersByForm.set(this.form, submitter)
    }
  }
}
