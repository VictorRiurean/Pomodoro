//
//  SettingsViewController.swift
//  Pomodoro
//
//  Created by Victor on 29/04/2021.
//

import UIKit
import RealmSwift

protocol DidTouchSaveButtonProtocol {
    func didTouchSaveButton()
}

class SettingsViewController: UIViewController, ShowAlertProtocol, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: DidTouchSaveButtonProtocol?
    
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

        view.backgroundColor = Colors.myVeryLightGray
        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        let nib = UINib(nibName: "InfoRestoreDetailsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "infoCellID")
        let nib1 = UINib(nibName: "SlidersTableViewCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "slidersCellID")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        tableView.separatorColor = .clear
        tableView.backgroundColor = Colors.myVeryLightGray
        
        saveButton.setTitleColor(Colors.myOrange, for: .normal)
    }
    
    func Localize(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    //MARK: - Protocol Methods
    
    func reload() {
        tableView.reloadData()
    }
    
    func showAlertWith(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCellID") as? InfoRestoreDetailsTableViewCell, let slidersCell = tableView.dequeueReusableCell(withIdentifier: "slidersCellID") as? SlidersTableViewCell else {
            return UITableViewCell()
        }
        
        infoCell.delegate = slidersCell
        slidersCell.delegate = self
        self.delegate = slidersCell
        
        if indexPath.row == 0 {
            infoCell.textLabel?.text = "Info"
            infoCell.restoreDetailsButton.setTitleColor(Colors.myOrange, for: .normal)
            return infoCell
        } else {
            slidersCell.focusInfoButton.setTitleColor(.link, for: .normal)
            slidersCell.shortBreakInfoButton.setTitleColor(.link, for: .normal)
            slidersCell.longBreakInfoButton.setTitleColor(.link, for: .normal)
            slidersCell.setsInfoButton.setTitleColor(.link, for: .normal)
            return slidersCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 600
        }
        return 50
    }
    
    //MARK: - Actions
    
    @IBAction func didTouchSaveButton(_ sender: Any) {
        delegate?.didTouchSaveButton()
    }
}
