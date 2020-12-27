//
//  Extensions.swift
//  
//
//  Created by James Randolph on 12/24/20.
//

import UIKit

extension CGPoint {
    /// The magnitude of the point as a vector.
    internal var magnitude: CGFloat {
        return sqrt(x*x + y*y)
    }
    
    /// Returns `true` if `y` is greater than 0, and the absolute value of `y` is greater than that of `x`.
    internal var isDown: Bool {
        return (y > 0) && (abs(y) > abs(x))
    }
}

extension UIScrollView {
    /// Whether the scroll view is scrolled down.
    internal var isScrolledDown: Bool {
        return contentOffset.y > -adjustedContentInset.top
    }
}
