import register from 'gcjsbridge/src/register';
import Bookmarks from './bookmarks';
import ContextMenu from './context_menus';
import Runtime from './runtime';
import Storage from './storage';
import Tabs from './tabs';
export default class Chrome {
  __pkg__: any;
  __loader__: any;

  get runtime() {
    return new Runtime();
  }

  get tabs() {
    return new Tabs();
  }

  get bookmarks() {
    return new Bookmarks();
  }

  get contextMenus() {
    return new ContextMenu();
  }

  get storage() {
    return new Storage();
  }
}
register('chrome', new Chrome());
window.chrome = window.gc.bridge.chrome;