//
//  ProfileView.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    @State var image: Image? = Image(UserDefaults.standard.string(forKey: "photo") ?? "ProfilePhoto" )
    @State var isPickerShow = false
    
    @State var cards: [CardInfo] = getCardInfo()
    @Environment(\.self) private var env
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.time, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    @StateObject var taskModel: TaskModel = .init()
    
    @State var sum: Int = UserDefaults.standard.integer(forKey: "sum")
    @State var passedSum: Int = UserDefaults.standard.integer(forKey: "passed")
    @State var searchText: String = ""
    @State var passed: Int = 0
    @State var selectedCard: CardInfo?
    @State private var confirmationShown = false
    @State private var confirmationShown2 = false
    @State private var confirmationShown3 = false
    @State private var confirmationShown4 = false
    @State private var confirmationShown5 = false

    @Environment(\.dismiss) private var dismiss
    
    @State var name: String = UserDefaults.standard.string(forKey: "username") ?? ""
 
    @State private var isEditing = false

    let numFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Spacer()

                    Button {
                        confirmationShown5.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.gray)
                            .font(.system(size: 25))
                    }
                    .padding(20)
                    .padding(.top, 0)
                    .sheet(isPresented: $confirmationShown5) {
                        ReportView()
                    }
                }
                
                VStack {
                    ZStack {
                        image!
                            .resizable()
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130, height: 130)
                            .padding(20)
                            .padding(.top, -50)
                        
                        Button {
                            isPickerShow.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.gray)
                                    .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white, lineWidth: 3)
                                    )
                                
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .offset(x: 50, y: 25)
                        .sheet(isPresented: $isPickerShow) {
                            ImagePickerView(image: $image)
                        }
                    }

                    HStack {
                        Text(name)
                            .font(.title)
                            .fontWeight(.bold)
                            .offset(x: 5, y: -14)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .offset(x: 5, y: -10)
                    }
                    
                    Text(String(localized: "Переведено на благотворительность:   \(String(passedSum))"))
                        .font(.caption)

                    Text(String(localized: "Накопленная сумма:   \(String(self.sum))"))
                        .font(.title2)
                        .padding()

                    HStack {
                        Spacer()

                        // Кнопка сброса накопленной суммы
                        Button (
                            role: .destructive,
                            action: {
                                confirmationShown = true
                            }) {
                                Text("Сбросить сумму")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("Gray"))
                            }
                            .confirmationDialog (
                                "Вы действительно хотите сбросить накопленную сумму?",
                                isPresented: $confirmationShown,
                                titleVisibility: .visible) {
                                    Button("Да") {
                                        withAnimation {
                                            UserDefaults.standard.set(0, forKey: "sum")
                                            self.sum = 0
                                        }
                                    }
                                    Button("Нет", role: .cancel) { }
                                }
                                .disabled(self.sum == 0)
                                .opacity(self.sum == 0 ? 0.6 : 1)

                    }
                    .padding(.horizontal, 55)
                    .padding(.vertical, 2)

                    HStack {
                        Spacer()
                        
                        VStack {
                            Text("Сумма перевода")
                            
                            HStack {
                                TextField("Сумма", value: $passed, formatter: numFormatter)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                
                                Text("₽")
                            }
                        }
                        .padding()

                        // Кнопка подтверждения денежного перевода
                        Button {
                            confirmationShown2 = true
                        } label: {
                            Text("Подтвердить перевод")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 80))
                        .padding()
                        .confirmationDialog (
                            "Вы действительно совершили денежный перевод в размере указанной суммы?",
                            isPresented: $confirmationShown2,
                            titleVisibility: .visible) {
                                Button("Да") {
                                    withAnimation {
                                        if passed > 0 && passed >= sum {
                                            UserDefaults.standard.set(0, forKey: "sum")
                                            sum = 0
                                            passedSum = passedSum + passed
                                            UserDefaults.standard.set(passedSum, forKey: "passed")
                                        } else if passed > 0 {
                                            sum = sum - passed
                                            UserDefaults.standard.set(sum, forKey: "sum")
                                            passedSum = passedSum + passed
                                            UserDefaults.standard.set(passedSum, forKey: "passed")
                                        }
                                    }
                                }
                                Button("Нет", role: .cancel) {
                                }
                            }
                            .disabled(self.passed == 0)
                            .opacity(self.passed == 0 ? 0.6 : 1)
                    }
                    
                    SearchBar(text: $searchText)
                        .padding(.top, 0)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(cards.filter({ searchText == "" ? true : ($0.title.lowercased().contains(searchText.lowercased()) || $0.description.lowercased().contains(searchText.lowercased()))})) { card in
                                ZStack {
                                CardView(name: card.title, description: card.description)
                                        .onTapGesture() {
                                            selectedCard = card
                                            confirmationShown4.toggle()
                                        }
                                }
                                .sheet(isPresented: $confirmationShown4) {
                                    HStack {
                                        Rectangle()
                                            .frame(width: 0)
                                            .foregroundColor(.blue)
                                            .opacity(0.3)
                                        Spacer()
                                    }
                                    .ignoresSafeArea()
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [Color("Periwinkle").opacity(0.25), Color("Crayola Bleuet").opacity(0.65)]), startPoint: .top, endPoint: .bottom)
                                            .ignoresSafeArea())
                                    .overlay {
                                        VStack {
                                            Rectangle()
                                                .frame(width: 110, height: 10, alignment: .top)
                                                .cornerRadius(20)
                                                .opacity(0.35)
                                                .padding(.top, 20)
                                                
                                            Text(selectedCard?.title ?? "Идёт загрузка...")
                                                .font(.system(size: 27, weight: .heavy, design: .default))
                                                .padding()
                                        
                                            ScrollView {
                                                VStack {
                                                    Text(selectedCard?.description ?? "")
                                                        .font(.system(size: 20, weight: .light, design: .rounded))
                                                        .padding(.horizontal, 20)
                                            
                                                    Spacer()
                                                
                                                    Text("Помощь не бывает маленькой. Каждый поступок важен, а помощь — это всегда поступок")
                                                        .font(.system(size: 20, weight: .semibold, design: .serif))
                                                        .padding(.horizontal, 20)
                                                        .padding(.top, 20)
                                                }
                                            }
                                        }
                                        .padding()
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                HStack {
                    if isEditing {
                        TextField("Сменить имя...", text: $name)
                            .font(.title2)
                            .padding()
                    } else {
                        Text("Сменить имя...")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                self.isEditing = true
                            }
                            .padding()
                        
                        Spacer()
                    }
                    
                    if isEditing {
                        Button(action: {
                            UserDefaults.standard.set(name, forKey: "username")
                            self.isEditing = false
                        }) {
                            Text("Сохранить")
                        }
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                        .padding()
                    }
                }
                
                Button (
                    role: .destructive,
                    action: {
                        confirmationShown3 = true
                    }) {
                        Text("Удалить все задачи")
                    }
                    .confirmationDialog (
                        "Вы действительно хотите удалить все задачи?",
                        isPresented: $confirmationShown3,
                        titleVisibility: .visible) {
                            Button("Да") {
                                clearDatabase()
                            }
                            Button("Нет", role: .cancel) { }
                        }
                        .padding(.bottom, 50)
            }
        }
        .onAppear() {
            // Подсчёт накопленной суммы
            for task in tasks {
                if !task.isOverdue && !task.isDone && task.time!.toDate("dd MM yy HH:mm") < Date() {
                    
                    taskModel.editTask = task
                    taskModel.setupTask()
                    
                    taskModel.isOverdue = true
                    taskModel.addTask(context: env.managedObjectContext)
                    var res = UserDefaults.standard.integer(forKey: "sum") ?? 0
                    res += Int(task.cost)
                    self.sum += Int(task.cost)
                    UserDefaults.standard.set(res, forKey: "sum")
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { output in
        })
        .onTapGesture {
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
    }
    
    func clearDatabase() {
        for task in tasks {
            taskModel.editTask = task
            taskModel.setupTask()
            if let editTask = taskModel.editTask {
                env.managedObjectContext.delete(editTask)
                try? env.managedObjectContext.save()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


