import { jsbridge } from "@pandola/bridge/src/invoker";

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
    return jsbridge(`storage.${this.api}.set`, items, callback);
  }

  async get(
    keys?: string | string[] | object,
    callback?: Function) {
    return (await jsbridge(`storage.${this.api}.get`, { keys }, function (e: any) {
      if (callback) {
        callback(e.result);
      }
    }))?.result;
  }

  clear(callback?: Function) {
    return jsbridge(`storage.${this.api}.clear`, null, callback);
  }

  __noSuchMethod__(name: any, args: any) {
    console.log(`No such method ${name} called with ${args}`);
    return;
  };
}