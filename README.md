<img src="Docs/Images/Icon.png" width="180" />

# CardNavigation

A navigation controller that displays its view controllers as an interactive stack of cards.

Maintained by James Randolph ([@jamesrandolph01](https://twitter.com/jamesrandolph01)).

## Highlights

- ✅ Fully interactive and interruptible
- ✅ Works seamlessly with scroll views
- ✅ Supports changes in orientation
- ✅ Can be used with or without storyboards
- ✅ Written entirely in Swift using standard UIKit components

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

### Navigation Bar Appearance

By default, the navigation bar is transparent so the navigation controller's view's background color shows through. Change this color to whatever you'd like. You may also want to change the navigation bar's tint color.

```swift
nav.view.backgroundColor = .systemBlue
nav.navigationBar.tintColor = .white
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

## License

CardNavigation is released under the MIT license. See [LICENSE](LICENSE) for details.
