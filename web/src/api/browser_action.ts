import { VoidCallback } from "./define";

export default class BrowserAction {
  get onClicked() {
    const addListener = function (fn: Function) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_BROWSERACTION_ONCLICKED', fn);
    }
    return { addListener }
  }
}