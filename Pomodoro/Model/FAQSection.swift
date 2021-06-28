//
//  FAQSection.swift
//  Pomodoro
//
//  Created by Victor on 27/06/2021.
//

import Foundation

class Section {
    let question: String
    let answer: String
    var isOpened: Bool = false
    
    init(question: String, answer: String, isOpened: Bool = false) {
        self.question = question
        self.answer = answer
        self.isOpened = isOpened
    }
}
