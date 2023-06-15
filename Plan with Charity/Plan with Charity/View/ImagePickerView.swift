//
//  ImagePickerView.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 03.06.2023.
//

import SwiftUI

struct Avatar: Identifiable {
    var id: String?
    var name: String
}

struct ImagePickerView: View {
    @Binding var image: Image?
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .frame(width: 110, height: 10, alignment: .top)
                .cornerRadius(20)
                .opacity(0.35)
                
            HStack {
                let avatars = [Avatar(id: "1", name: "ProfilePhoto"), Avatar(id: "2", name: "ProfilePhoto-1"), Avatar(id: "3", name: "ProfilePhoto-2")]
                
                ForEach(avatars) { avatar in
                    ZStack {
                        Image(avatar.name)
                            .resizable()
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding(10)
                            .onTapGesture {
                                image = Image(avatar.name)
                                UserDefaults.standard.set(avatar.name, forKey: "photo")
                            }
                        
                        if avatar.name == UserDefaults.standard.string(forKey: "photo") {
                            ZStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 25))
                            }
                            .offset(x: 40, y: 40)
                        }
                    }
                }
            }
            
            HStack {
                let avatars2 = [Avatar(id: "4", name: "ProfilePhoto-3"), Avatar(id: "5", name: "ProfilePhoto-4"), Avatar(id: "6", name: "ProfilePhoto-5")]
                
                ForEach(avatars2) { avatar in
                    ZStack {
                        Image(avatar.name)
                            .resizable()
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding(10)
                            .onTapGesture {
                                image = Image(avatar.name)
                                UserDefaults.standard.set(avatar.name, forKey: "photo")
                            }
                        
                        if avatar.name == UserDefaults.standard.string(forKey: "photo") {
                            ZStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 25))
                            }
                            .offset(x: 40, y: 40)
                        }
                    }
                }
            }
            
            HStack {
                let avatars3 = [Avatar(id: "7", name: "ProfilePhoto-6"), Avatar(id: "8", name: "ProfilePhoto-7"), Avatar(id: "9", name: "ProfilePhoto-8")]
                
                ForEach(avatars3) { avatar in
                    ZStack {
                        Image(avatar.name)
                            .resizable()
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding(10)
                            .onTapGesture {
                                image = Image(avatar.name)
                                UserDefaults.standard.set(avatar.name, forKey: "photo")
                            }
                        
                        if avatar.name == UserDefaults.standard.string(forKey: "photo") {
                            ZStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 25))
                            }
                            .offset(x: 40, y: 40)
                        }
                    }
                }
            }
            
            HStack {
                let avatars4 = [Avatar(id: "10", name: "ProfilePhoto-9"), Avatar(id: "11", name: "ProfilePhoto-10")]
                
                ForEach(avatars4) { avatar in
                    ZStack {
                        Image(avatar.name)
                            .resizable()
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding(10)
                            .onTapGesture {
                                image = Image(avatar.name)
                                UserDefaults.standard.set(avatar.name, forKey: "photo")
                            }
                        
                        if avatar.name == UserDefaults.standard.string(forKey: "photo") {
                            ZStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 25))
                            }
                            .offset(x: 40, y: 40)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    @State static var image: Image? = Image("ProfilePhoto")
    
    static var previews: some View {
        ImagePickerView(image: $image)
    }
}
