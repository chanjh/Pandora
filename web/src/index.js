import launcher from "gcjsbridge/src/launcher";
launcher();

require("./api/chrome");

import loadPackage from "./loader/loader";
window.chrome.__loader__ = loadPackage
console.log("dddd")