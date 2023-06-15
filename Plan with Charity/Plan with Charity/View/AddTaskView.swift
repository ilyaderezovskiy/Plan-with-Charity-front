//
//  AddTaskView.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI

struct AddTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.self) private var env

    var selectedDate: Date
    @EnvironmentObject var taskModel: TaskModel
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskCost: Int = 0
    @State private var taskCategory: String = ".general"
    @State private var isDone = false
    @State private var isOverdue = false
    @State private var confirmationShown = false
    @State private var identifier: String = (Locale.current.languageCode ?? "ru")
    
    @State private var animateColor: Color = Category.general.color
    @State private var animate: Bool = false
    
//    @State private var showTimePicker = false
    
    let numFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                    
                    Button (
                        role: .destructive,
                        action: {
                            confirmationShown = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                                .contentShape(Rectangle())
                                .frame(minWidth: 50)
                                .font(.system(size: 25))
                        }
                        .confirmationDialog (
                            "Вы действительно хотите удалить задачу?",
                            isPresented: $confirmationShown,
                            titleVisibility: .visible) {
                                Button("Да") {
                                    withAnimation {
                                        if let editTask = taskModel.editTask {
                                            env.managedObjectContext.delete(editTask)
                                            try? env.managedObjectContext.save()
                                            env.dismiss()
                                        }
                                    }
                                }
                                Button("Нет", role: .cancel) { }
                            }
                            .disabled(isOverdue || taskDate < Date() || taskModel.editTask == nil)
                            .opacity(isOverdue || taskDate < Date() ? 0.6 : 1)
                            .opacity(taskModel.editTask == nil ? 0 : 1)
                }
                
                Text(taskModel.editTask == nil ? "Создание задачи" : "Редактирование задачи")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                
                Text("Название")
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 15)
                
                TextField("Название задачи", text: $taskModel.title)
                    .font(.title3)
