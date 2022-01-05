export default function loadBGPackage(pkg) {
  const { type, id, manifest } = pkg;
  if (type !== "BACKGROUND") {
    return;
  }
  window.chrome.__pkg__ = pkg
}