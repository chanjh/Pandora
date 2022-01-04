import loadBGPackage from "./background_loader";

// type 
// BACKGROUND
// BROWSER_ACTION
// PAGE_ACTION
export default function loadPackage(pkg) {
  const { type } = pkg;
  if (type === "BACKGROUND") {
    loadBGPackage(pkg);
  }
}
