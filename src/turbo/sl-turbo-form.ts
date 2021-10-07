const SHADOW_DOM_TEMPLATE = `
  <sl-form>
    <slot></slot>
  </sl-form>
`

const cloneAttributes = (target, source) =>
  [...source.attributes]
    .filter(({ nodeName }) => nodeName !== "id" || nodeName !== "class")
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

  // @ts-ignore
  handleFormData = (event: FormDataEvent) => {
    const { formData, target } = event

    if (this.form === target) {
      const slForm = this.shadowRoot.querySelector("sl-form")

      // @ts-ignore
      for (const [key, value] of slForm.getFormData().entries()) {
        formData.append(key, value)
      }
    }
  }

  handleSubmit = (event: CustomEvent) => {
    event.stopPropagation()
    this.form.dispatchEvent(new CustomEvent("submit", { bubbles: true }))
  }
}