//
//  CardView.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI

struct CardView: View {
    let name: String
    let description: String

    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .font(.system(size: 20, weight: .heavy, design: .default))
                    .padding()

                Spacer()
            }
            .padding(5)

            HStack {
                Text(description)
                    .padding(.horizontal, 15)

                Spacer()
            }
            .padding(.horizontal, 10)
            
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("Periwinkle").opacity(0.35), Color("Crayola Bleuet")]), startPoint: .leading, endPoint: .trailing).cornerRadius(10))
        .cornerRadius(20)
        .frame(width: 310, height: 210, alignment: .top)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(name: "Дом с маяком", description: "иоилиоиоио")
    }
}


