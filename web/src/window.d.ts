
import Global from "@pandola/bridge/src/global";
import Chrome from "./api/chrome";

declare global {
  interface Window {
    webkit?: any;
    gc?: Global;
    chrome: Chrome;
  }
}
