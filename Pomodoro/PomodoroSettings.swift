//
//  PomodoroSettings.swift
//  Pomodoro
//
//  Created by Victor on 30/04/2021.
//

import UIKit
import RealmSwift

class PomodoroSettings: Object {
    @objc dynamic var focus = 25
    @objc dynamic var shortBreak = 5
    @objc dynamic var longBreak = 15
    @objc dynamic var sets = 4
}

class FocusSession: Object {
    @objc dynamic var sessionLength = 0
    @objc dynamic var date: Date?
}

class Pomodoro: Object {
    @objc dynamic var sessions = 0
    @objc dynamic var pomodoroLength = 0
    @objc dynamic var date: Date?
}
