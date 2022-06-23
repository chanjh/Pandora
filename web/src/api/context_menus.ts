// - onClicked.addListener
// - create
// - removeAll
// - Remove
// - update

import { jsbridge, wrapCallback } from "@pandola/bridge"

type ContextType = "all" | "page" | "frame" | "selection" | "link" | "editable" | "image" |
  "video" | "audio" | "launcher" | "browser_action" | "page_action" | "action"

type ItemType = "normal" | "checkbox" | "radio" | "separator";

interface MenuItem {
  checked?: boolean;
  contexts?: ContextType[];
  documentUrlPatterns?: string[];
  enabled?: boolean;
  id?: string;
  parentId?: string | number;
  targetUrlPatterns?: string[];
  title?: string[];
  type?: ItemType;
  visible?: boolean;
  onclick?: Function;
  onclickCallback?: string;
}

export default class ContextMenu {
  create(
    createProperties: MenuItem,
    callback?: Function,
  ) {
    // make onclick callback
    if (!createProperties.id) {
      // todo
      createProperties.id = ""
    }
    if (onclick) {
      wrapCallback(createProperties.id ?? "",
        (callbackName: string) => {
          createProperties.onclickCallback = callbackName;
          return jsbridge('util.contextMenu.set', createProperties, callback);
        },
        callback
      );
    } else {
      return jsbridge('util.contextMenu.set', createProperties, callback)
    }
  }

  remove(
    menuItemId: string | number,
    callback?: Function,
  ) {
    return jsbridge('contextMenus.remove', { menuItemId }, callback)
  }

  removeAll(
    callback?: Function
  ) {
    return jsbridge('contextMenus.removeAll', null, callback)
  }

  update(
    id: string | number,
    updateProperties: MenuItem,
    callback?: Function,
  ) {
    return jsbridge('contextMenus.update', { id, updateProperties }, callback)
  }

  get onClicked() {
    const addListener = function (fn: Function) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_CONTEXTMENU_ONCLICKED', fn);
    }
    return { addListener }
  }

  __noSuchMethod__(name: any, args: any) {
    console.log(`No such method ${name} called with ${args}`);
    return;
  };
}