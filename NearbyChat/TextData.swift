//
//  TextData.swift
//  NearbyChat
//
//  Created by Florian Hubl on 24.01.23.
//

import Foundation

struct TextData: Codable, Identifiable, Equatable {
    let id: Int
    let text: String
}

struct PhotoData: Codable, Identifiable, Equatable {
    let id: Int
    let url: String
}

typealias ManyTextData = [TextData]
