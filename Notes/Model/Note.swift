//
//  Note.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import Foundation

struct NoteModel: Codable, Identifiable, Equatable {
    var id = UUID().uuidString
    var message: String
    var date: Date
    var color: String
}
