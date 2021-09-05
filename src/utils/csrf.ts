const $ = (selector) => Array.prototype.slice.call(document.querySelectorAll(selector))

// Up-to-date Cross-Site Request Forgery token
export const csrfToken = () => {
  const meta: HTMLMetaElement = document.querySelector("meta[name=csrf-token]")
  return meta && meta.content
}

// URL param that must contain the CSRF token
export const csrfParam = () => {
  const meta: HTMLMetaElement = document.querySelector("meta[name=csrf-param]")
  return meta && meta.content
}

// Make sure that every Ajax request sends the CSRF token
export const CSRFProtection = (xhr) => {
  const token = csrfToken()
  if (token != null) {
    return xhr.setRequestHeader("X-CSRF-Token", token)
  }
}

// Make sure that all forms have actual up-to-date tokens (cached forms contain old ones)
export const refreshCSRFTokens = () => {
  const token = csrfToken()
  const param = csrfParam()

  if (token != null && param != null) {
    return $('form input[name="' + param + '"]').forEach((input) => (input.value = token))
  }
}
