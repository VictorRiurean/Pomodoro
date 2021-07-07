//
//  SideMenu.swift
//  Pomodoro
//
//  Created by Victor on 29/04/2021.
//

import Foundation
import UIKit

protocol MenuControllerDelegateProtocol {
    func didSelectMenuItem(named: SideMenuItem)
}

enum SideMenuItem: String, CaseIterable {
    case home = "Home"
    case howToUseIt = "How to use app"
    case statistics = "Statistics"
    case FAQ = "FAQ"
    case settings = "Settings"
}

class MenuController: UITableViewController {
   
    public var delegate: MenuControllerDelegateProtocol?
    
    private let menuItems: [SideMenuItem]
    private let color = UIColor(displayP3Red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    
    init(with menuItems: [SideMenuItem]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        tableView.separatorColor = UIColor.clear
        view.backgroundColor = .white
    }
    
    //MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row].rawValue
        cell.textLabel?.font = UIFont(name: "Roboto-Black", size: 20)
        cell.textLabel?.textColor = Colors.myTextGray
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Relay to delegate about menu item selection
        
        let selectedItem = menuItems[indexPath.row]
        delegate?.didSelectMenuItem(named: selectedItem)
    }
}
