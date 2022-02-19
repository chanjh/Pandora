export default function loadBGPackage(pkg: { type: string, id: string, manifest: any }) {
  const { type, id, manifest } = pkg;
  if (type !== "BACKGROUND" && type !== "CONTENT") {
    return;
  }
  window.chrome.__pkg__ = pkg
}