//
//  ChatView.swift
//  ChatGPTDemo
//
//  Created by Florian Hubl on 10.01.23.
//

import SwiftUI
import MultiPeer
import PhotosUI

struct NearbyChatView: View {
    
    @State private var textfield = ""
    
    @StateObject var delegate = MPDelegate()
    
    @State private var cameraImage: UIImage? = nil
    
    @State private var showCamera: Bool = false
    
    @State private var imageSelection: PhotosPickerItem? = nil
    
    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    if delegate.devices.isEmpty == false {
                        Button {
                            showCamera = true
                        }label: {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                        }
                        .padding()
                    }
                    Spacer()
                    Text("NearbyChat")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(!delegate.devices.isEmpty ? .green : .accentColor)
                        .padding()
                    Spacer()
                    if delegate.devices.isEmpty == false {
                        PhotosPicker(selection: $imageSelection, matching: .images) {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                        }
                        .padding()
                        .onChange(of: imageSelection) { newValue in
                            imagePicked()
                        }
                    }
                }
                if delegate.devices.isEmpty == false {
                    Text("Connected:")
                    ForEach(delegate.devices, id: \.self) { item in
                        Text(item)
                            .onTapGesture {
                                focus = true
                            }
                    }
                }else {
                    ProgressView()
                        .padding()
                    Text("Connecting…")
                }
                Spacer()
                if delegate.devices.isEmpty == false {
                    ScrollViewReader { proxy in
                        ScrollView {
                            ForEach(delegate.chat, id: \.self) { item in
                                MessageView(message: item)
                                    .id(item.id)
                            }
                            .onChange(of: delegate.chat) { newValue in
                                guard delegate.chat.isEmpty == false else {return}
                                withAnimation {
                                    proxy.scrollTo(delegate.chat.last!.id)
                                }
                            }
                        }
                    }
                    TextField("Start chatting…", text: $textfield)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focus)
                        .padding()
                        .onSubmit {
                            send()
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("Send") {
                                    send()
                                }
                            }
                        }
                }
            }
        }
        .onAppear {
            start()
        }
        .sheet(isPresented: $showCamera) {
            MakePhotoView(image: $cameraImage)
                .ignoresSafeArea()
        }
        .animation(.spring(), value: delegate.chat)
        .animation(.easeInOut, value: delegate.devices)
        .onChange(of: cameraImage) { newValue in
            sendImage(newValue!)
        }
    }
    
    func sendImage(_ image: UIImage) {
        MultiPeer.instance.send(object: image.pngData()!, type: DataType.image.rawValue)
        delegate.chat.append(Message(image: image, myMessage: true))
    }
    
    func imagePicked() {
        print("Here")
        guard let imageSelection = imageSelection else {return}
        print("Here")
        imageSelection.loadTransferable(type: Data.self) { result in
            print("Here")
            guard imageSelection == self.imageSelection else { return }
            print("Here")
            switch result {
            case .success(let image):
                print("Here")
                let img = UIImage(data: image!)!
                sendImage(img)
            case .failure(let failure):
                print("Fail")
                print(failure.localizedDescription)
            }
        }
    }
    
    func send() {
        guard textfield.isEmpty == false else {return}
        MultiPeer.instance.send(object: textfield, type: DataType.text.rawValue)
        delegate.chat.append(Message(text: textfield, myMessage: true))
        textfield = ""
    }
    
    func update() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if delegate.chat.isEmpty == false && delegate.devices.isEmpty {
                delegate.chat = []
            }
        }
    }
    
    func start() {
        MultiPeer.instance.delegate = delegate
        MultiPeer.instance.initialize(serviceType: "chat-app")
        MultiPeer.instance.autoConnect()
        update()
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyChatView()
    }
}
