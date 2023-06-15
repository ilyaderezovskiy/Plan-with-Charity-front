//
//  AuthView.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI

struct AuthView: View {
    @State var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var showCalendarView = false
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 0)
                .foregroundColor(.blue)
                .opacity(0.3)
            Spacer()
        }
        .onAppear() {
            if UserDefaults.standard.bool(forKey: "isLogin") {
                self.showCalendarView.toggle()
            }
        }
        .ignoresSafeArea()
            .background(Image("bg")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
                .opacity(0.7)
            )
            .overlay {
                VStack(spacing: 20) {
                    Spacer()
                    
                    TextField("Введите ваше имя", text: $username)
                        .padding()
                        .background(Color("White"))
                        .cornerRadius(15)
                        .padding(.top, 130)
                    
                    // Кнопка авторизации пользователя
                    Button {
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(0, forKey: "sum")
                        UserDefaults.standard.set(0, forKey: "passed")
                        UserDefaults.standard.set(true, forKey: "isLogin")
                        UserDefaults.standard.set("ProfilePhoto", forKey: "photo")
                        self.showCalendarView.toggle()
                    } label: {
                        Text("Начать")
                    }.frame(maxWidth: .infinity)
                        .padding()
                        .background(.brown)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.bottom, 170)
                }.padding(.horizontal, 40)
            }
            .fullScreenCover(isPresented: $showCalendarView) {
                CalendarView(showCalendarView: $showCalendarView)
            }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}

