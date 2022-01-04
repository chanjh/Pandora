export default function loadBGPackage(pkg) {
  const { type, id } = pkg;
  if (type !== "BACKGROUND") {
    return;
  }
  window.chrome.__pkg__ = {
    type, id
  }
}