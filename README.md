<img src="Docs/Images/Icon.png" width="180" />

# CardNavigation

A navigation controller that displays its view controllers as an interactive stack of cards.

## Features

- ✅ Fully interactive and interruptible
- ✅ Works seamlessly with `UIScrollView`
- ✅ Works in any orientation

## Installation

### CocoaPods

Add the following line to your `Podfile`:

```ruby
pod 'CardNavigation'
```

## Usage

CardNavigation consists of a single class: `CardNavigationController`. Use it like you would any other `UINavigationController`:

```swift
import CardNavigation

...

let cardNavigationController = CardNavigationController(rootViewController: SomeViewController())
```

## Author

James Randolph ([@jamesrandolph01](https://twitter.com/jamesrandolph01))

## License

CardNavigation is released under the MIT license. [See LICENSE](LICENSE) for details.
