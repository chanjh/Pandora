import register from 'gcjsbridge/src/register';
import Bookmarks from './bookmarks';
import Runtime from './runtime';
import Tabs from './tabs';
export default class Chrome {
  get runtime() {
    return new Runtime();
  }

  get tabs() {
    return new Tabs();
  }

  get bookmarks() {
    return new Bookmarks();
  }
}
register('chrome', new Chrome());
window.chrome = window.gc.bridge.chrome;