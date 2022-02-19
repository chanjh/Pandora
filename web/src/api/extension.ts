export default class Extension {
  // todo: cannot use on content script
  getURL(path?: string) {
    // get html from package
    return `chrome-extension://${window.chrome.__pkg__.id}/${path ?? ''}`
  }
}