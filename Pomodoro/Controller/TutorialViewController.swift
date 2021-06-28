//
//  TutorialViewController.swift
//  Pomodoro
//
//  Created by Victor on 11/05/2021.
//

import UIKit

class TutorialViewController: UIViewController, CarouselViewDelegate {

    @IBOutlet weak var skipButton: UIButton!
    
    private var carouselView: CarouselView?
    private var carouselData = [CarouselView.CarouselData]()
    
    private let backgroundColors: [UIColor] = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.4826081395, green: 0.04436998069, blue: 0.2024421096, alpha: 1), #colorLiteral(red: 0.1728022993, green: 0.42700845, blue: 0.3964217603, alpha: 1)]
    
    let sawTutorialKey = "sawTutorialBool"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView = CarouselView(pages: 3, delegate: self)
        carouselData.append(.init(image: UIImage(named: "tomato"), text: Localize(text: "How_to_use_app_1")))
        carouselData.append(.init(image: UIImage(named: "tomato"), text: Localize(text: "How_to_use_app_2")))
        carouselData.append(.init(image: UIImage(named: "tomato"), text: Localize(text: "How_to_use_app_3")))
        
        setupUI()
    }
    
    //MARK: - Prepare UI
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView?.configureView(with: carouselData)
    }
    
    func setupUI() {
        view.backgroundColor = backgroundColors.first
        
        guard let carouselView = carouselView else {
            return
        }
        
        view.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        carouselView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        carouselView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        carouselView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.bringSubviewToFront(skipButton)
    }
    
    func Localize(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    //MARK: - Delegate
    
    func currentPageDidChange(to page: Int) {
        UIView.animate(withDuration: 0.7) {
            self.view.backgroundColor = self.backgroundColors[page]
        }
    }
    
    //MARK: - Actions
    
    @IBAction func didTouchSkipTutorialButton(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: sawTutorialKey)
        dismiss(animated: true, completion: nil)
    }
}
