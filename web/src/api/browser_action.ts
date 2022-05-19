import { jsbridge } from "@pandola/bridge/src/invoker";
import { VoidCallback } from "./define";

export default class BrowserAction {
  get onClicked() {
    const addListener = function (fn: Function) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_BROWSERACTION_ONCLICKED', fn);
    }
    return { addListener }
  }

  setTitle(
    details: {
      tabId: number,
      title: string
    },
    callback?: VoidCallback,
  ) {
    return jsbridge('browserAction.setTitle', details, callback);
  }

  setIcon(
    details: {
      imageData: any,
      path: string | any,
      tabId: number
    },
    callback?: VoidCallback,
  ) {
    return jsbridge('browserAction.setIcon', details, callback);
  }
}