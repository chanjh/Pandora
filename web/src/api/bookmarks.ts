import { jsbridge } from "@pandola/bridge";

interface CreateDetails {
  index?: number;
  parentId?: string;
  title?: string;
  url?: string;
}
export default class Bookmarks {
  create(
    bookmark: CreateDetails,
    callback?: Function) {
    return jsbridge('bookmarks.create', { bookmark }, callback)
  }

  remove(
    id: string,
    callback?: Function) {
    return jsbridge('bookmarks.remove', { id }, callback)
  }

  update(
    id: string,
    changes: { title?: string, url?: string },
    callback?: Function) {
    return jsbridge('bookmarks.update', { id, changes }, callback)
  }

  getTree(callback?: Function) {
    return jsbridge('bookmarks.getTree', null, callback)
  }

  __noSuchMethod__(name: any, args: any) {
    console.log(`No such method ${name} called with ${args}`);
    return;
  };
}