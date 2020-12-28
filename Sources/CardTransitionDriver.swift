//
//  CardTransitionDriver.swift
//  
//
//  Created by James Randolph on 12/24/20.
//

import UIKit

final class CardTransitionDriver {
    
    let isPresenting: Bool
    
    let ctx: UIViewControllerContextTransitioning
    
    let gestureRecognizer: UIPanGestureRecognizer
    
    let propertyAnimator: UIViewPropertyAnimator
    
    let totalTransitionDistance: CGFloat
    
    init(isPresenting: Bool, ctx: UIViewControllerContextTransitioning, gestureRecognizer: UIPanGestureRecognizer) {
        self.isPresenting = isPresenting
        self.ctx = ctx
        self.gestureRecognizer = gestureRecognizer
        
        self.propertyAnimator = UIViewPropertyAnimator(duration: .zero, timingParameters: UISpringTimingParameters())
        
        let toVC = ctx.viewController(forKey: .to)!
        let fromView = ctx.view(forKey: .from)!
        let toView = ctx.view(forKey: .to)!
        let containerView = ctx.containerView
        
        let onscreenFrame = isPresenting ? ctx.finalFrame(for: toVC) : fromView.frame
        let offscreenY = containerView.frame.height
        self.totalTransitionDistance = offscreenY - onscreenFrame.origin.y
        
        self.gestureRecognizer.addTarget(self, action: #selector(updateInteraction(_:)))
        
        if isPresenting {
            containerView.addSubview(toView)
            toView.frame = ctx.finalFrame(for: toVC)
            toView.frame.origin.y = offscreenY
            propertyAnimator.addAnimations { [self] in
                toView.frame = onscreenFrame
                set(shrunkAndFaded: true, for: fromView)
            }
            
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
            toView.frame = onscreenFrame
            set(shrunkAndFaded: true, for: toView)
            propertyAnimator.addAnimations { [self] in
                fromView.frame.origin.y = offscreenY
                set(shrunkAndFaded: false, for: toView)
            }
        }
        
        propertyAnimator.addCompletion { [self] (position) in
            set(shrunkAndFaded: false, for: fromView)
            set(shrunkAndFaded: false, for: toView)
            let completed = (position == .end)
            ctx.completeTransition(completed)
        }
        
        if !ctx.isInteractive {
            animate(toPosition: .end)
        }
    }
    
    deinit {
        gestureRecognizer.removeTarget(self, action: nil)
    }
    
    private func set(shrunkAndFaded: Bool, for view: UIView) {
        view.transform = shrunkAndFaded ? CGAffineTransform(scaleX: 0.93, y: 0.93) : .identity
        view.alpha = shrunkAndFaded ? 0.7 : 1
    }
    
    @objc private func updateInteraction(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: ctx.containerView)
        let velocity = gestureRecognizer.velocity(in: ctx.containerView)
        let percentComplete = propertyAnimator.fractionComplete + progressStep(for: translation)

        switch gestureRecognizer.state {
        case .began:
            propertyAnimator.isReversed = false
            propertyAnimator.pauseAnimation()
            ctx.pauseInteractiveTransition()

        case .changed:
            propertyAnimator.fractionComplete = percentComplete
            ctx.updateInteractiveTransition(percentComplete)
            gestureRecognizer.setTranslation(.zero, in: ctx.containerView)

        case .cancelled, .ended:
            let initialVelocity: CGFloat
            if completionPosition() == .end {
                initialVelocity = velocity.y / ((1 - percentComplete) * ctx.containerView.bounds.height)
            } else {
                initialVelocity = velocity.y / (percentComplete * ctx.containerView.bounds.height)
            }
            endInteraction(withInitialVelocity: initialVelocity.isFinite ? initialVelocity : 0)

        default:
            break
        }
    }
    
    private func progressStep(for translation: CGPoint) -> CGFloat {
        return (isPresenting ? -1 : 1) * (translation.y / totalTransitionDistance)
    }
    
    private func endInteraction(withInitialVelocity velocity: CGFloat = 0) {
        guard ctx.isInteractive else { return }

        let completionPosition = self.completionPosition()
        if completionPosition == .end {
            ctx.finishInteractiveTransition()
        } else {
            ctx.cancelInteractiveTransition()
        }

        animate(toPosition: completionPosition, withInitialVelocity: velocity)
    }
    
    private func animate(toPosition: UIViewAnimatingPosition, withInitialVelocity velocity: CGFloat = 0) {
        propertyAnimator.isReversed = (toPosition == .start)
        if propertyAnimator.state == .inactive {
            propertyAnimator.startAnimation()
        } else {
            let sign: CGFloat = (isPresenting && toPosition == .end) || (!isPresenting && toPosition == .start) ? -1 : 1
            let vector = CGVector(dx: sign*velocity, dy: 0)
            propertyAnimator.continueAnimation(withTimingParameters: UISpringTimingParameters(dampingRatio: 1, initialVelocity: vector), durationFactor: 1)
        }
    }
    
    private func completionPosition() -> UIViewAnimatingPosition {
        let completionThreshold: CGFloat = 0.33
        let flickMagnitude: CGFloat = 1200
        let velocity = gestureRecognizer.velocity(in: ctx.containerView)
        let isFlick = (velocity.magnitude > flickMagnitude)
        let isFlickDown = isFlick && (velocity.y > 0)
        let isFlickUp = isFlick && (velocity.y < 0)
        if (isPresenting && isFlickUp) || (!isPresenting && isFlickDown) {
            return .end
        } else if (isPresenting && isFlickDown) || (!isPresenting && isFlickUp) {
            return .start
        } else if propertyAnimator.fractionComplete > completionThreshold {
            return .end
        } else {
            return .start
        }
    }
}

