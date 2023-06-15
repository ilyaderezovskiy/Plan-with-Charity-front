//
//  UserNotificationsService.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI
import UserNotifications

class UserNotificationsService {
    static let instance = UserNotificationsService()
    var tasks: FetchedResults<Task>? = nil
    
    func requestAuthorization(tasks: FetchedResults<Task>) {
        self.tasks = tasks
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        let content = UNMutableNotificationContent()
        
        content.title = "Сегодня прекрасный день, чтобы выполнить все намеченные дела!"
        
        var subtitle: String = "Задачи на сегодня: "
        for task in self.tasks!.filter({ $0.time!.toDate("dd MM yyyy HH:mm").toString("dd MM yyyy") == Date().toString("dd MM yyyy")
            && !$0.isDone && !$0.isOverdue}) {
            subtitle.append(task.title!)
            subtitle.append(", ")
        }
        
        if subtitle != "Задачи на сегодня: " {
            subtitle.remove(at: subtitle.lastIndex(of: ",")!)
        }
        
        content.subtitle = subtitle
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        if (subtitle != "Задачи на сегодня: ") {
            UNUserNotificationCenter.current().add(request)
        }
    }
}

