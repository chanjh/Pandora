import { jsbridge } from "@pandola/bridge";


interface Cookie {
  domain: string;
  expirationDate?: number;
  hostOnly: boolean;
  name: string;
  path: string;
  // sameSite: "no_restriction" | "lax" | "strict" | "unspecified";
  secure: boolean;
  sesstion: boolean;
  storeId: string;
  value: string;
}

interface CookieDetails {
  name: string;
  storeId?: string;
  url: string;
}

interface CookieDetailsForAll {
  domain?: string;
  name?: string;
  path?: string;
  secure?: string;
  seesion?: boolean;
  storeId?: string;
  url?: string;
}
export default class Cookies {
  get(
    details: CookieDetails,
    callback?: (c?: Cookie) => void,
  ) { return jsbridge('cookies.get', details, callback); }

  getAll(
    details: CookieDetailsForAll,
    callback?: (cookies: Cookie[]) => void,
  ) { return jsbridge('cookies.getAll', details, callback); }
}