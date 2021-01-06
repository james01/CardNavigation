<img src="https://raw.githubusercontent.com/james01/CardNavigation/main/Docs/Images/Icon.png" width="180" />

# CardNavigation

[![CocoaPods](https://img.shields.io/cocoapods/v/CardNavigation)](https://cocoapods.org/pods/CardNavigation)
![Platform](https://img.shields.io/cocoapods/p/CardNavigation?logo=Apple)

The easiest* way to turn a navigation controller into an interactive stack of cards.

*according to me

## Highlights

- ✅ Fully interactive and interruptible
- ✅ Works seamlessly with scroll views
- ✅ Supports changes in orientation
- ✅ Can be used with or without storyboards
- ✅ Written entirely in Swift using standard UIKit components

## Example

<img src="https://raw.githubusercontent.com/james01/CardNavigation/main/Docs/Images/Screen.gif" width="239" />

## Installation

### CocoaPods

To install `CardNavigation` using [CocoaPods](https://cocoapods.org), add the following line to your `Podfile`:

```ruby
pod 'CardNavigation', '~> 1.0'
```

### Swift Package Manager

To install `CardNavigation` using the [Swift Package Manager](https://swift.org/package-manager/), add the following value to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/james01/CardNavigation.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

### Getting Started

CardNavigation consists of a single class: `CardNavigationController`. It behaves like a standard `UINavigationController`.

At the top of the file where you'd like to use a `CardNavigationController`, import `CardNavigation`.

```swift
import CardNavigation
```

Create your `CardNavigationController` instance the way you would a regular old `UINavigationController`.

```swift
let nav = CardNavigationController(rootViewController: SomeViewController())
```

### Navigation Bar Color

By default, the navigation bar is transparent. The color that shows in its place is the background color of the navigation controller.

```swift
nav.view.backgroundColor = .systemTeal
```

### Card Appearance

To change the card appearance, create a custom view class.

```swift
import UIKit

class MyCardBackgroundView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        layer.cornerRadius = 32
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerCurve = .continuous

        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

Then, create a subclass of `CardNavigationController` and override the `cardBackgroundViewClass` property to return your custom class.

```swift
import UIKit
import CardNavigation

class MyCardNavigationController: CardNavigationController {

    override var cardBackgroundViewClass: UIView.Type {
        return MyCardBackgroundView.self
    }
}
```

## Author

James Randolph ([@jamesrandolph01](https://twitter.com/jamesrandolph01))

## License

CardNavigation is released under the MIT license. See [LICENSE](LICENSE) for details.
