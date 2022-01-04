import { jsbridge } from 'gcjsbridge/src/invoker';
export default class Tabs {
  async create(url) {
    return await jsbridge('runtime.tabs.create', url)
  }
}