import { jsbridge } from "gcjsbridge/src/invoker";
import invoker from "gcjsbridge/src/invoker";
import MessageSender from "./msg_sender";
enum RunAt {

}
interface CSSOrigin {
  author?: string;
  user?: string;
}
interface InjectDetails {
  allFrames?: boolean;
  code?: string;
  cssOrigin?: CSSOrigin;
  file?: string
  frameId?: number
  matchAboutBlank?: boolean
  runAt?: RunAt
}

export default class Runtime {
  // todo: cannot use on content script
  getURL(path?: string) {
    // get html from package
    return `chrome-extension://${window.chrome.__pkg__.id}/${path ?? ''}`
  }

  executeScript(
    tabId?: number,
    details?: InjectDetails,
    callback?: Function,
  ) {
    return jsbridge('runtime.executeScript', { tabId, details }, callback);
  }

  get onInstalled() {
    const addListener = function (fn: Function) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_RUNTIME_ONINSTALLED', fn);
    }
    return { addListener }
  }

  get onMessage() {
    // (message: any, sender: MessageSender, sendResponse: function) => boolean | undefined
    const addListener = function (fn: Function) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_RUNTIME_ONMESSAGE', function () {
        const arg = arguments
        fn(arg?.[0]?.param, new MessageSender(), async function (response: any) {
          const cb = arg?.[0]?.callback
          const extensionId = arg?.[0]?.senderId
          if (cb.length > 0) {
            invoker('runtime.sendResponse', { extensionId, response }, cb)
          }
        })
      });
    }
    return { addListener }
  }

  // todo: async
  // Sends a single message to event listeners within your extension/app or a different extension/app
  sendMessage(
    extensionId: string | undefined,
    message: any,
    options?: object,
    callback?: Function) {
    return jsbridge('runtime.sendMessage', { extensionId, message }, callback);
  }

  getManifest() {
    return window.chrome.__pkg__.manifest;
  }

  async getPlatformInfo(callback?: Function) {
    return jsbridge('runtime.getPlatformInfo', null, callback)
  }

  // todo: create tab
  openOptionsPage(callback?: Function) {
    return jsbridge('runtime.openOptionsPage', undefined, callback)
  }

  // Reloads the app or extension.
  // This method is not supported in kiosk mode. 
  // For kiosk mode, use chrome.runtime.restart() method.
  reload() {

  }
  // Most extensions/apps should not use this method, 
  // since Chrome already does automatic checks every few hours
  requestUpdateCheck(callback?: Function) {

  }
  // Restart the ChromeOS device when the app runs in kiosk mode. 
  // Otherwise, it's no-op.
  restart() {

  }

  restartAfterDelay(seconds: number, callback?: Function) {

  }

  __noSuchMethod__(name: any, args: any) {
    console.log(`No such method ${name} called with ${args}`);
    return;
  };
}