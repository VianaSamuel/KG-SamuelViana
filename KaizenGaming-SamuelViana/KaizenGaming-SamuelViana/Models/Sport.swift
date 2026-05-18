//
//  Sport.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import Foundation

struct Sport: Codable {
    let id: String
    let name: String
    var events: [Event]

    enum CodingKeys: String, CodingKey {
        case id = "i"
        case name = "d"
        case events = "e"
    }
}
