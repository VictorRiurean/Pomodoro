//
//  StatisticsViewController.swift
//  Pomodoro
//
//  Created by Victor on 29/04/2021.
//

import UIKit
import RealmSwift
import FSCalendar

class StatisticsViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet weak var generalStatisticsLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var generalStatisticsView: UIView!
    @IBOutlet weak var focusSessionsLabel: UILabel!
    @IBOutlet weak var focusHoursLabel: UILabel!
    @IBOutlet weak var pomodorosLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var perDayStatisticsView: UIView!
    @IBOutlet weak var perDayTitleLabel: UILabel!
    @IBOutlet weak var perDayFocusSessionsLabel: UILabel!
    @IBOutlet weak var perDayPomodorosLabel: UILabel!
    @IBOutlet weak var statisticsByDayLabel: UILabel!
    @IBOutlet weak var subtitleByDayLabel: UILabel!
    
    var hours = 0.0
    var pomodorosCount = 0
    var focusSessionsCount = 0
    
    var realm: Realm? = {
        do {
            let realm = try Realm()
            return realm
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.myVeryLightGray
        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        generalStatisticsView.layer.cornerRadius = 10
        perDayStatisticsView.layer.cornerRadius = 10
        calendar.layer.cornerRadius = 10
        perDayStatisticsView.isHidden = true
        calendar.delegate = self
        subscribeToNotificationsFromHome()
        updateLabels()
    }
    
    func updateLabels() {
        let pomodoros = realm?.objects(Pomodoro.self)
        let focusSessions = realm?.objects(FocusSession.self)
        
        focusSessionsLabel.text = "\(Localize(text: "Focus_sessions")): \(focusSessions?.count ?? 0)"
        focusSessionsLabel.sizeToFit()
        if let count = focusSessions?.count, let sessions = focusSessions {
            for i in 0..<count {
                hours += Double(sessions[i].sessionLength)
            }
        }
        let hours2Decimals = String(format: "%.2f", hours / 3600)
        hours = 0
        focusHoursLabel.text = "\(Localize(text: "Focus_hours")): \(hours2Decimals)"
        focusHoursLabel.sizeToFit()
        pomodorosLabel.text = "\(Localize(text: "Pomodoros")): \(pomodoros?.count ?? 0)"
        pomodorosLabel.sizeToFit()
        
        generalStatisticsLabel.text = "\(Localize(text: "General_statistics"))"
        generalStatisticsLabel.textColor = Colors.myOrange
        generalStatisticsLabel.font = .boldSystemFont(ofSize: 22)
        noteLabel.text = "\(Localize(text: "General_statistics_note"))"
        statisticsByDayLabel.text = "\(Localize(text: "Statistics_by_day"))"
        statisticsByDayLabel.textColor = Colors.myOrange
        statisticsByDayLabel.font = .boldSystemFont(ofSize: 22)
        subtitleByDayLabel.text = "\(Localize(text: "Statistics_by_day_note"))"
    }
    
    func Localize(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    //MARK: - Statistics Notifications
    
    func subscribeToNotificationsFromHome() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveStatistics(notification:)), name: .statisticsUpdated, object: nil)
    }
    
    @objc func didReceiveStatistics(notification: Notification) {
        updateLabels()
    }
    
    //MARK: - Calendar
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        let selectedDateString = formatter.string(from: date)
        
        let pomodoros = realm?.objects(Pomodoro.self)
        let focusSessions = realm?.objects(FocusSession.self)
        
        if let count = pomodoros?.count {
            for i in 0..<count {
                if let pomodoroDate = pomodoros?[i].date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM-dd-YYYY"
                    let pomodoroDateString = formatter.string(from: pomodoroDate)
                    if pomodoroDateString == selectedDateString {
                        pomodorosCount += 1
                    }
                }
            }
        }
        if let count = focusSessions?.count {
            for i in 0..<count {
                if let focusSessionDate = focusSessions?[i].date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM-dd-YYYY"
                    let focusSessionDateString = formatter.string(from: focusSessionDate)
                    if focusSessionDateString == selectedDateString {
                        focusSessionsCount += 1
                    }
                }
            }
        }
      
        if perDayStatisticsView.isHidden {
            perDayStatisticsView.isHidden = false
        }
        
        perDayTitleLabel.text = "\(Localize(text: "Statistics_for_date")) \(selectedDateString)"
        perDayTitleLabel.textColor = Colors.myOrange
        perDayTitleLabel.font = .boldSystemFont(ofSize: 18)
        perDayFocusSessionsLabel.text = "\(Localize(text: "Focus_sessions_completed")): \(focusSessionsCount)"
        perDayPomodorosLabel.text = "\(Localize(text: "Pomodoros_completed")): \(pomodorosCount)"

        pomodorosCount = 0
        focusSessionsCount = 0
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
