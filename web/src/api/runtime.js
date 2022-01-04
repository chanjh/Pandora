export default class Runtime {
  getURL(url) {
    // get html from package
    return `chrome-extension://${window.chrome.__pkg__.id}/${url}`
  }

  get onInstalled() {
    const addListener = function (fn) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_RUNTIME_ONINSTALLED', fn);
    }
    return { addListener }
  }
}