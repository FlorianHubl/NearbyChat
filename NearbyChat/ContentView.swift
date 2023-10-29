//
//  LocalStorageView.swift
//  NFCDemo
//
//  Created by Florian Hubl on 18.01.23.
//

import SwiftUI
import LocalStorage

struct Item: Codable, Identifiable, Equatable {
    var id = UUID()
    var i: Int
}

struct ContentView: View {
    
    @LocalStorage("Test") var storage = [Item]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(storage) { storage in
                    Text("\(storage.i)")
                }
                .onDelete { indexSet in
                    storage.remove(atOffsets: indexSet)
                }
            }
            Button("Add Object") {
                storage.append(Item(i: Int.random(in: 1...100)))
            }
            .navigationTitle("LocalStorage Demo")
        }
        .animation(.easeInOut, value: storage)
    }
}
