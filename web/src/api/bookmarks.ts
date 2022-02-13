import { jsbridge } from "gcjsbridge/src/invoker";

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
    jsbridge('bookmarks.create', { bookmark }, callback)
  }

  remove(
    id: string,
    callback?: Function) {
    jsbridge('bookmarks.remove', { id }, callback)
  }

  update(
    id: string,
    changes: { title?: string, url?: string },
    callback?: Function) {
    jsbridge('bookmarks.update', { id, changes }, callback)
  }

  getTree(callback?: Function) {
    jsbridge('bookmarks.getTree', null, callback)
  }
}