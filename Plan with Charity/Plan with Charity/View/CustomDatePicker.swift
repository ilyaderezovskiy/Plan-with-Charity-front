//
//  CustomDatePicker.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    
    @StateObject var taskModel: TaskModel = .init()
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.time, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    
    @State var currentMonth: Int = 0
    @State var selectedTask: TaskModel?
    @State private var editTask: Bool = false
    @State private var identifier: String = (Locale.current.languageCode ?? "ru")
    
    @State var shouldPresentSheet = false
    
    var body: some View {
        VStack(spacing: 35) {
            
            let days: [String] = identifier == "ru" ? [String(localized: "Пн"), String(localized: "Вт"), String(localized: "Ср"), String(localized: "Чт"), String(localized: "Пт"), String(localized: "Сб"), String(localized: "Вс")] : [String(localized: "Вс"),
                                                                                                                                                                                                                                         String(localized: "Пн"), String(localized: "Вт"), String(localized: "Ср"), String(localized: "Чт"), String(localized: "Пт"), String(localized: "Сб")]
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraDate()[1].capitalizingFirstLetter())
                        .font(.title3)
                }
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    withAnimation {
                        currentDate = Date()
                        currentMonth = 0
                    }
                } label: {
                    Text("Сегодня")
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .frame(minWidth: 30)
                }
                
                // Кнопка личного кабинета пользователя
                Button {
                    shouldPresentSheet.toggle()
                } label: {
                    Image(systemName: "person.crop.circle")
                        .contentShape(Rectangle())
                        .foregroundColor(Color("Crayola Bleuet"))
                        .frame(minWidth: 30)
                        .font(.system(size: 45))
                }
                .cornerRadius(10)
                .sheet(isPresented: $shouldPresentSheet, content: {
                    ProfileView()
                })
                
            }
            .padding(.horizontal)
            
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            // Заполнение календаря числами с отметками о наличии задач
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .background(
                            Capsule()
                                .fill(.pink)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                            
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            
            // Отображение задач пользователя
            VStack(spacing: 15) {
                Text("Задачи")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 20)
                if tasks.first(where: { task in
                    return isSameDay(date1: task.time!.toDate("dd MM yy HH:mm"), date2: currentDate)
                }) != nil {
                    // Фильтрация задач по выбранному дню
                    ForEach(tasks.sorted(by: { $0.time! <= $1.time! }).filter { task in
                        if isSameDay(date1: task.time!.toDate("dd MM yy HH:mm"), date2: currentDate) {
                            return true
                        } else {
                            return false
                        }
                    }) { task in
                        VStack(alignment: .leading, spacing: 10) {
                            
                            // Отображение информации о задаче
                            HStack {
                                identifier == "ru" ? Text((task.time!.toDate("dd MM yy HH:mm")).toString("HH:mm")) : Text((task.time!.toDate("dd MM yy HH:mm")).toString("hh:mm a"))
//                                Text((task.time!.toDate("dd MM yy HH:mm")).toString("hh:mm"))

                                Text(task.isDone ? "Выполнено!" : "")

                                Spacer()

                                Button {
                                    taskModel.editTask = task
                                    editTask.toggle()
                                    taskModel.setupTask()
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 30))
                                        .foregroundColor(.black)
                                        .padding(5)
                                }
                            }
                            
                            Text(task.title!)
                                .font(.title2.bold())

                            Text(task.taskDescription!)
                                .font(.title3)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            task.isOverdue || (task.time!.toDate("dd MM yy HH:mm") < Date() && task.isDone == false) ? LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.5), .white]), startPoint: .leading, endPoint: .trailing).cornerRadius(10): LinearGradient(gradient: Gradient(colors: [getColor(category: task.category!).color
                                .opacity(0.5), .white]), startPoint: .leading, endPoint: .trailing)
                                .cornerRadius(10)
                        )
                    }
                } else {
                    Text("Актуальных задач нет")
                }
            }
            .padding()
        }
        .onChange(of: currentMonth) { newValue in
            currentDate = getCurrentMonth()
        }
        .onAppear() {
            UserNotificationsService.instance.requestAuthorization(tasks: tasks)
            UserNotificationsService.instance.scheduleNotification()
        }
        .fullScreenCover(isPresented: $editTask) {
            AddTaskView(selectedDate: Calendar.current.date(bySettingHour: 23, minute: 30, second: 0, of: currentDate)!)
                .environmentObject(taskModel)
        }
    }
    
    // Отображение задач пользователя в виде карточек
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = tasks.first(where: { task in
                    
                    return isSameDay(date1: task.time!.toDate("dd MM yy HH:mm"), date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.time!.toDate("dd MM yy HH:mm"), date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: task.time!.toDate("dd MM yy HH:mm"), date2: currentDate) ? .white : .pink)
                        .frame(width: 8, height: 8)
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    
    // Сравнение дат
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, equalTo: date2, toGranularity: .day)
    }
    
    // Получение текущей даты
    func extraDate() -> [String] {
        let date = currentDate.toString("YYYY LLLL")
        
        return date.components(separatedBy: " ")
    }
    
    // Получение текущего месяца
    func getCurrentMonth() -> Date {
        
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    // Получение чисел для заполнения календаря
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days =  currentMonth.getAllDates().compactMap { date ->
            DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        var firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date()) - 1
        if firstWeekday == 0 {
            firstWeekday = 7
        }
        
        if identifier == "ru" {
            for _ in 0..<firstWeekday - 1 {
                days.insert(DateValue(day: -1, date: Date()), at: 0)
            }
        } else {
            for _ in 0..<firstWeekday {
                days.insert(DateValue(day: -1, date: Date()), at: 0)
            }
        }
        
        return days
    }
    
    func getColor(category: String) -> Category {
        if category == ".general" {
            return Category.general
        } else if category == ".bug" {
            return Category.bug
        } else if category == ".idea" {
            return Category.idea
        } else if category == ".modifiers" {
            return Category.modifiers
        } else if category == ".challenge" {
            return Category.challenge
        } else {
            return Category.coding
        }
    }
    
    func getMonth(month: String) -> String {
        if month == "Январь" {
            return String(localized: "Январь")
        } else if month == "Февраль" {
            return String(localized: "Февраль")
        } else if month == "Март" {
            return String(localized: "Март")
        } else if month == "Апрель" {
            return String(localized: "Апрель")
        } else if month == "Май" {
            return String(localized: "Май")
        } else if month == "Июнь" {
            return String(localized: "Июнь")
        } else if month == "Июль" {
            return String(localized: "Июль")
        } else if month == "Август" {
            return String(localized: "Август")
        } else if month == "Сентябрь" {
            return String(localized: "Сентябрь")
        } else if month == "Октябрь" {
            return String(localized: "Октябрь")
        } else if month == "Ноябрь" {
            return String(localized: "Ноябрь")
        } else {
            return String(localized: "Декабрь")
        }
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    @State static var currentDate: Date = Date()

    static var previews: some View {
        CustomDatePicker(currentDate: $currentDate)
    }
}

extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
    
    func toDate(_ format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
}

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "ru_RU")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
