//
//  CardNavigationController.swift
//  PageSheetSample
//
//  Created by James Randolph on 12/25/20.
//

import UIKit

/// A navigation controller that displays its view controllers as an interactive stack of cards.
open class CardNavigationController: UINavigationController {
    
    /// The class to use for displaying the card's background content.
    ///
    /// You can override this property to return a custom view class to control the appearance of the card's background content.
    /// You may choose to return a class with rounded corners and a shadow, for example.
    open var cardBackgroundViewClass: UIView.Type {
        return CardBackgroundView.self
    }
    
    /// Whether the bottom card in the navigation stack should scroll with the content of the bottom view controller.
    ///
    /// This property only has an effect when the bottom view controller contains a scroll view.
    open var scrollsBottomCardWithContent: Bool {
        return true
    }
    
    /// The pan gesture recognizer driving the interactive portion of the transition.
    let panGestureRecognizer = UIPanGestureRecognizer()
    
    /// Whether the navigation controller is push/pop transitioning.
    var isTransitioning: Bool {
        return transitionCoordinator != nil
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        cardifyViewControllersIfNeeded()
        configurePanGestureRecognizer()
        
        // Transparent navigation bar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(cardify(viewController, isBottom: viewControllers.isEmpty), animated: animated)
    }
    
    private func cardify(_ viewController: UIViewController, isBottom: Bool) -> CardViewController {
        if let cardViewController = viewController as? CardViewController {
            return cardViewController
        } else {
            viewController.removeFromParent()
            return CardViewController(childViewController: viewController, cardBackgroundViewClass: cardBackgroundViewClass, scrollsCardWithContent: isBottom && scrollsBottomCardWithContent)
        }
    }
    
    private func cardifyViewControllersIfNeeded() {
        viewControllers = viewControllers.enumerated().map { (i, vc) -> CardViewController in
            return cardify(vc, isBottom: i == 0)
        }
    }
    
    private func configurePanGestureRecognizer() {
        panGestureRecognizer.delegate = self
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.addTarget(self, action: #selector(initiateTransitionInteractively(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func initiateTransitionInteractively(_ gestureRecognizer: UIPanGestureRecognizer) {
        if !isTransitioning && gestureRecognizer.state == .began {
            popViewController(animated: true)
        }
    }
}

extension CardNavigationController: UINavigationControllerDelegate {
    
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation != .none else { return nil }
        return CardAnimator(isPresenting: operation == .push, gestureRecognizer: panGestureRecognizer)
    }

    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animationController as? UIViewControllerInteractiveTransitioning
    }
}

extension CardNavigationController: UIGestureRecognizerDelegate {
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard otherGestureRecognizer is UIPanGestureRecognizer, let scrollView = otherGestureRecognizer.view as? UIScrollView else {
            return false
        }
        return !scrollView.isScrolledDown
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard otherGestureRecognizer is UIPanGestureRecognizer, let scrollView = otherGestureRecognizer.view as? UIScrollView else {
            return false
        }
        return scrollView.isScrolledDown
    }

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === self.panGestureRecognizer else { return true }

        let panIsDown = panGestureRecognizer.translation(in: panGestureRecognizer.view).isDown
        guard panIsDown else { return false }
        
        guard let topVC = transitionCoordinator?.viewController(forKey: .from) ?? topViewController else { return false }
        let topViewContainsPoint = topVC.view.point(inside: gestureRecognizer.location(in: topVC.view), with: nil)
        guard topViewContainsPoint else { return false }
        
        let isNotBottomVC = viewControllers.count > 1
        
        return isTransitioning ? true : isNotBottomVC
    }
}
