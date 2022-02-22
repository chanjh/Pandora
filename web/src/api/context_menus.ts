// - onClicked.addListener
// - create
// - removeAll
// - Remove
// - update

import { jsbridge } from "gcjsbridge/src/invoker"

enum ContextType {

}

enum ItemType {

}

interface MenuItem {
  checked: boolean;
  contexts: ContextType[];
  documentUrlPatterns: string[];
  enabled: boolean;
  id: string;
  parentId: string | number;
  targetUrlPatterns: string[];
  title: string[];
  type: ItemType;
  visible: boolean;
  onclick: Function;
}

export default class ContextMenu {
  create(
    createProperties: MenuItem,
    callback?: Function,
  ) {
    return jsbridge('contextMenus.create', { createProperties }, callback)
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