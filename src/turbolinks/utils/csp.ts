// This code was heavily inspired by the rails-ujs project.
// Copyright (c) 2007-2021 Rails Core team.
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
