/*! For license information please see pandora.js.LICENSE.txt */
(()=>{"use strict";var __webpack_modules__={"../../GCWebContainerDemo/web/src/bridge.ts":(__unused_webpack_module,exports)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nclass Bridge {\n    constructor() { }\n}\nexports["default"] = Bridge;\n\n\n//# sourceURL=webpack://@pandola/pandora/../../GCWebContainerDemo/web/src/bridge.ts?')},"../../GCWebContainerDemo/web/src/callback_wrapper.ts":function(__unused_webpack_module,exports,__webpack_require__){eval('\nvar __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {\n    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }\n    return new (P || (P = Promise))(function (resolve, reject) {\n        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }\n        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }\n        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }\n        step((generator = generator.apply(thisArg, _arguments || [])).next());\n    });\n};\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nconst lock_1 = __webpack_require__(/*! ./lock */ "../../GCWebContainerDemo/web/src/lock.ts");\nfunction wrapCallback(uid, fn, callback) {\n    return __awaiter(this, void 0, void 0, function* () {\n        let callbackFunc = function () {\n            const max = 9999;\n            const min = 0;\n            const random = parseInt(`${Math.random() * (max - min + 1) + min}`, 10);\n            const { global } = window.gc._config;\n            return `${global}_${uid.replaceAll(".", "")}_callback_func_${random}`;\n        };\n        function _initCallback(callbackName) {\n            window[callbackName] = function (...arg) {\n                const { global } = window.gc._config;\n                if (callback) {\n                    callback(arg[0]);\n                }\n                lock.unlock(arg[0]);\n                console.log(\'delete callback:\', callbackName);\n                delete window[callbackName];\n            };\n        }\n        let lock = new lock_1.default();\n        const callbackName = callbackFunc();\n        console.log(callbackName, uid);\n        _initCallback(callbackName);\n        lock.lock();\n        fn(callbackName);\n        return yield lock.status;\n    });\n}\nexports["default"] = wrapCallback;\n\n\n//# sourceURL=webpack://@pandola/pandora/../../GCWebContainerDemo/web/src/callback_wrapper.ts?')},"../../GCWebContainerDemo/web/src/config.default.ts":(__unused_webpack_module,exports)=>{eval("\nObject.defineProperty(exports, \"__esModule\", ({ value: true }));\nconst config = {\n    bridgeName: 'invoke',\n    global: 'gc',\n    services: {\n        util: {\n            contextMenu: ['clear'],\n            test: ['testMethod']\n        },\n        runtime: {\n            system: {\n                lifecyle: {\n                    app: ['willopen']\n                }\n            },\n            test: ['testMethod']\n        }\n    }\n};\nexports[\"default\"] = config;\n\n\n//# sourceURL=webpack://@pandola/pandora/../../GCWebContainerDemo/web/src/config.default.ts?")},"../../GCWebContainerDemo/web/src/event_center.ts":(__unused_webpack_module,exports,__webpack_require__)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nconst register_1 = __webpack_require__(/*! ./register */ "../../GCWebContainerDemo/web/src/register.ts");\nclass EventCenter {\n    constructor() {\n        this.listeners = {};\n    }\n    subscribe(event, fn) {\n        const { listeners } = this;\n        let listenersForEvent = listeners[event];\n        if (!listenersForEvent) {\n            listenersForEvent = [];\n        }\n        listenersForEvent.push(fn);\n        listeners[event] = listenersForEvent;\n    }\n    publish(event, ...params) {\n        const { listeners } = this;\n        const listenersForEvent = listeners[event];\n        if (listenersForEvent) {\n            for (const listener of listenersForEvent) {\n                listener(...params);\n            }\n        }\n    }\n}\nexports["default"] = EventCenter;\n(0, register_1.default)(\'eventCenter\', new EventCenter());\n\n\n//# sourceURL=webpack://@pandola/pandora/../../GCWebContainerDemo/web/src/event_center.ts?')},"../../GCWebContainerDemo/web/src/global.ts":(__unused_webpack_module,exports)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nclass Global {\n    constructor() { }\n}\nexports["default"] = Global;\n\n\n//# sourceURL=webpack://@pandola/pandora/../../GCWebContainerDemo/web/src/global.ts?')},"../../GCWebContainerDemo/web/src/invoker.ts":function(__unused_webpack_module,exports,__webpack_require__){eval('\nvar __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {\n    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }\n    return new (P || (P = Promise))(function (resolve, reject) {\n        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }\n        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }\n        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }\n        step((generator = generator.apply(thisArg, _arguments || [])).next());\n    });\n};\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nexports.jsbridge = void 0;\nconst callback_wrapper_1 = __webpack_require__(/*! ./callback_wrapper */ "../../GCWebContainerDemo/web/src/callback_wrapper.ts");\nfunction invoker(action, params, callback) {\n    return __awaiter(this, void 0, void 0, function* () {\n        let arg = params;\n        if (!params) {\n            arg = {};\n        }\n        var message = {\n            action: action,\n            params: arg,\n            callback: callback,\n        };\n        const { bridgeName } = window.gc._config;\n        yield window.webkit.messageHandlers[bridgeName].postMessage(message);\n    });\n}\nexports["default"] = invoker;\nfunction jsbridge(action, params, callback) {\n    return __awaiter(this, void 0, void 0, function* () {\n        return yield (0, callback_wrapper_1.default)(action, (callbackName) => invoker(action, params, callbackName), callback);\n    });\n}\nexports.jsbridge = jsbridge;\n\n\n//# sourceURL=webpack://@pandola/pandora/../../GCWebContainerDemo/web/src/invoker.ts?')},"../../GCWebContainerDemo/web/src/launcher.ts":(__unused_webpack_module,exports,__webpack_require__)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nconst global_1 = __webpack_require__(/*! ./global */ "../../GCWebContainerDemo/web/src/global.ts");\nconst bridge_1 = __webpack_require__(/*! ./bridge */ "../../GCWebContainerDemo/web/src/bridge.ts");\nconst defaultConfig = __webpack_require__(/*! ./config.default */ "../../GCWebContainerDemo/web/src/config.default.ts");\nfunction launcher(config) {\n    let finalConfig = config;\n    if (!config) {\n        finalConfig = defaultConfig.default;\n    }\n    const { global } = finalConfig;\n    window[`${global}`] = new global_1.default();\n    window[`${global}`].bridge = new bridge_1.default();\n    window.gc._config = finalConfig;\n    __webpack_require__(/*! ./event_center */ "../../GCWebContainerDemo/web/src/event_center.ts");\n}\nexports["default"] = launcher;\n\n\n//# sourceURL=webpack://@pandola/pandora/../../GCWebContainerDemo/web/src/launcher.ts?')},"../../GCWebContainerDemo/web/src/lock.ts":(__unused_webpack_module,exports)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nclass Lock {\n    constructor() {\n        this.status = new Promise((resolve) => { resolve(true); });\n    }\n    lock() {\n        this.status = new Promise((resolve) => { this.callback = resolve; });\n    }\n    unlock(result) {\n        this.callback(result);\n    }\n}\nexports["default"] = Lock;\n\n\n//# sourceURL=webpack://@pandola/pandora/../../GCWebContainerDemo/web/src/lock.ts?')},"../../GCWebContainerDemo/web/src/register.ts":(__unused_webpack_module,exports)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nfunction register(name, fn) {\n    const { global } = window.gc._config;\n    const host = window[global].bridge;\n    host[name] = fn;\n}\nexports["default"] = register;\n\n\n//# sourceURL=webpack://@pandola/pandora/../../GCWebContainerDemo/web/src/register.ts?')},"./src/api/bookmarks.ts":(__unused_webpack_module,exports,__webpack_require__)=>{eval("\nObject.defineProperty(exports, \"__esModule\", ({ value: true }));\nconst invoker_1 = __webpack_require__(/*! @pandola/bridge/src/invoker */ \"../../GCWebContainerDemo/web/src/invoker.ts\");\nclass Bookmarks {\n    create(bookmark, callback) {\n        return (0, invoker_1.jsbridge)('bookmarks.create', { bookmark }, callback);\n    }\n    remove(id, callback) {\n        return (0, invoker_1.jsbridge)('bookmarks.remove', { id }, callback);\n    }\n    update(id, changes, callback) {\n        return (0, invoker_1.jsbridge)('bookmarks.update', { id, changes }, callback);\n    }\n    getTree(callback) {\n        return (0, invoker_1.jsbridge)('bookmarks.getTree', null, callback);\n    }\n    __noSuchMethod__(name, args) {\n        console.log(`No such method ${name} called with ${args}`);\n        return;\n    }\n    ;\n}\nexports[\"default\"] = Bookmarks;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/bookmarks.ts?")},"./src/api/browser_action.ts":(__unused_webpack_module,exports,__webpack_require__)=>{eval("\nObject.defineProperty(exports, \"__esModule\", ({ value: true }));\nconst invoker_1 = __webpack_require__(/*! @pandola/bridge/src/invoker */ \"../../GCWebContainerDemo/web/src/invoker.ts\");\nclass BrowserAction {\n    get onClicked() {\n        const addListener = function (fn) {\n            window.gc.bridge.eventCenter.subscribe('PD_EVENT_BROWSERACTION_ONCLICKED', fn);\n        };\n        return { addListener };\n    }\n    setTitle(details, callback) {\n        return (0, invoker_1.jsbridge)('browserAction.setTitle', details, callback);\n    }\n    setIcon(details, callback) {\n        return (0, invoker_1.jsbridge)('browserAction.setIcon', details, callback);\n    }\n}\nexports[\"default\"] = BrowserAction;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/browser_action.ts?")},"./src/api/chrome.ts":(__unused_webpack_module,exports,__webpack_require__)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nconst register_1 = __webpack_require__(/*! @pandola/bridge/src/register */ "../../GCWebContainerDemo/web/src/register.ts");\nconst no_such_method_1 = __webpack_require__(/*! ../no_such_method */ "./src/no_such_method.ts");\nconst bookmarks_1 = __webpack_require__(/*! ./bookmarks */ "./src/api/bookmarks.ts");\nconst context_menus_1 = __webpack_require__(/*! ./context_menus */ "./src/api/context_menus.ts");\nconst extension_1 = __webpack_require__(/*! ./extension */ "./src/api/extension.ts");\nconst runtime_1 = __webpack_require__(/*! ./runtime */ "./src/api/runtime.ts");\nconst storage_1 = __webpack_require__(/*! ./storage */ "./src/api/storage.ts");\nconst tabs_1 = __webpack_require__(/*! ./tabs */ "./src/api/tabs.ts");\nconst commands_1 = __webpack_require__(/*! ./commands */ "./src/api/commands.ts");\nconst page_action_1 = __webpack_require__(/*! ./page_action */ "./src/api/page_action.ts");\nconst downloads_1 = __webpack_require__(/*! ./downloads */ "./src/api/downloads.ts");\nconst browser_action_1 = __webpack_require__(/*! ./browser_action */ "./src/api/browser_action.ts");\nconst cookies_1 = __webpack_require__(/*! ./cookies */ "./src/api/cookies.ts");\nclass Chrome {\n    get runtime() {\n        return (0, no_such_method_1.default)(new runtime_1.default());\n    }\n    get tabs() {\n        return (0, no_such_method_1.default)(new tabs_1.default());\n    }\n    get browserAction() {\n        return (0, no_such_method_1.default)(new browser_action_1.default());\n    }\n    get bookmarks() {\n        return (0, no_such_method_1.default)(new bookmarks_1.default());\n    }\n    get cookies() {\n        return (0, no_such_method_1.default)(new cookies_1.default());\n    }\n    get contextMenus() {\n        return (0, no_such_method_1.default)(new context_menus_1.default());\n    }\n    get storage() {\n        return (0, no_such_method_1.default)(new storage_1.default());\n    }\n    get extension() {\n        return (0, no_such_method_1.default)(new extension_1.default());\n    }\n    get commands() {\n        return (0, no_such_method_1.default)(new commands_1.default());\n    }\n    get pageAction() {\n        return (0, no_such_method_1.default)(new page_action_1.default());\n    }\n    get downloads() {\n        return (0, no_such_method_1.default)(new downloads_1.default());\n    }\n    __noSuchMethod__(name, args) {\n        console.log(`No such method ${name} called with ${args}`);\n        return;\n    }\n    ;\n}\nexports["default"] = Chrome;\n(0, register_1.default)(\'chrome\', (0, no_such_method_1.default)(new Chrome()));\nwindow.chrome = window.gc.bridge.chrome;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/chrome.ts?')},"./src/api/commands.ts":(__unused_webpack_module,exports)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nclass Command {\n    get onCommand() {\n        const addListener = function (fn) {\n            window.gc.bridge.eventCenter.subscribe(\'PD_EVENT_COMMAND_ONCOMMAND\', fn);\n        };\n        return { addListener };\n    }\n}\nexports["default"] = Command;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/commands.ts?')},"./src/api/context_menus.ts":(__unused_webpack_module,exports,__webpack_require__)=>{eval("\nObject.defineProperty(exports, \"__esModule\", ({ value: true }));\nconst callback_wrapper_1 = __webpack_require__(/*! @pandola/bridge/src/callback_wrapper */ \"../../GCWebContainerDemo/web/src/callback_wrapper.ts\");\nconst invoker_1 = __webpack_require__(/*! @pandola/bridge/src/invoker */ \"../../GCWebContainerDemo/web/src/invoker.ts\");\nclass ContextMenu {\n    create(createProperties, callback) {\n        var _a;\n        if (!createProperties.id) {\n            createProperties.id = \"\";\n        }\n        if (onclick) {\n            (0, callback_wrapper_1.default)((_a = createProperties.id) !== null && _a !== void 0 ? _a : \"\", (callbackName) => {\n                createProperties.onclickCallback = callbackName;\n                return (0, invoker_1.jsbridge)('util.contextMenu.set', createProperties, callback);\n            }, callback);\n        }\n        else {\n            return (0, invoker_1.jsbridge)('util.contextMenu.set', createProperties, callback);\n        }\n    }\n    remove(menuItemId, callback) {\n        return (0, invoker_1.jsbridge)('contextMenus.remove', { menuItemId }, callback);\n    }\n    removeAll(callback) {\n        return (0, invoker_1.jsbridge)('contextMenus.removeAll', null, callback);\n    }\n    update(id, updateProperties, callback) {\n        return (0, invoker_1.jsbridge)('contextMenus.update', { id, updateProperties }, callback);\n    }\n    get onClicked() {\n        const addListener = function (fn) {\n            window.gc.bridge.eventCenter.subscribe('PD_EVENT_CONTEXTMENU_ONCLICKED', fn);\n        };\n        return { addListener };\n    }\n    __noSuchMethod__(name, args) {\n        console.log(`No such method ${name} called with ${args}`);\n        return;\n    }\n    ;\n}\nexports[\"default\"] = ContextMenu;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/context_menus.ts?")},"./src/api/cookies.ts":(__unused_webpack_module,exports,__webpack_require__)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nconst invoker_1 = __webpack_require__(/*! @pandola/bridge/src/invoker */ "../../GCWebContainerDemo/web/src/invoker.ts");\nclass Cookies {\n    get(details, callback) { return (0, invoker_1.jsbridge)(\'cookies.get\', details, callback); }\n    getAll(details, callback) { return (0, invoker_1.jsbridge)(\'cookies.getAll\', details, callback); }\n}\nexports["default"] = Cookies;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/cookies.ts?')},"./src/api/downloads.ts":function(__unused_webpack_module,exports,__webpack_require__){eval('\nvar __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {\n    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }\n    return new (P || (P = Promise))(function (resolve, reject) {\n        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }\n        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }\n        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }\n        step((generator = generator.apply(thisArg, _arguments || [])).next());\n    });\n};\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nconst invoker_1 = __webpack_require__(/*! @pandola/bridge/src/invoker */ "../../GCWebContainerDemo/web/src/invoker.ts");\nclass Downloads {\n    download(options, callback) {\n        return __awaiter(this, void 0, void 0, function* () {\n            const api = \'downloads.download\';\n            if (options.url.startsWith("blob:")) {\n                const base64 = yield blob2Base64(options.url);\n                const arg = Object.assign(options, { base64 });\n                return (0, invoker_1.jsbridge)(api, arg, callback);\n            }\n            return (0, invoker_1.jsbridge)(api, options, callback);\n        });\n    }\n}\nexports["default"] = Downloads;\nfunction blob2Base64(blobUrl) {\n    return __awaiter(this, void 0, void 0, function* () {\n        return new Promise(function (resolve, reject) {\n            var xhr = new XMLHttpRequest;\n            xhr.responseType = \'blob\';\n            xhr.onload = function () {\n                var recoveredBlob = xhr.response;\n                var reader = new FileReader;\n                reader.onload = function () {\n                    var blobAsDataUrl = reader.result;\n                    resolve(blobAsDataUrl);\n                };\n                reader.readAsDataURL(recoveredBlob);\n            };\n            xhr.open(\'GET\', blobUrl);\n            xhr.send();\n        });\n    });\n}\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/downloads.ts?')},"./src/api/extension.ts":(__unused_webpack_module,exports)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nclass Extension {\n    getURL(path) {\n        return `chrome-extension://${window.chrome.__pkg__.id}/${path !== null && path !== void 0 ? path : \'\'}`;\n    }\n}\nexports["default"] = Extension;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/extension.ts?')},"./src/api/msg_sender.ts":(__unused_webpack_module,exports)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nclass MessageSender {\n}\nexports["default"] = MessageSender;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/msg_sender.ts?')},"./src/api/page_action.ts":(__unused_webpack_module,exports)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nclass PageAction {\n    setTitle(details, callback) {\n    }\n    setIcon(details, callback) {\n    }\n    show(tabId, callback) {\n    }\n    hide(tabId, callback) {\n    }\n    get onClicked() {\n        const addListener = function (fn) {\n            window.gc.bridge.eventCenter.subscribe(\'PD_EVENT_PAGEACTION_ONCLICKED\', fn);\n        };\n        return { addListener };\n    }\n}\nexports["default"] = PageAction;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/page_action.ts?')},"./src/api/runtime.ts":function(__unused_webpack_module,exports,__webpack_require__){eval("\nvar __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {\n    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }\n    return new (P || (P = Promise))(function (resolve, reject) {\n        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }\n        function rejected(value) { try { step(generator[\"throw\"](value)); } catch (e) { reject(e); } }\n        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }\n        step((generator = generator.apply(thisArg, _arguments || [])).next());\n    });\n};\nObject.defineProperty(exports, \"__esModule\", ({ value: true }));\nconst invoker_1 = __webpack_require__(/*! @pandola/bridge/src/invoker */ \"../../GCWebContainerDemo/web/src/invoker.ts\");\nconst invoker_2 = __webpack_require__(/*! @pandola/bridge/src/invoker */ \"../../GCWebContainerDemo/web/src/invoker.ts\");\nconst msg_sender_1 = __webpack_require__(/*! ./msg_sender */ \"./src/api/msg_sender.ts\");\nvar RunAt;\n(function (RunAt) {\n})(RunAt || (RunAt = {}));\nclass Runtime {\n    constructor() {\n        this._sendMessageV3 = function (extensionId, message, options, callback) {\n            return (0, invoker_1.jsbridge)('runtime.sendMessage', { extensionId, message }, callback);\n        };\n        this._sendMessageV2 = function (message, callback) {\n            return (0, invoker_1.jsbridge)('runtime.sendMessage', message, callback);\n        };\n    }\n    get id() {\n        return window.chrome.__pkg__.id;\n    }\n    getURL(path) {\n        return `chrome-extension://${window.chrome.__pkg__.id}/${path !== null && path !== void 0 ? path : ''}`;\n    }\n    executeScript(tabId, details, callback) {\n        return (0, invoker_1.jsbridge)('runtime.executeScript', { tabId, details }, callback);\n    }\n    get onInstalled() {\n        const addListener = function (fn) {\n            window.gc.bridge.eventCenter.subscribe('PD_EVENT_RUNTIME_ONINSTALLED', fn);\n        };\n        return { addListener };\n    }\n    get onMessage() {\n        const addListener = function (fn) {\n            window.gc.bridge.eventCenter.subscribe('PD_EVENT_RUNTIME_ONMESSAGE', function () {\n                var _a;\n                const arg = arguments;\n                fn((_a = arg === null || arg === void 0 ? void 0 : arg[0]) === null || _a === void 0 ? void 0 : _a.param, new msg_sender_1.default(), function (response) {\n                    var _a, _b;\n                    return __awaiter(this, void 0, void 0, function* () {\n                        const cb = (_a = arg === null || arg === void 0 ? void 0 : arg[0]) === null || _a === void 0 ? void 0 : _a.callback;\n                        const extensionId = (_b = arg === null || arg === void 0 ? void 0 : arg[0]) === null || _b === void 0 ? void 0 : _b.senderId;\n                        if (cb.length > 0) {\n                            (0, invoker_2.default)('runtime.sendResponse', { extensionId, response }, cb);\n                        }\n                    });\n                });\n            });\n        };\n        return { addListener };\n    }\n    sendMessage() {\n        let version = this.getManifest().manifest_version;\n        if (version == 3) {\n            return this._sendMessageV3.apply(this, arguments);\n        }\n        else {\n            return this._sendMessageV2.apply(this, arguments);\n        }\n    }\n    getManifest() {\n        return window.chrome.__pkg__.manifest;\n    }\n    getPlatformInfo(callback) {\n        return __awaiter(this, void 0, void 0, function* () {\n            return (0, invoker_1.jsbridge)('runtime.getPlatformInfo', null, callback);\n        });\n    }\n    openOptionsPage(callback) {\n        return (0, invoker_1.jsbridge)('runtime.openOptionsPage', undefined, callback);\n    }\n    reload() {\n    }\n    requestUpdateCheck(callback) {\n    }\n    restart() {\n    }\n    restartAfterDelay(seconds, callback) {\n    }\n    __noSuchMethod__(name, args) {\n        console.log(`No such method ${name} called with ${args}`);\n        return;\n    }\n    ;\n}\nexports[\"default\"] = Runtime;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/runtime.ts?")},"./src/api/storage.ts":function(__unused_webpack_module,exports,__webpack_require__){eval('\nvar __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {\n    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }\n    return new (P || (P = Promise))(function (resolve, reject) {\n        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }\n        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }\n        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }\n        step((generator = generator.apply(thisArg, _arguments || [])).next());\n    });\n};\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nconst invoker_1 = __webpack_require__(/*! @pandola/bridge/src/invoker */ "../../GCWebContainerDemo/web/src/invoker.ts");\nclass Storage {\n    get local() {\n        return new StorageArea(\'local\');\n    }\n    get sync() {\n        return new StorageArea(\'sync\');\n    }\n}\nexports["default"] = Storage;\nclass StorageArea {\n    constructor(api) {\n        this.api = api;\n    }\n    set(items, callback) {\n        return (0, invoker_1.jsbridge)(`storage.${this.api}.set`, items, callback);\n    }\n    get(keys, callback) {\n        var _a;\n        return __awaiter(this, void 0, void 0, function* () {\n            return (_a = (yield (0, invoker_1.jsbridge)(`storage.${this.api}.get`, { keys }, function (e) {\n                if (callback) {\n                    callback(e.result);\n                }\n            }))) === null || _a === void 0 ? void 0 : _a.result;\n        });\n    }\n    clear(callback) {\n        return (0, invoker_1.jsbridge)(`storage.${this.api}.clear`, null, callback);\n    }\n    __noSuchMethod__(name, args) {\n        console.log(`No such method ${name} called with ${args}`);\n        return;\n    }\n    ;\n}\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/storage.ts?')},"./src/api/tabs.ts":(__unused_webpack_module,exports,__webpack_require__)=>{eval("\nObject.defineProperty(exports, \"__esModule\", ({ value: true }));\nconst invoker_1 = __webpack_require__(/*! @pandola/bridge/src/invoker */ \"../../GCWebContainerDemo/web/src/invoker.ts\");\nvar TabStatus;\n(function (TabStatus) {\n})(TabStatus || (TabStatus = {}));\nvar WindowType;\n(function (WindowType) {\n})(WindowType || (WindowType = {}));\nclass Tabs {\n    create(createProperties, callback) {\n        return (0, invoker_1.jsbridge)('runtime.tabs.create', createProperties, callback);\n    }\n    remove(tabIds, callback) {\n        return (0, invoker_1.jsbridge)('runtime.tabs.remove', { tabIds }, callback);\n    }\n    query(queryInfo, callback) {\n        return (0, invoker_1.jsbridge)('runtime.tabs.query', { queryInfo }, callback);\n    }\n    sendMessage(tabId, message, options, callback) {\n        return (0, invoker_1.jsbridge)('runtime.tabs.sendMessage', { tabId, message, options: options !== null && options !== void 0 ? options : {} }, callback);\n    }\n    get onRemoved() {\n        const addListener = function (fn) {\n            window.gc.bridge.eventCenter.subscribe('PD_EVENT_TABS_ONREMOVED', function (result) {\n                fn(result['tabId'], result['removeInfo']);\n            });\n        };\n        return { addListener };\n    }\n    get onActivated() {\n        const addListener = function (fn) {\n            window.gc.bridge.eventCenter.subscribe('PD_EVENT_TABS_ONACTIVATED', function (result) {\n            });\n        };\n        return { addListener };\n    }\n    get onUpdated() {\n        const addListener = function (fn) {\n            window.gc.bridge.eventCenter.subscribe('PD_EVENT_TABS_ONUPDATED', function (result) {\n            });\n        };\n        return { addListener };\n    }\n    __noSuchMethod__(name, args) {\n        console.log(`No such method ${name} called with ${args}`);\n        return;\n    }\n    ;\n}\nexports[\"default\"] = Tabs;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/api/tabs.ts?")},"./src/index.ts":(__unused_webpack_module,exports,__webpack_require__)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nconst launcher_1 = __webpack_require__(/*! @pandola/bridge/src/launcher */ "../../GCWebContainerDemo/web/src/launcher.ts");\n(0, launcher_1.default)();\n__webpack_require__(/*! ./api/chrome */ "./src/api/chrome.ts");\nconst loader_1 = __webpack_require__(/*! ./loader/loader */ "./src/loader/loader.ts");\nwindow.chrome.__loader__ = loader_1.default;\nconsole.log("dddd");\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/index.ts?')},"./src/loader/background_loader.ts":(__unused_webpack_module,exports)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nfunction loadBGPackage(pkg) {\n    const { type, id, manifest } = pkg;\n    if (type !== "BACKGROUND" && type !== "CONTENT") {\n        return;\n    }\n    window.chrome.__pkg__ = pkg;\n}\nexports["default"] = loadBGPackage;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/loader/background_loader.ts?')},"./src/loader/loader.ts":(__unused_webpack_module,exports,__webpack_require__)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nconst background_loader_1 = __webpack_require__(/*! ./background_loader */ "./src/loader/background_loader.ts");\nfunction loadPackage(pkg) {\n    const { type } = pkg;\n    if (type === "BACKGROUND" || type === "CONTENT") {\n        (0, background_loader_1.default)(pkg);\n    }\n}\nexports["default"] = loadPackage;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/loader/loader.ts?')},"./src/no_such_method.ts":(__unused_webpack_module,exports)=>{eval('\nObject.defineProperty(exports, "__esModule", ({ value: true }));\nfunction ClassProxy(obj) {\n    return new Proxy(obj, {\n        get(target, p) {\n            if (p in target) {\n                return target[p];\n            }\n            else if (typeof p == "function") {\n                if (typeof target.__noSuchMethod__ == "function") {\n                    return function (...args) {\n                        return target.__noSuchMethod__.call(target, p, args);\n                    };\n                }\n            }\n            else {\n                console.log(`No property named ${p}`);\n            }\n        }\n    });\n}\nexports["default"] = ClassProxy;\n\n\n//# sourceURL=webpack://@pandola/pandora/./src/no_such_method.ts?')}},__webpack_module_cache__={};function __webpack_require__(e){var n=__webpack_module_cache__[e];if(void 0!==n)return n.exports;var r=__webpack_module_cache__[e]={exports:{}};return __webpack_modules__[e].call(r.exports,r,r.exports,__webpack_require__),r.exports}var __webpack_exports__=__webpack_require__("./src/index.ts")})();