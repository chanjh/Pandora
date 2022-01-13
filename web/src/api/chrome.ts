import register from 'gcjsbridge/src/register';
import Bookmarks from './bookmarks';
import Runtime from './runtime';
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
}
register('chrome', new Chrome());
window.chrome = window.gc.bridge.chrome;