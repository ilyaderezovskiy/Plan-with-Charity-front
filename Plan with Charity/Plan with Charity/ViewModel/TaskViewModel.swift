//
//  TaskViewModel.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI
import CoreData

class TaskModel: ObservableObject {
    @Published var id: String = UUID().uuidString
    @Published var title: String = ""
    @Published var time: String = ""
    @Published var cost: Int64 = 0
    @Published var taskDescription: String = ""
    @Published var category: String = ".general"
    @Published var isDone: Bool = false
    @Published var isOverdue: Bool = false
    
    @Published var editTask: Task?
    func addTask(context: NSManagedObjectContext) -> Bool {
        var task: Task!
        if let editTask = editTask {
            task = editTask
        } else {
            task = Task(context: context)
        }
        
        task.id = id
        task.title = title
        task.isDone = isDone
        task.time = time
        task.cost = cost
        task.taskDescription = taskDescription
        task.category = category
        task.isOverdue = isOverdue
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    func resetTaskData() {
        id = UUID().uuidString
        title = ""
        cost = 0
        time = Date().toString("dd LL yyyy HH:mm")
        taskDescription = ""
        category = ".general"
        isDone = false
        isOverdue = false
    }
    
    func setupTask() {
        if let editTask = editTask {
            id = editTask.id ?? UUID().uuidString
            title = editTask.title ?? ""
            cost = editTask.cost
            time = editTask.time ?? Date().toString("dd LL yyyy HH:mm")
            taskDescription = editTask.taskDescription ?? ""
            category = editTask.category ?? ".general"
            isDone = editTask.isDone
            isOverdue = editTask.isOverdue
        }
    }
}

func getSampleDate(offset: Int) -> Date {
    var calendar = Calendar.current
    calendar.locale =  Locale(identifier: "ru")
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}


