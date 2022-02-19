export default class Command {
  get onCommand() {
    const addListener = function (fn: Function) {
      window.gc.bridge.eventCenter.subscribe('PD_EVENT_COMMAND_ONCOMMAND', fn);
    }
    return { addListener }
  }
}