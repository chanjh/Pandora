export default function ClassProxy(obj: any) {
  return new Proxy(obj, {
    get(target, p: any) {
      if (p in target) {
        return target[p];
      } else if (typeof p == "function") {
        if (typeof target.__noSuchMethod__ == "function") {
          return function (...args: any[]) {
            return target.__noSuchMethod__.call(target, p, args);
          };
        }
      } else {
        console.log(`No property named ${p}`);
      }
    }
  });
}