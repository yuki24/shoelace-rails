let nonce = null

const loadCSPNonce = () => {
  if (nonce) {
    return nonce
  }

  const cspMetaTag: HTMLMetaElement = document.querySelector("meta[name=csp-nonce]")

  if (cspMetaTag) {
    nonce = cspMetaTag.content
  }

  return nonce
}

// Returns the Content-Security-Policy nonce for inline scripts.
export const cspNonce = () => (nonce != null ? nonce : loadCSPNonce())
