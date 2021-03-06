//
//  SwipeDataViewController.swift
//  X Schedule
//
//  Created by Nicholas Reichert on 6/28/15.
//  Copyright (c) 2015 Nicholas Reichert.
//

import UIKit
import XScheduleKit

class SwipeDataViewController: DataViewController {
    
    override func onBackButtonPress(_ sender: AnyObject) {
        super.onBackButtonPress(sender)
        pageController().flipPageInDirection(UIPageViewControllerNavigationDirection.reverse, withDate: scheduleDate)
    }
    override func onForwardButtonPress(_ sender: AnyObject) {
        super.onForwardButtonPress(sender)
        pageController().flipPageInDirection(UIPageViewControllerNavigationDirection.forward, withDate: scheduleDate)
    }
    override func onTodayButtonPress(_ sender: AnyObject) {
        let previousDate: Date = scheduleDate
        super.onTodayButtonPress(sender)
        //Find which direction to flip in.
        switch (previousDate.compare(scheduleDate)) {
            case .orderedAscending:
                pageController().flipPageInDirection(UIPageViewControllerNavigationDirection.forward, withDate: scheduleDate)
            case .orderedDescending:
                pageController().flipPageInDirection(UIPageViewControllerNavigationDirection.reverse, withDate: scheduleDate)
            case .orderedSame:
                break //Do nothing.
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onTodayButtonPress(self)
    }
    
    override func tableController() -> ScheduleTableController? {
        return nil
    }
    
    override func emptyUILabel() -> UILabel? {
        return nil
    }
    
    func pageController() -> DataPageViewController {
        var controller: DataPageViewController
        controller = self.childViewControllers.first as! DataPageViewController
        
        return controller
    }
    
}
