import { jsbridge } from 'gcjsbridge/src/invoker';
enum TabStatus {

}
enum WindowType {

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

export default class Tabs {
  async create(url: string) {
    return await jsbridge('runtime.tabs.create', url)
  }
  remove(
    tabIds: number | number[],
    callback?: Function,
  ) {
    jsbridge('runtime.tabs.remove', { tabIds }, callback);
  }
  query(
    queryInfo: TabQueryInfo,
    callback?: Function) {
    jsbridge('runtime.tabs.query', { queryInfo }, callback);
  }
  sendMessage(
    tabId: number,
    message: any,
    options?: { frameId: number | undefined },
    callback?: Function,
  ) {
    jsbridge('runtime.tabs.query', { tabId, message, options }, callback);
  }
}