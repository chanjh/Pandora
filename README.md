![](https://github.com/chanjh/Pandora/blob/main/images/logo.png?raw=true)

## What is Pandora
**Pandora** 是让 iOS 应用可以完整运行 Chrome Extension 的框架。

Pandora 目前还处理**开发阶段**，请勿在正式环境使用。

## Why Pandora
Web on App 是一个非常吸引人的话题，它是一个探讨 Web 的灵活性和 App 的稳定性平衡的话题。无论是 PWA、React Native 还是在国内比较火的小程序、快应用，都在这个领域不断尝试。

我是一个 Web on App 的爱好者，喜欢两者各自的优点。研究过小程序、RN 等等框架的原理之后，想要在 iOS 上，也创建一个有趣的 Web on App 框架。

虽然 Apple 在 iOS 15 和 iPadOS 15 上带来了 Safari Extension，但 SE 受限于 App Store，不能直接使用 Chrome Extension 商店里成千上万的应用。Pandora 可以摆脱这个依赖，让 iOS 设备运行原生 Browser Extension。

## How Pandora works
Pandora 灵活使用了 WebKit 提供的 JavaScript 运行时（基于 JSCore），搭建了 JS 和 App 之间的通讯桥，模拟了 Browser Extension 的运行机制。下面是 Pandora 的运行图和依赖关系图

![](https://github.com/chanjh/Pandora/blob/main/images/framework.png?raw=true)

![](https://github.com/chanjh/Pandora/blob/main/images/dependency.png?raw=true)

## Contributing
Pandora 是一个 Web+iOS 的框架，同时包含了 Web（TS）和 iOS（Swift）两端代码。为 Pandora 贡献你的能力吧！你可以：

1. 完善 JSAPI
2. 修复已知 Bug
3. 添加更多实用功能
4. 发现 Bug，提交 issue