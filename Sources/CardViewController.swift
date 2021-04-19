//
//  CardViewController.swift
//
//
//  Created by James Randolph on 12/25/20.
//

import UIKit

final class CardViewController: UIViewController {
    
    let child: UIViewController
    
    let scrollsCardWithContent: Bool
    
    let cardBackgroundView: UIView
    
    let mask = UIView()
    
    private var scrollObserver: NSKeyValueObservation?
    
    override var navigationItem: UINavigationItem {
        return child.navigationItem
    }
    
    init(childViewController child: UIViewController, cardBackgroundViewClass: UIView.Type, scrollsCardWithContent: Bool) {
        self.child = child
        self.cardBackgroundView = cardBackgroundViewClass.init()
        self.scrollsCardWithContent = scrollsCardWithContent
        super.init(nibName: nil, bundle: nil)
        
        edgesForExtendedLayout = []
        
        // Card view
        cardBackgroundView.frame = view.bounds
        cardBackgroundView.frame.size.height += 100
        cardBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(cardBackgroundView)
        
        // Mask
        mask.frame = view.bounds
        mask.backgroundColor = .black
        mask.layer.cornerRadius = cardBackgroundView.layer.cornerRadius
        mask.layer.maskedCorners = cardBackgroundView.layer.maskedCorners
        if #available(iOS 13.0, *) {
            mask.layer.cornerCurve = .continuous
        }
        
        // Masked container
        let maskedContainer = UIView()
        maskedContainer.frame = view.bounds
        maskedContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        maskedContainer.mask = mask
        view.addSubview(maskedContainer)
        
        // Child view controller
        addChild(child)
        child.view.frame = maskedContainer.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        maskedContainer.addSubview(child.view)
        child.didMove(toParent: self)
        
        // Listen to scroll
        let scrollView = (child.view as? UIScrollView) ?? (child.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView)
        if scrollsCardWithContent, let scrollView = scrollView {
            scrollObserver = scrollView.observe(\.contentOffset) { [self] (scrollView, _) in
                let dy = -min(scrollView.contentOffset.y + scrollView.adjustedContentInset.top, 0)
                cardBackgroundView.transform = CGAffineTransform(translationX: 0, y: dy)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mask.frame = cardBackgroundView.frame
    }
}
