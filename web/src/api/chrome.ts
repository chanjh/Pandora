import { register } from '@pandola/bridge';
import ClassProxy from '../no_such_method';
import Bookmarks from './bookmarks';
import ContextMenu from './context_menus';
import Extension from './extension';
import Runtime from './runtime';
import Storage from './storage';
import Tabs from './tabs';
import Command from './commands';
import PageAction from './page_action';
import Downloads from './downloads';
import BrowserAction from './browser_action';
import Cookies from './cookies';

export default class Chrome {
  __pkg__: any;
  __loader__: any;

  get runtime() {
    return ClassProxy(new Runtime());
  }

  get tabs() {
    return ClassProxy(new Tabs());
  }

  get browserAction() {
    return ClassProxy(new BrowserAction());
  }

  get bookmarks() {
    return ClassProxy(new Bookmarks());
  }

  get cookies() {
    return ClassProxy(new Cookies());
  }

  get contextMenus() {
    return ClassProxy(new ContextMenu());
  }

  get storage() {
    return ClassProxy(new Storage());
  }

  get extension() {
    return ClassProxy(new Extension());
  }

  get commands() {
    return ClassProxy(new Command());
  }

  get pageAction() {
    return ClassProxy(new PageAction());
  }

  get downloads() {
    return ClassProxy(new Downloads());
  }

  __noSuchMethod__(name: any, args: any) {
    console.log(`No such method ${name} called with ${args}`);
    return;
  };
}

register('chrome', ClassProxy(new Chrome()));
window.chrome = window.gc.bridge.chrome;