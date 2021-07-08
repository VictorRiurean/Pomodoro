//
//  SlidersTableViewCell.swift
//  Pomodoro
//
//  Created by Victor on 28/06/2021.
//

import UIKit
import RealmSwift

protocol ShowAlertProtocol {
    func showAlertWith(title: String, message: String)
    func reload()
}

class SlidersTableViewCell: UITableViewCell, RestoreDetailsProtocol, DidTouchSaveButtonProtocol {
   
    @IBOutlet weak var focusSlider: UISlider!
    @IBOutlet weak var shortBreakSlider: UISlider!
    @IBOutlet weak var longBreakSlider: UISlider!
    @IBOutlet weak var setsSlider: UISlider!
    
    @IBOutlet weak var focusSliderValueLabel: UILabel!
    @IBOutlet weak var shortBreakSliderValueLabel: UILabel!
    @IBOutlet weak var longBreakSliderValueLabel: UILabel!
    @IBOutlet weak var setsSliderValueLabel: UILabel!
    
    
    @IBOutlet weak var focusInfoButton: UIButton!
    @IBOutlet weak var shortBreakInfoButton: UIButton!
    @IBOutlet weak var longBreakInfoButton: UIButton!
    @IBOutlet weak var setsInfoButton: UIButton!
    
    var delegate: ShowAlertProtocol?
    
    var settings = PomodoroSettings()
    
    var realm: Realm? = {
        do {
            let realm = try Realm()
            return realm
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initial display
        self.backgroundColor = Colors.myVeryLightGray
        if let settingsArray = realm?.objects(PomodoroSettings.self) {
            if settingsArray.isEmpty {
                try! realm?.write {
                    realm?.add(settings)
                }
            }
        }
        setupSliders()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Prepare Sliders
    
    func setupSliders() {
        focusSlider.tintColor = Colors.myOrange
        shortBreakSlider.tintColor = Colors.myOrange
        longBreakSlider.tintColor = Colors.myOrange
        setsSlider.tintColor = Colors.myOrange
        if let settings = realm?.objects(PomodoroSettings.self)[0] {
            focusSlider.minimumValue = 10
            focusSlider.maximumValue = 50
            focusSlider.value = Float(settings.focus)
            focusSliderValueLabel.text = String(settings.focus)
            
            shortBreakSlider.minimumValue = 5
            shortBreakSlider.maximumValue = 20
            shortBreakSlider.value = Float(settings.shortBreak)
            shortBreakSliderValueLabel.text = String(settings.shortBreak)
            
            longBreakSlider.minimumValue = 10
            longBreakSlider.maximumValue = 30
            longBreakSlider.value = Float(settings.longBreak)
            longBreakSliderValueLabel.text = String(settings.longBreak)
            
            setsSlider.minimumValue = 1
            setsSlider.maximumValue = 10
            setsSlider.value = Float(settings.sets)
            setsSliderValueLabel.text = String(settings.sets)
        } else {
            focusSlider.minimumValue = 10
            focusSlider.maximumValue = 50
            focusSlider.value = Float(settings.focus)
            focusSliderValueLabel.text = String(settings.focus)
            
            shortBreakSlider.minimumValue = 5
            shortBreakSlider.maximumValue = 20
            shortBreakSlider.value = Float(settings.shortBreak)
            shortBreakSliderValueLabel.text = String(settings.shortBreak)
            
            longBreakSlider.minimumValue = 10
            longBreakSlider.maximumValue = 30
            longBreakSlider.value = Float(settings.longBreak)
            longBreakSliderValueLabel.text = String(settings.longBreak)
            
            setsSlider.minimumValue = 1
            setsSlider.maximumValue = 10
            setsSlider.value = Float(settings.sets)
            setsSliderValueLabel.text = String(settings.sets)
        }
    }
    
    //MARK: - Protocol Methods
    
    func didTouchSaveButton() {
        if let settings = realm?.objects(PomodoroSettings.self)[0] {
            try! realm!.write {
                settings.focus = Int(focusSlider.value)
                settings.shortBreak = Int(shortBreakSlider.value)
                settings.longBreak = Int(longBreakSlider.value)
                settings.sets = Int(setsSlider.value)
            }
            let notification = Notification(name: .settingsChanged, object: settings)
            NotificationCenter.default.post(notification)
        }
    }
    
    func restoreDetails() {
        if let settings = realm?.objects(PomodoroSettings.self)[0] {
            try! realm!.write {
                settings.focus = 25
                settings.shortBreak = 5
                settings.longBreak = 15
                settings.sets = 4
            }
            
            focusSlider.value = Float(settings.focus)
            focusSliderValueLabel.text = String(settings.focus)
            
            shortBreakSlider.value = Float(settings.shortBreak)
            shortBreakSliderValueLabel.text = String(settings.shortBreak)
            
            longBreakSlider.value = Float(settings.longBreak)
            longBreakSliderValueLabel.text = String(settings.longBreak)
            
            setsSlider.value = Float(settings.sets)
            setsSliderValueLabel.text = String(settings.sets)
        } else {
            try! realm!.write {
                settings.focus = 25
                settings.shortBreak = 5
                settings.longBreak = 15
                settings.sets = 4
            }
            
            focusSlider.value = Float(settings.focus)
            focusSliderValueLabel.text = String(settings.focus)
            
            shortBreakSlider.value = Float(settings.shortBreak)
            shortBreakSliderValueLabel.text = String(settings.shortBreak)
            
            longBreakSlider.value = Float(settings.longBreak)
            longBreakSliderValueLabel.text = String(settings.longBreak)
            
            setsSlider.value = Float(settings.sets)
            setsSliderValueLabel.text = String(settings.sets)
        }
        delegate?.reload()
    }
    
    func Localize(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    //MARK: - Sliders
    
    @IBAction func focusSliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        self.focusSliderValueLabel.text = String(value)
        self.focusSliderValueLabel.sizeToFit()
    }
    
    @IBAction func shortBreakSliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        self.shortBreakSliderValueLabel.text = String(value)
        self.shortBreakSliderValueLabel.sizeToFit()
    }
    
    @IBAction func longBreakSliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        self.longBreakSliderValueLabel.text = String(value)
        self.longBreakSliderValueLabel.sizeToFit()
    }
    
    @IBAction func setsSliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        self.setsSliderValueLabel.text = String(value)
        self.setsSliderValueLabel.sizeToFit()
    }
    
    //MARK: - Info Buttons
    
    @IBAction func didTouchFocusInfoButton(_ sender: Any) {
        let title = Localize(text: "Focus_info")
        let message = Localize(text: "Focus_info_message")
        delegate?.showAlertWith(title: title, message: message)
    }
    
    @IBAction func didTouchShortBreakInfoButton(_ sender: Any) {
        let title = Localize(text: "Short_break_info")
        let message = Localize(text: "Short_break_info_message")
        delegate?.showAlertWith(title: title, message: message)
    }
    
    @IBAction func didTouchLongBreakInfoButton(_ sender: Any) {
        let title = Localize(text: "Long_break_info")
        let message = Localize(text: "Long_break_info_message")
        delegate?.showAlertWith(title: title, message: message)
    }
    
    @IBAction func didTouchSetsInfoButton(_ sender: Any) {
        let title = Localize(text: "Sets_info")
        let message = Localize(text: "Sets_info_message")
        delegate?.showAlertWith(title: title, message: message)
    }
    
}
