import smoothscroll from 'smoothscroll-polyfill';

const smoothSupported = 'scrollBehavior' in document.documentElement.style;

let smoothPolyfilled;
async function polyfillSmooth() {
  if (smoothPolyfilled) return;
  smoothPolyfilled = true;
  smoothscroll.polyfill();
}

export async function scrollToElement(element, { behavior = 'smooth', block = 'start', inline = 'nearest' } = {}) {
  if (behavior === 'smooth' && !smoothSupported) await polyfillSmooth();
  element.scrollIntoView({ behavior, block, inline });
}
