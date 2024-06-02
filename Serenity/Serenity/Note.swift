//
//  Note.swift
//  Serenity
//
//  Created by 이하은 on 6/1/24.
//

import Foundation

struct Note {
    var date: Date
    var text: String
}

class NotesDataManager {
    static let shared = NotesDataManager()
    private var notes = [Note]()
    
    private init() {}
    
    func getNoteForDate(_ date: Date) -> Note? {
        return notes.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
    }
    
    func saveNoteForDate(_ date: Date, text: String) {
        if let index = notes.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            notes[index].text = text
        } else {
            notes.append(Note(date: date, text: text))
        }
    }
}
