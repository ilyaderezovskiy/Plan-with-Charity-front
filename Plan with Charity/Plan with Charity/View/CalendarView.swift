//
//  CalendarView.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI

struct CalendarView: View {
    @Binding var showCalendarView: Bool
    @State var currentDate: Date = Date()
    @State private var addNewTask: Bool = false
    
    @StateObject var taskModel: TaskModel = .init()
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.time, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    
    @State var showsAlert = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.self) var env
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // Отображение кастомизированного календаря с задачами пользователя
                CustomDatePicker(currentDate: $currentDate)
            }
            .padding(.vertical)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                // Кнопка добавления задачи
                Button {
                    addNewTask.toggle()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                        Text("Добавить задачу")
                            .fontWeight(.bold)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
                .frame(maxWidth: 230)
                .foregroundColor(.white)
                .background(Color("Crayola Bleuet"), in: Capsule())
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .foregroundColor(.white)
            .padding(.bottom)
        }
        .fullScreenCover(isPresented: $addNewTask) {
            taskModel.resetTaskData()
        } content: {
            AddTaskView(selectedDate: Calendar.current.date(bySettingHour: 23, minute: 30, second: 0, of: currentDate)!)
                .environmentObject(taskModel)
        }
//        .onAppear() {
//            UserNotificationsService.instance.requestAuthorization()
//            UserNotificationsService.instance.scheduleNotification()
//        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { output in
            UIApplication.shared.applicationIconBadgeNumber = 0
        })
    }
}

struct CalendarView_Previews: PreviewProvider {
    @State static var showCalendarView: Bool = true
    static var previews: some View {
        CalendarView(showCalendarView: $showCalendarView)
    }
}
