//
//  CardViewController.swift
//  PageSheetSample
//
//  Created by James Randolph on 12/25/20.
//

import UIKit

final class CardViewController: UIViewController {
    
    let child: UIViewController
    
    let scrollsCardWithContent: Bool
    
    let cardView = CardView()
    
    let maskView = UIView()
    
    private var scrollObserver: NSKeyValueObservation?
    
    override var navigationItem: UINavigationItem {
        return child.navigationItem
    }
    
    init(child: UIViewController, scrollsCardWithContent: Bool) {
        self.child = child
        self.scrollsCardWithContent = scrollsCardWithContent
        super.init(nibName: nil, bundle: nil)
        
        edgesForExtendedLayout = []
        
        // Card view
        cardView.frame = view.bounds
        cardView.frame.size.height += 100
        cardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(cardView)
        
        // Mask view
        maskView.frame = view.bounds
        maskView.backgroundColor = .black
        maskView.layer.cornerRadius = cardView.layer.cornerRadius
        maskView.layer.maskedCorners = cardView.layer.maskedCorners
        if #available(iOS 13.0, *) {
            maskView.layer.cornerCurve = .continuous
        }
        
        // Child view controller
        addChild(child)
        child.view.frame = view.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.view.mask = maskView
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        // Listen to scroll
        let scrollView = (child.view as? UIScrollView) ?? (child.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView)
        if scrollsCardWithContent, let scrollView = scrollView {
            scrollObserver = scrollView.observe(\.contentOffset) { [self] (scrollView, _) in
                let dy = -min(scrollView.contentOffset.y + scrollView.adjustedContentInset.top, 0)
                cardView.transform = CGAffineTransform(translationX: 0, y: dy)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        maskView.frame = cardView.frame
    }
}
