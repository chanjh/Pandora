import { jsbridge } from "@pandola/bridge";

export default class Downloads {
  async download(options: DownloadOptions,
    callback?: DownloadCallback) {
    const api = 'downloads.download'
    if (options.url.startsWith("blob:")) {
      const base64 = await blob2Base64(options.url);
      const arg = Object.assign(options, { base64 });
      return jsbridge(api, arg, callback);
    }
    return jsbridge(api, options, callback);
  }
}

export interface DownloadOptions {
  body?: string
  conflictAction?: any
  filename?: string
  headers?: any
  method?: any
  saveAs?: boolean
  url: string
}

async function blob2Base64(blobUrl: string) {
  return new Promise(function (resolve, reject) {
    // const blobUrl = URL.createObjectURL(blob);
    var xhr = new XMLHttpRequest;
    xhr.responseType = 'blob';
    xhr.onload = function () {
      var recoveredBlob = xhr.response;
      var reader = new FileReader;
      reader.onload = function () {
        var blobAsDataUrl = reader.result;
        resolve(blobAsDataUrl);
      };
      reader.readAsDataURL(recoveredBlob);
    };

    xhr.open('GET', blobUrl);
    xhr.send();
  });
}

export type DownloadCallback = (downloadId: number) => void;