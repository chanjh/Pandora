import { VoidCallback } from "./define";

export default class PageAction {
  setTitle(
    details: { tabId: number, title: string },
    callback?: VoidCallback,
  ) {

  }

  setIcon(
    details: { iconIndex: number, imageData: any, path: string | any, tabId: number },
    callback?: VoidCallback,
  ) {

  }

  show(
    tabId: number,
    callback?: VoidCallback,
  ) {

  }


  hide(
    tabId: number,
    callback?: VoidCallback,
  ) {

  }

  get onClicked() {
    const addListener = function (fn: Function) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_PAGEACTION_ONCLICKED', fn);
    }
    return { addListener }
  }
}