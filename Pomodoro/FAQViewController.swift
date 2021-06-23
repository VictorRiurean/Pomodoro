//
//  FAQViewController.swift
//  Pomodoro
//
//  Created by Victor on 29/04/2021.
//

import UIKit

class Section {
    let question: String
    let answer: String
    var isOpened: Bool = false
    
    init(question: String,
         answer: String,
         isOpened: Bool = false) {
        self.question = question
        self.answer = answer
        self.isOpened = isOpened
    }
}

class FAQViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        sections = [
            Section(question: Localize(text: "Question_1"), answer: Localize(text: "Answer_1")),
            Section(question: Localize(text: "Question_2"), answer: Localize(text: "Answer_2")),
            Section(question: Localize(text: "Question_3"), answer: Localize(text: "Answer_3")),
            Section(question: Localize(text: "Question_4"), answer: Localize(text: "Answer_4"))
        ]
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    func Localize(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    //MARK: - Table View
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = sections[indexPath.section].question
        } else {
            cell.textLabel?.text = sections[indexPath.section].answer
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .none)
    }
}
