//
//  LVUtility.swift
//  boilerplate
//
//  Created by Leo Vigna on 22/12/2017.
//  Copyright © 2017 Leo Vigna. All rights reserved.
//

import Foundation
import UserNotifications

class LVUtility {
    
    static func addLocalNotification(title: String, body: String) {
        //Notify
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            
            content.title = title
            content.body = body
            content.sound = .default()
            
            let request = UNNotificationRequest(identifier: "LVUtility", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        } else {
            // Fallback on earlier versions
            // TODO: iOS < 10 Notifications
        }
        
    }
    
    ///Helper function returning the Documents Directory
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
