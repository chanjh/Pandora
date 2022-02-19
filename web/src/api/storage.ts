import { jsbridge } from "gcjsbridge/src/invoker";

export default class Storage {
  get local() {
    return new StorageArea('local');
  }
}

class StorageArea {
  api: string;
  constructor(api: string) {
    this.api = api;
  }

  set(items: any, callback?: Function) {
    jsbridge(`storage.${this.api}.set`, items, callback);
  }

  get(
    keys?: string | string[] | object,
    callback?: Function) {
    jsbridge(`storage.${this.api}.get`, { keys }, function (e: any) {
      if (callback) {
        callback(e.result);
      }
    });
  }

  clear(callback?: Function) {
    jsbridge(`storage.${this.api}.clear`, null, callback);
  }

  __noSuchMethod__(name: any, args: any) {
    console.log(`No such method ${name} called with ${args}`);
    return;
  };
}