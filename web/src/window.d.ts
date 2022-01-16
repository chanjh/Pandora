
import Global from "gcjsbridge/src/global";
import Chrome from "./api/chrome";

declare global {
  interface Window {
    webkit?: any;
    gc?: Global;
    chrome: Chrome;
  }
}
