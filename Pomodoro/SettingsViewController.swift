//
//  SettingsViewController.swift
//  Pomodoro
//
//  Created by Victor on 29/04/2021.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {

    @IBOutlet weak var focusSlider: UISlider!
    @IBOutlet weak var shortBreakSlider: UISlider!
    @IBOutlet weak var longBreakSlider: UISlider!
    @IBOutlet weak var setsSlider: UISlider!
    
    @IBOutlet weak var focusSliderValueLabel: UILabel!
    @IBOutlet weak var shortBreakSliderValueLabel: UILabel!
    @IBOutlet weak var longBreakSliderValueLabel: UILabel!
    @IBOutlet weak var setsSliderValueLabel: UILabel!
    
    var realm: Realm? = {
        do {
            let realm = try Realm()
            return realm
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    var settings = PomodoroSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let settingsArray = realm?.objects(PomodoroSettings.self) {
            if settingsArray.isEmpty {
                try! realm?.write {
                    realm?.add(settings)
                }
            }
        }
        
        setupSliders()
    }
    
    //MARK: - Prepare UI
   
    func setupSliders() {
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
    
    func Localize(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    //MARK: - Actions
    
    @IBAction func didTouchRestoreDefaultsButton(_ sender: Any) {
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
    }
    
    @IBAction func didTouchSaveButton(_ sender: Any) {
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
    
    //MARK: Sliders
    
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
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //MARK: Info Buttons
    
    @IBAction func didTouchFocusInfoButton(_ sender: Any) {
        let title = Localize(text: "Focus_info")
        let message = Localize(text: "Focus_info_message")
        showAlertWith(title: title, message: message)
    }
    @IBAction func didTouchShortBreakInfoButton(_ sender: Any) {
        let title = Localize(text: "Short_break_info")
        let message = Localize(text: "Short_break_info_message")
        showAlertWith(title: title, message: message)
    }
    @IBAction func didTouchLongBreakInfoButton(_ sender: Any) {
        let title = Localize(text: "Long_break_info")
        let message = Localize(text: "Long_break_info_message")
        showAlertWith(title: title, message: message)
    }
    @IBAction func didTouchSetsInfoButton(_ sender: Any) {
        let title = Localize(text: "Sets_info")
        let message = Localize(text: "Sets_info_message")
        showAlertWith(title: title, message: message)
    }
}
