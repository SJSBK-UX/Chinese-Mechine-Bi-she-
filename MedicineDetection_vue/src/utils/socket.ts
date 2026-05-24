import { io } from 'socket.io-client';
import { SOCKET_URL } from '/@/utils/apiConfig';

export class SocketService {
  private socket;
  // 使用 Map 保存事件名称到回调映射（原始回调 -> 包装后的回调）
  private listeners: Map<string, Map<Function, Function>> = new Map();

  constructor() {
    this.socket = io(SOCKET_URL, {
      path: '/socket.io',
      transports: ['polling'],
      timeout: 8000,
      reconnectionAttempts: 3,
    });
  }

  on(event: string, callback: Function) {
    // 如果该事件尚未有绑定记录，先初始化一个 Map
    if (!this.listeners.has(event)) {
      this.listeners.set(event, new Map());
    }
    const eventListeners = this.listeners.get(event)!;
    // 如果回调已经绑定，则直接返回，不重复绑定
    if (eventListeners.has(callback)) {
      return;
    }
    // 包装回调函数，将 data.data 传入原回调
    const wrappedCallback = (data: any) => callback(data.data);
    eventListeners.set(callback, wrappedCallback);
    this.socket.on(event, wrappedCallback);
  }

  // 提供 off 方法，用于解绑事件监听器
  off(event: string, callback: Function) {
    const eventListeners = this.listeners.get(event);
    if (eventListeners && eventListeners.has(callback)) {
      const wrappedCallback = eventListeners.get(callback)!;
      this.socket.off(event, wrappedCallback);
      eventListeners.delete(callback);
    }
  }

  emit(event: string, data: any) {
    this.socket.emit(event, data);
  }

  disconnect() {
    this.socket.disconnect();
    this.listeners.clear();
  }
}