//                    .tint(.white)
                    .padding(.top, 2)
                    .disabled((taskModel.editTask != nil) && (isOverdue || taskDate < Date()))
                    .opacity((taskModel.editTask != nil) && (isOverdue || taskDate < Date()) ? 0.6 : 1)
                
                Rectangle()
                    .fill(.white.opacity(0.7))
                    .frame(height: 1)
                
                Text("Дата")
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 15)
                
                HStack(alignment: .bottom, spacing: 12) {
                    HStack(spacing: 12) {
                        Text(taskDate.toString("dd MMMM, YYYY"))
                            .overlay {
                                DatePicker("", selection: $taskDate, displayedComponents: [.date])
                                    .blendMode(.destinationOver)
                                    .environment(\.locale, Locale(identifier: self.identifier))
                                    .disabled(taskModel.editTask != nil && (isOverdue || taskDate < Date()))
                                    .opacity(taskModel.editTask != nil && (isOverdue || taskDate < Date()) ? 0.6 : 1)
                            }
                        
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundColor(.white)
                            .overlay {
                                DatePicker("", selection: $taskDate, displayedComponents: [.date])
                                    .blendMode(.destinationOver)
                                    .environment(\.locale, Locale(identifier: self.identifier))
                                    .disabled(taskModel.editTask != nil && (isOverdue || taskDate < Date()))
                                    .opacity(taskModel.editTask != nil && (isOverdue || taskDate < Date()) ? 0.6 : 1)
                            }
                        }
                        .offset(y: -5)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(.white.opacity(0.7))
                                .frame(height: 1)
                                .offset(y: 5)
                        }
                    
                    HStack(spacing: 12) {
                        identifier == "ru" ? Text(taskDate.toString("HH:mm")).overlay {
                            DatePicker("", selection: $taskDate, displayedComponents: .hourAndMinute)
                                .blendMode(.destinationOver)
                                .environment(\.locale, Locale(identifier: self.identifier))
                                .disabled(taskModel.editTask != nil && (isOverdue || taskDate < Date()))
                                .opacity(taskModel.editTask != nil && (isOverdue || taskDate < Date()) ? 0.6 : 1)
                        } : Text(taskDate.toString("hh:mm a"))
                            .overlay {
                                DatePicker("", selection: $taskDate, displayedComponents: [.hourAndMinute])
                                    .blendMode(.destinationOver)
                                    .environment(\.locale, Locale(identifier: self.identifier))
                                    .disabled(taskModel.editTask != nil && (isOverdue || taskDate < Date()))
                                    .opacity(taskModel.editTask != nil && (isOverdue || taskDate < Date()) ? 0.6 : 1)
                            }
                        
                        Image(systemName: "clock")
                            .font(.title3)
                            .foregroundColor(.white)
                            .overlay {
                                DatePicker("", selection: $taskDate, displayedComponents: [.hourAndMinute])
                                    .blendMode(.destinationOver)
                                    .environment(\.locale, Locale(identifier: self.identifier))
                                    .disabled(taskModel.editTask != nil && (isOverdue || taskDate < Date()))
                                    .opacity(taskModel.editTask != nil && (isOverdue || taskDate < Date()) ? 0.6 : 1)
                            }
                    }
                    .offset(y: -5)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                }
                .padding(.bottom, 15)
            }
            .environment(\.colorScheme, .dark)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(15)
            .background {
                ZStack {
                    getColor(category: taskCategory).color
                    
                    GeometryReader {
                        let size = $0.size
                        Rectangle()
                            .fill(animateColor)
                            .mask {
                                Circle()
                            }
                            .frame(width: animate ? size.width * 2 : 0, height: animate ? size.height * 2 : 0)
                            .offset(animate ? CGSize(width: -size.width / 2, height: -size.height / 2) : size)
                    }
                    .clipped()
                }
                .ignoresSafeArea()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Описание")
                    .foregroundColor(.gray)
                
                TextField("Описание задачи", text: $taskModel.taskDescription)
                    .padding(.top, 2)
                    .disabled(taskModel.editTask != nil && (isOverdue || taskDate < Date()))
                    .opacity(taskModel.editTask != nil && (isOverdue || taskDate < Date()) ? 0.6 : 1)
                
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(height: 1)
                
                Text("Стоимость")
                    .foregroundColor(.gray)
                
                TextField("Стоимость задачи", value: $taskModel.cost, formatter: numFormatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 2)
                    .disabled(taskModel.editTask != nil && (isOverdue || taskDate < Date()))
                    .opacity(taskModel.editTask != nil && (isOverdue || taskDate < Date()) ? 0.6 : 1)
                
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(height: 1)
                
                Text("Категория")
                
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 20), count: 6), spacing: 15) {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        Text("")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 5)
                            .background {
                                Circle()
//                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(category.color.opacity(0.65))
                            }
                            .foregroundColor(category.color)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                guard !animate else {
                                    return
                                }
                                animateColor = category.color
                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                                    animate = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    animate = false
                                    taskCategory = ".\(category)"
                                }
                            }
                    }
                }
                .padding(15)
                
                Toggle(taskModel.isDone ? "Выполнено" : "Не выполнено", isOn: $taskModel.isDone)
                    .disabled(taskModel.editTask != nil && (isOverdue || taskDate < Date()))
                    .opacity(taskModel.editTask != nil && (isOverdue || taskDate < Date()) ? 0.6 : 1)
                
                Button {
                    taskModel.time = taskDate.toString("dd LL yyyy HH:mm")
                    taskModel.category = taskCategory
                    if taskModel.addTask(context: env.managedObjectContext) {
                        dismiss()
                    }
                } label: {
                     Text("Сохранить")
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background {
                            Capsule()
                                .fill(
                                    getColor(category: taskCategory).color
                                )
                        }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .disabled(taskModel.title == "" || isOverdue || animate || taskDate < Date())
                .opacity(taskModel.title == "" || isOverdue || taskDate < Date() ? 0.6 : 1)
            }
            .padding(15)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear() {
            taskDate = taskModel.editTask == nil ? selectedDate : taskModel.time.toDate("dd LL yyyy HH:mm")
            if taskModel.editTask != nil {
                taskCategory = taskModel.category
            }
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        .onTapGesture {
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
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
}

struct AddTaskView_Previews: PreviewProvider {
    static var selectedDate: Date = Date()
    static var previews: some View {
        AddTaskView (selectedDate: selectedDate)
    }
}
