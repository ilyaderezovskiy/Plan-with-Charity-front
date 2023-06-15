//
//  ReportView.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 06.06.2023.
//

import SwiftUI

struct ReportView: View {
    @State var image: Image? = Image(UserDefaults.standard.string(forKey: "photo") ?? "ProfilePhoto" )
    
    var body: some View {
        VStack {
            ZStack {
                image!
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(20)
                
                Text("👋")
                    .font(.system(size: 45))
                    .shadow(color: .white, radius: 6)
                    .offset(x: -55, y: 55)
            }
            
            HStack {
                Text(UserDefaults.standard.string(forKey: "username") ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                    .offset(x: 5, y: -14)
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.blue)
                    .offset(x: 5, y: -10)
            }
            
            Text("Хэй! Я уже участвую в системной благотворительности - помогаю фондам регулярными денежными переводами! Совершать регулярную помощь проще, если её планировать.")
                .font(.system(size: 20, weight: .light, design: .default))
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Присоединяйся! Давай помогать вместе!")
                .font(.system(size: 18, weight: .light, design: .default))
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            Text("Plan with Charity")
                .font(.system(size: 25, weight: .heavy, design: .default))
            
            Text("Планируй, помогая!")
                .padding(.bottom)
        }
        .padding(.top, 40)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
