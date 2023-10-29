//
//  MessageView.swift
//  ChatGPTDemo
//
//  Created by Florian Hubl on 10.01.23.
//

import SwiftUI

struct MessageView: View {
    
    @State private var wannaSave = false
    
    let message: Message
    
    
    var body: some View {
        HStack {
            if message.myMessage {
                Spacer()
            }
            if message.type == .text {
                Text(message.text!)
                    .foregroundColor(message.myMessage ? .black : .white)
                    .background {
                        RoundedRectangle(cornerRadius: 11)
                            .foregroundColor(message.myMessage ? .white : .black)
                            .shadow(radius: 11)
                            .padding(-10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
            }else {
                Image(uiImage: message.image!)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(7)
                    .background {
                        RoundedRectangle(cornerRadius: 11)
                            .foregroundColor(message.myMessage ? .white : .black)
                            .shadow(radius: 11)
                            .padding(-10)
                    }
                    .padding(message.myMessage ? .leading : .trailing, 70)
                    .padding(message.myMessage ? .trailing : .leading, 21)
                    .padding(.vertical, 10)
//                    .onLongPressGesture {
//                        wannaSave = true
//                    }
//                    .confirmationDialog("Do you want to save this Image?", isPresented: $wannaSave, titleVisibility: .visible
//                    ) {
//                        Button("Save") {
////                            savePhoto(message.image!)
//                        }
//                    }
            }
            if message.myMessage == false {
                Spacer()
            }
        }
    }
    
    func savePhoto(_ image: UIImage) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
