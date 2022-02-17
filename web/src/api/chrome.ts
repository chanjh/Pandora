import register from 'gcjsbridge/src/register';
import ClassProxy from '../no_such_method';
import Bookmarks from './bookmarks';
import ContextMenu from './context_menus';
import Runtime from './runtime';
import Storage from './storage';
import Tabs from './tabs';
export default class Chrome {
  __pkg__: any;
  __loader__: any;

  get runtime() {
    return ClassProxy(new Runtime());
  }

  get tabs() {
    return ClassProxy(new Tabs());
  }

  get bookmarks() {
    return ClassProxy(new Bookmarks());
  }

  get contextMenus() {
    return ClassProxy(new ContextMenu());
  }

  get storage() {
    return ClassProxy(new Storage());
  }

  __noSuchMethod__(name: any, args: any) {
    console.log(`No such method ${name} called with ${args}`);
    return;
  };
}

register('chrome', ClassProxy(new Chrome()));
window.chrome = window.gc.bridge.chrome;