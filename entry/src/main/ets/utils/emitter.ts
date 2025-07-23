type ICallback = (...args: any[]) => void

class Emitter {
  private callbacks = {}

  on(eventName: string, cb: ICallback) {
    if (!this.callbacks[eventName]) {
      this.callbacks[eventName] = []
    }
    this.callbacks[eventName].push(cb)
  }

  once(eventName: string, cb: ICallback) {
    const callback = (...args) => {
      cb(...args)
      this.off(eventName, callback);
    }
    this.on(eventName, callback);
  }

  emit(eventName: string, ...args: any[]) {
    // 修复：事件不存在时不抛出错误，而是静默处理
    if (!this.callbacks[eventName]) {
      console.warn(`Event "${eventName}" is not registered.`);
      return;
    }

    this.callbacks[eventName].forEach(cb => cb(...args))
  }

  off(eventName?: string, cb?: ICallback) {
    if (!eventName) {
      this.callbacks = {};
      return;
    }

    if (!this.callbacks[eventName]) {
      console.warn(`Event "${eventName}" is not registered.`);
      return;
    }

    if (!cb) {
      delete this.callbacks[eventName]
      return;
    }

    this.callbacks[eventName] = this.callbacks[eventName].filter(callback => cb !== callback)
  }
}

export default Emitter;

export const globalEmitter = new Emitter();