import { jsbridge } from 'gcjsbridge/src/invoker';
enum TabStatus {

}
enum WindowType {

}
interface TabCreateProperties {
  active?: boolean;
  index?: number;
  openerTabId?: number;
  pinned?: boolean;
  url?: string;
  windowId?: number;
}

interface Tab {
  active?: boolean;
  audible?: boolean;
  autoDiscardable?: boolean;
  discarded?: boolean;
  favIconUrl?: string;
  groupId?: number;
  height?: number;
  highlighted?: boolean;
  id?: number;
  incognito?: boolean; // todo, 不是可选
  index?: number; // todo, 不是可选
  mutedInfo?: object; // todo
  openerTabId?: number;
  pendingUrl?: string;
  pinned?: boolean; // todo, 不是可选
  sessionId?: string;
  status?: TabStatus;
  title?: string;
  url?: string;
  windowId?: number; // todo, 不是可选
  width?: number;
}

interface TabQueryInfo {
  active?: boolean;
  audible?: boolean;
  autoDiscardable?: boolean;
  currentWindow?: boolean;
  discarded?: boolean;
  groupId?: number;
  highlighted?: boolean;
  index?: number;
  lastFocusedWindow?: boolean;
  muted?: boolean;
  pinned?: boolean;
  status?: TabStatus;
  title?: string;
  url?: string | string[];
  windowId?: number;
  windowType?: WindowType;
}
type CreateTabCallback = (tab: Tab) => void;
type QueryTabCallback = (result: Tab[]) => void;

export default class Tabs {
  create(createProperties: TabCreateProperties, callback?: CreateTabCallback) {
    return jsbridge('runtime.tabs.create', createProperties, callback)
  }
  remove(
    tabIds: number | number[],
    callback?: Function,
  ) {
    return jsbridge('runtime.tabs.remove', { tabIds }, callback);
  }
  query(
    queryInfo: TabQueryInfo,
    callback?: QueryTabCallback) {
    return jsbridge('runtime.tabs.query', { queryInfo }, callback);
  }
  // Sends a single message to the content script(s) in the specified tab
  sendMessage(
    tabId: number,
    message: any,
    options?: { frameId: number | undefined },
    callback?: Function,
  ) {
    return jsbridge('runtime.tabs.sendMessage', { tabId, message, options: options ?? {} }, callback);
  }

  get onRemoved() {
    const addListener = function (fn: Function) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_TABS_ONREMOVED', function (result: any) {
        fn(result['tabId'], result['removeInfo'])
      });
    }
    return { addListener }
  }

  get onActivated() {
    const addListener = function (fn: Function) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_TABS_ONACTIVATED', function (result: any) {

      });
    }
    return { addListener }
  }

  get onUpdated() {
    const addListener = function (fn: Function) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_TABS_ONUPDATED', function (result: any) {

      });
    }
    return { addListener }
  }

  __noSuchMethod__(name: any, args: any) {
    console.log(`No such method ${name} called with ${args}`);
    return;
  };
}