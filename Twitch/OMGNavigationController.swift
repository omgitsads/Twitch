//
//  OMGNavigationController.swift
//  Twitch
//
//  Created by Adam Holt on 22/06/2015.
//  Copyright © 2015 OMGITSADS. All rights reserved.
//

import Cocoa
import SnapKit
import QuartzCore
import ClosureKit

class TwitchViewController: NSViewController {
    var navigationController: TwitchNavigationController!
}

class TwitchNavigationController: NSViewController {
    @IBOutlet weak var toolbar: NSToolbar!
    @IBOutlet weak var backButton: NSToolbarItem!
    
    var _viewControllers = [TwitchViewController]()
    let contentView = NSView(frame: NSZeroRect)
    
    override func viewDidLoad() {
        self.view.addSubview(self.contentView)
        
        self.contentView.snp_makeConstraints { (make) -> Void in
            make.width.top.bottom.equalTo(self.view)
        }
    }
    
    func setRootViewController(rootViewController: TwitchViewController) {
        if let currentViewController = _viewControllers.last {
            currentViewController.view.removeFromSuperview()
        }
        
        _viewControllers = []
        _viewControllers.append(rootViewController)
        
        rootViewController.navigationController = self
        self.contentView.addSubview(rootViewController.view)
        
        rootViewController.view.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(self.contentView)
            make.center.equalTo(self.contentView)
        }
        
        updateBackButton()
    }
    
    func topViewController() -> TwitchViewController {
        return _viewControllers.last!
    }
    
    func visibleViewController() -> TwitchViewController {
        return _viewControllers.last!
    }
    
    func setViewControllers(viewControllers: [TwitchViewController]) {
        _viewControllers = viewControllers
    }
    
    func _setViewControllers(viewControllers: [TwitchViewController], animated: Bool) {
        let visibleViewController = self.visibleViewController()
        let newTopmostController = viewControllers.last!
        
        let push = !(_viewControllers.contains(newTopmostController) && _viewControllers.indexOf(newTopmostController) < (_viewControllers.count - 1))
        
        self._navigateFrom(visibleViewController, toViewController: newTopmostController, animated: animated, push: push)
    }
    
    func _navigateFrom(viewController: TwitchViewController, toViewController: TwitchViewController, animated:Bool, push:Bool) {
        toViewController.navigationController = self
        toViewController.view.frame = self.contentView.bounds

        if(push) {
            self.contentView.animations = ["subviews": self.slideAnimation(kCATransitionFromRight)]
        } else {
            self.contentView.animations = ["subviews": self.slideAnimation(kCATransitionFromLeft)]
        }
        
        let animator = self.contentView.animator()
        animator.replaceSubview(viewController.view, with: toViewController.view)
        
        toViewController.view.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(self.contentView)
            make.center.equalTo(self.contentView)
        }
        
        self.updateBackButton()
    }
    
    func pushViewController(viewController: TwitchViewController, animated:Bool) {
        let visibleViewController = self.visibleViewController()
        
        _viewControllers.append(viewController)
        
        self._navigateFrom(visibleViewController, toViewController: viewController, animated: animated, push: true)
    }
    
    func popViewController(animated: Bool) -> TwitchViewController? {
        if(_viewControllers.count == 1) { return nil }
        
        let controller = _viewControllers.last!
        _viewControllers.removeLast()
        
        self._navigateFrom(controller, toViewController: _viewControllers.last!, animated: animated, push: false)
        
        return controller
    }
    
    func popToRootViewController(animated: Bool) -> NSArray {
        if(_viewControllers.count == 1) { return [] }
        
        let rootViewController = _viewControllers[0]
        _viewControllers.removeAtIndex(0)
        
        let dispControllers = NSArray(array: _viewControllers)
        _viewControllers = [rootViewController]
        
        self._navigateFrom(dispControllers.lastObject as! TwitchViewController, toViewController: rootViewController, animated: animated, push: false)
        
        return dispControllers
    }
    
    func updateBackButton() {
        if(self._viewControllers.count > 1){
            if self.toolbar.items.ck_match({ (toolbarItem) -> Bool in toolbarItem.itemIdentifier == "backButton"}) == nil {
                self.toolbar.insertItemWithItemIdentifier("backButton", atIndex: 2)
            }
        } else {
            if let item = self.toolbar.items.ck_match({ (toolbarItem) -> Bool in toolbarItem.itemIdentifier == "backButton"}) {
                let index = self.toolbar.items.indexOf(item)
                self.toolbar.removeItemAtIndex(index!)
            }
        }
    }
    
    func slideAnimation(direction: String) -> CAAnimation {
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = direction
        return transition
    }
    
    @IBAction func goBack(sender:AnyObject?) {
        self.popViewController(true)
    }
}
