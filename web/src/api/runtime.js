import { jsbridge } from "gcjsbridge/src/invoker";

export default class Runtime {
  getURL(path) {
    // get html from package
    return `chrome-extension://${window.chrome.__pkg__.id}/${path}`
  }

  get onInstalled() {
    const addListener = function (fn) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_RUNTIME_ONINSTALLED', fn);
    }
    return { addListener }
  }

  getManifest() {
    return window.chrome.__pkg__.manifest;
  }

  async getPlatformInfo(callback) {
    const info = await jsbridge('runtime.getPlatformInfo')
    if (callback) {
      callback(info)
    }
    return info
  }

  // todo: create tab
  openOptionsPage(callback) {
    const manifest = this.getManifest()
    const ui = manifest.options_ui
    if (ui) {

      return
    }

    const page = manifest.options_page;
    if (page) {

      return
    }
  }

  // Reloads the app or extension.
  // This method is not supported in kiosk mode. 
  // For kiosk mode, use chrome.runtime.restart() method.
  reload() {

  }
  // Most extensions/apps should not use this method, 
  // since Chrome already does automatic checks every few hours
  requestUpdateCheck(callback) {

  }
  // Restart the ChromeOS device when the app runs in kiosk mode. 
  // Otherwise, it's no-op.
  restart() {

  }

  restartAfterDelay(seconds, callback) {

  }

  sendMessage(extensionId,
    message,
    options,
    callback) {

  }
}