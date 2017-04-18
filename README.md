# MAGDebugKit

[![Version](https://img.shields.io/cocoapods/v/MAGDebugKit.svg?style=flat)](http://cocoapods.org/pods/MAGDebugKit)
[![License](https://img.shields.io/cocoapods/l/MAGDebugKit.svg?style=flat)](http://cocoapods.org/pods/MAGDebugKit)
[![Platform](https://img.shields.io/cocoapods/p/MAGDebugKit.svg?style=flat)](http://cocoapods.org/pods/MAGDebugKit)

## Fetures

1. Sending CocoaLumberjack logs to ELK log server.

2. Configuring CocoaLumberjack loggers.

3. Overview — view flowing above main window shows exact app version and any other info.

4. Rentgen mode — highlight views bounds, optionally display their classes.

5. Highlight tapped responder view and its view controller.

6. Simple filesystem browser and files previewer.

7. Custom actions with easy access from any screen.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MAGDebugKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MAGDebugKit"
```

To integrate into the project, in your AppDelegate, after the app main window is alreadey initialized, add following line:

```objectivec
[[MAGDebugPanel rightPanel] integrateAboveWindow:self.window];
```

## Authors

* Evgeniy Stepanov, stepanov@magora.systems
* Alexander Gorbunov, gorbunov@magora-systems.com  
* Denis Matveev

## License

MAGDebugKit is available under the MIT license. See the LICENSE file for more info.
