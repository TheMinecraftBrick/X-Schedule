//
//  AppDelegate.swift
//  X Schedule
//
//  Created by Nicholas Reichert on 2/13/15.
//  Copyright (c) 2015 Nicholas Reichert.
//

import UIKit
import XScheduleKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarDelegate: MainTabBarDelegate?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setUpTabBarDelegate()
        
        CacheManager.buildCache()
        
        return true
    }
    private func setUpTabBarDelegate() {
        //Allow delegate to control tab bar.
        if let tabBar = self.window?.rootViewController as? UITabBarController {
            tabBarDelegate = MainTabBarDelegate()
            tabBar.delegate = tabBarDelegate
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        refreshSchedule()
    }
    
    func refreshSchedule() {
        var scheduleViewController: ScheduleViewController = getScheduleViewController()!
        scheduleViewController.refreshSchedule()
        
        if let pageView = scheduleViewController as? SwipeDataViewController {
            pageView.pageController().flipPageInDirection(UIPageViewControllerNavigationDirection.Forward, withDate: pageView.scheduleDate)
        }
    }
    func setScheduleDateToToday() {
        var scheduleViewController: ScheduleViewController = getScheduleViewController()!
        scheduleViewController.scheduleDate = NSDate()
    }
    private func getScheduleSwitcherViewController() -> ScheduleSwitcherViewController? {
        var returnController: ScheduleSwitcherViewController?
        var tabBarController: UITabBarController = self.window!.rootViewController! as! UITabBarController
        for controller in tabBarController.viewControllers! {
            var viewController = controller as! UIViewController
            if let switcher = viewController as? ScheduleSwitcherViewController {
                returnController = switcher
            }
        }
        return returnController
    }
    private func getScheduleViewController() -> ScheduleViewController? {
        var switcher = getScheduleSwitcherViewController()!
        var returnController: ScheduleViewController?
        if let currentView = switcher.currentView {
            if let scheduleView = currentView as? ScheduleViewController {
                returnController = scheduleView
            }
        }
        return returnController
    }

}
