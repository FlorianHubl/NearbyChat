//
//  MultiPeerDelegate.swift
//  MultipeerConnectivityDemo
//
//  Created by Florian Hubl on 01.04.22.
//

import MultiPeer
import SwiftUI

enum DataType: UInt32 {
    case text = 1
    case image = 2
}

struct Message: Hashable, Equatable, Identifiable {
    
    enum type {
        case text
        case image
    }
    
    let id = UUID()
    let type: type
    let text: String?
    let image: UIImage?
    let myMessage: Bool
    
    init(text: String, myMessage: Bool) {
        self.type = .text
        self.text = text
        self.myMessage = myMessage
        self.image = nil
    }
    
    init(image: UIImage, myMessage: Bool) {
        self.type = .image
        self.text = nil
        self.myMessage = myMessage
        self.image = image
    }
}


class MPDelegate: MultiPeerDelegate, ObservableObject {
    @Published var chat = [Message]()
    @Published var devices = [String]()
    
    func multiPeer(didReceiveData data: Data, ofType type: UInt32, from peerID: MCPeerID) {
        print("didReceiveData:")
        print(data)
      switch type {
        case DataType.text.rawValue:
          let a = data.convert() as! String
          print(a)
          chat.append(Message(text: a, myMessage: false))
          break
                  
        case DataType.image.rawValue:
          print("Img")
          guard let imageData = data.convert() as? Data else { return }
          guard let image = UIImage(data: imageData) else {
              print("error")
              return
          }
          print("Img")
          self.chat.append(Message(image: image, myMessage: false))
          print(chat)
          print("Img")
          break
                  
        default:
          break
      }
    }

    func multiPeer(connectedDevicesChanged devices: [String]) {
        self.devices = devices
    }
}
