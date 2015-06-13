//
//  ScheduleSwitcherViewController.swift
//  X Schedule
//
//  Created by Nicholas Reichert on 3/16/15.
//  Copyright (c) 2015 Nicholas Reichert.
//

import UIKit
import XScheduleKit

class ScheduleSwitcherViewController: UINavigationController {
    
    var currentOrientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
    var scheduleDate: NSDate = NSDate()
    var currentView: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCurrentOrientation()
        switchToOrientationView()
        
        registerAsOrientationListener()
    }
    private func registerAsOrientationListener() {
        //Register orientation change listener.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChangeNotification", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    private func updateCurrentOrientation() {
        //Store current orientation.
        currentOrientation = UIDevice.currentDevice().orientation
    }
    
    func deviceOrientationDidChangeNotification() {
        var newOrientation = UIDevice.currentDevice().orientation
        //Check if newOrientation is valid.
        if (newOrientation.isPortrait || newOrientation.isLandscape) {
            //Check if newOrientation is different from the currentOrientation.
            if (newOrientation != currentOrientation) {
                //Update current orientation and update UI.
                updateCurrentOrientation()
                switchToOrientationView()
            }
        }
    }
    
    func switchToOrientationView() {
        loadScheduleDateIntoViewController(self.topViewController)
        performSegueBasedOnOrientation()
        storeScheduleDate()
        updateCurrentView()
    }
    private func performSegueBasedOnOrientation() {
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) { //If on iPhone...
            //Check if there is a view already.
            if (self.topViewController != nil) {
                //Do nothing, because there is only one orientation.
            } else {
                //Add a new iPhone view controller.
                self.performSegueWithIdentifier("displayScheduleiPhone", sender: self)
            }
        } else if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) { //If on iPad...
            //Check orientation.
            if (UIDeviceOrientationIsLandscape(currentOrientation)) { //If orientation is landscape...
                self.performSegueWithIdentifier("displayScheduleiPadLandscape", sender: self)
            } else if (UIDeviceOrientationIsPortrait(currentOrientation)) { //If orientation is portrait...
                self.performSegueWithIdentifier("displayScheduleiPadPortrait", sender: self)
            }
        }
    }
    private func loadScheduleDateIntoViewController(viewController: UIViewController?) {
        //Take date from current view controller and store it.
        if let top = viewController {
            if let topData = top as? ScheduleViewController {
                self.scheduleDate = topData.scheduleDate
            }
        }
    }
    private func storeScheduleDate() {
        //Store date in new view controller if necessary.
        if let top = self.topViewController {
            if let topData = top as? ScheduleViewController {
                topData.scheduleDate = self.scheduleDate
            }
        }
    }
    private func updateCurrentView() {
        //Store the value of the current view.
        if let top = self.topViewController {
            currentView = top
        }
    }
    
}

class NoAnimationSegue: UIStoryboardSegue {
    override func perform() {
        let destination = destinationViewController as! UIViewController
        if let source = sourceViewController as? UINavigationController {
            //Transition with no animation.  Sets new view as root view controller.
            source.setViewControllers([destination], animated: false)
        }
    }
    
}
