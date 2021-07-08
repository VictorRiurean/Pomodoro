//
//  FAQViewController.swift
//  Pomodoro
//
//  Created by Victor on 29/04/2021.
//

import UIKit

class FAQViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RefreshProtocol {
   
    @IBOutlet weak var tableView: UITableView!

    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.myVeryLightGray
        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        self.view.backgroundColor = Colors.myVeryLightGray
        sections = [
            Section(question: Localize(text: "Question_1"), answer: Localize(text: "Answer_1")),
            Section(question: Localize(text: "Question_2"), answer: Localize(text: "Answer_2")),
            Section(question: Localize(text: "Question_3"), answer: Localize(text: "Answer_3")),
            Section(question: Localize(text: "Question_4"), answer: Localize(text: "Answer_4")),
            Section(question: Localize(text: "Question_5"), answer: Localize(text: "Answer_5")),
            Section(question: Localize(text: "Question_6"), answer: Localize(text: "Answer_6")),
            Section(question: Localize(text: "Question_7"), answer: Localize(text: "Answer_7"))
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FAQTableViewCell.nib(), forCellReuseIdentifier: FAQTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }
    
    func Localize(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FAQTableViewCell.identifier, for: indexPath) as? FAQTableViewCell {
            cell.questionLabel.text = sections[indexPath.row].question
            cell.questionLabel.font = .boldSystemFont(ofSize: 18)
            cell.answerLabel.text = sections[indexPath.row].answer
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}
