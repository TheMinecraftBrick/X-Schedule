//
//  CacheManager.swift
//  X Schedule
//
//  Created by Nicholas Reichert on 5/30/15.
//  Copyright (c) 2015 Nicholas Reichert.
//

import Foundation

public class CacheManager {
    
    public static let defaultCacheLengthInDays = 30
    public static let scheduleCacheDirectoryName = "Schedules"
    
    public class func scheduleExistsForDate(date: NSDate) -> Bool {
        var path: String = pathForDate(date)
        var exists: Bool = fileManager().fileExistsAtPath(path)
        
        return exists
    }
    public class func loadScheduleForDate(date: NSDate) -> Schedule? {
        return Schedule()
    }
    public class func cacheSchedule(schedule: Schedule) {
        createScheduleCacheDir()
        var path: String = pathForDate(schedule.date)
        var contents: String = XScheduleParser.storeScheduleInString(schedule)
        
        contents.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
    }
    
    public class func buildCache() {
        buildCacheForLengthOfTime(numOfDays: defaultCacheLengthInDays)
    }
    public class func buildCacheForLengthOfTime(numOfDays days: Int) {
    
    }
    
    private class func fileManager() -> NSFileManager {
        var fileManager: NSFileManager = NSFileManager.defaultManager()
        
        return fileManager
    }
    private class func documentsDirectory() -> String {
        let directories: [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as! [String]
        let documentsDirectory: String =  directories[0]
        
        return documentsDirectory
    }
    private class func scheduleCacheDirectory() -> String {
        var path: String = documentsDirectory().stringByAppendingPathComponent(scheduleCacheDirectoryName)
        
        return path
    }
    private class func createScheduleCacheDir() {
        if ( !fileManager().fileExistsAtPath(scheduleCacheDirectory()) ) {
            fileManager().createDirectoryAtPath(scheduleCacheDirectory(), withIntermediateDirectories: true, attributes: nil, error: nil)
        }
    }
    
    private class func pathForDate(date: NSDate) -> String {
        var cacheDirectory: String = scheduleCacheDirectory()
        var scheduleFileName: String = fileNameForDate(date)
        var path: String = cacheDirectory.stringByAppendingPathComponent(scheduleFileName)
        
        return path
    }
    
    private class func fileNameForDate(date: NSDate) -> String {
        var dateFormat: NSDateFormatter = setUpFileDateFormatter()
        var dateString:  String = dateFormat.stringFromDate(date)
        var filename = "\(dateString).xml"
        
        return filename
    }
    private class func setUpFileDateFormatter() -> NSDateFormatter {
        var dateFormat: NSDateFormatter = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        dateFormat.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        return dateFormat
    }
}