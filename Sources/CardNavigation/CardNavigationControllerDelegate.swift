//
//  CardNavigationControllerDelegate.swift
//  
//
//  Created by James Randolph on 12/24/20.
//

import UIKit

open class CardNavigationControllerDelegate: NSObject {
    
    public let panGestureRecognizer = UIPanGestureRecognizer()
    
    public weak var navigationController: UINavigationController?
    
    public var isTransitioning: Bool {
        return navigationController?.transitionCoordinator != nil
    }
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        configurePanGestureRecognizer()
    }
    
    open func configurePanGestureRecognizer() {
        panGestureRecognizer.delegate = self
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.addTarget(self, action: #selector(initiateTransitionInteractively(_:)))
        navigationController?.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc open func initiateTransitionInteractively(_ gestureRecognizer: UIPanGestureRecognizer) {
        if !isTransitioning && gestureRecognizer.state == .began {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension CardNavigationControllerDelegate: UINavigationControllerDelegate {
    
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation != .none else { return nil }
        return CardAnimator(isPresenting: operation == .push, gestureRecognizer: panGestureRecognizer)
    }

    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animationController as? UIViewControllerInteractiveTransitioning
    }
}

extension CardNavigationControllerDelegate: UIGestureRecognizerDelegate {
    
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

        guard !isTransitioning else { return panIsDown }

        let isNotBottomVC = navigationController?.viewControllers.count ?? 0 > 1
        return panIsDown && isNotBottomVC
    }
}
