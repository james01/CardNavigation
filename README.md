<img src="Docs/Images/Icon.png" width="180" />

# CardNavigation

A navigation controller that displays its view controllers as an interactive stack of cards.

## Highlights

- ✅ Fully interactive and interruptible
- ✅ Works seamlessly with scroll views
- ✅ Supports changes in orientation
- ✅ Can be used with or without storyboards
- ✅ Written entirely in Swift using standard UIKit components

`CardNavigation` is maintained by James Randolph ([@jamesrandolph01](https://twitter.com/jamesrandolph01)).

## Installation

### CocoaPods

To install `CardNavigation` using [CocoaPods](https://cocoapods.org), add the following line to your `Podfile`:

```ruby
pod 'CardNavigation'
```

### Swift Package Manager

To install `CardNavigation` using the [Swift Package Manager](https://swift.org/package-manager/), add the following value to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/james01/CardNavigation.git", .upToNextMajor(from: "0.0.0"))
]
```

## Basic Usage

CardNavigation consists of a single class: `CardNavigationController`. It behaves like a standard `UINavigationController`.

At the top of the file where you'd like to use a `CardNavigationController`, import `CardNavigation`.

```swift
import CardNavigation
```

Create your `CardNavigationController` instance the way you would a regular old `UINavigationController`.

```swift
let nav = CardNavigationController(rootViewController: SomeViewController())
```

By default, the navigation bar is transparent so the navigation controller's view's background color shows through. Change this color to whatever you'd like. You can also change the navigation bar's tint color.

```swift
nav.view.backgroundColor = .systemBlue
nav.navigationBar.tintColor = .white
```

## Advanced Usage

## License

CardNavigation is released under the MIT license. See [LICENSE](LICENSE) for details.
