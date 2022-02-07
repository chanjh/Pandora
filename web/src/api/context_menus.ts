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
    jsbridge('contextMenus.create', { createProperties }, callback)
  }

  remove(
    menuItemId: string | number,
    callback?: Function,
  ) {
    jsbridge('contextMenus.remove', { menuItemId }, callback)
  }

  removeAll(
    callback?: Function
  ) {
    jsbridge('contextMenus.removeAll', null, callback)
  }

  update(
    id: string | number,
    updateProperties: MenuItem,
    callback?: Function,
  ) {
    jsbridge('contextMenus.update', { id, updateProperties }, callback)
  }
}