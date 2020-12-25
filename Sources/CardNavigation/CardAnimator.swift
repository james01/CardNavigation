//
//  CardAnimator.swift
//  
//
//  Created by James Randolph on 12/24/20.
//

import UIKit

internal final class CardAnimator: NSObject {

    let isPresenting: Bool
    
    let gestureRecognizer: UIPanGestureRecognizer
    
    var transitionDriver: CardTransitionDriver?

    init(isPresenting: Bool, gestureRecognizer: UIPanGestureRecognizer) {
        self.isPresenting = isPresenting
        self.gestureRecognizer = gestureRecognizer
    }
}

extension CardAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }

    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
    }
    
    func interruptibleAnimator(using ctx: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return transitionDriver!.propertyAnimator
    }
}

extension CardAnimator: UIViewControllerInteractiveTransitioning {
    
    var wantsInteractiveStart: Bool {
        return gestureRecognizer.state == .began
    }
    
    func startInteractiveTransition(_ ctx: UIViewControllerContextTransitioning) {
        transitionDriver = CardTransitionDriver(isPresenting: isPresenting, ctx: ctx, gestureRecognizer: gestureRecognizer)
    }
}
