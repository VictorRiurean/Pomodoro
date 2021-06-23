//
//  HowToUseAppViewController.swift
//  Pomodoro
//
//  Created by Victor on 29/04/2021.
//

import UIKit

class HowToUseAppViewController: UIViewController {
    
    private var carouselView: CarouselView?
    private var carouselData = [CarouselView.CarouselData]()
    
    private let backgroundColors: [UIColor] = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.4826081395, green: 0.04436998069, blue: 0.2024421096, alpha: 1), #colorLiteral(red: 0.1728022993, green: 0.42700845, blue: 0.3964217603, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView = CarouselView(pages: 3, delegate: self)
        carouselData.append(.init(image: UIImage(named: "tomato"), text: Localize(text: "How_to_use_app_1")))
        carouselData.append(.init(image: UIImage(named: "tomato"), text: Localize(text: "How_to_use_app_2")))
        carouselData.append(.init(image: UIImage(named: "tomato"), text: Localize(text: "How_to_use_app_3")))
        
        setupUI()
    }
    
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
    }
    
    func Localize(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
}

    // MARK: - CarouselViewDelegate

extension HowToUseAppViewController: CarouselViewDelegate {
    func currentPageDidChange(to page: Int) {
        UIView.animate(withDuration: 0.7) {
            self.view.backgroundColor = self.backgroundColors[page]
        }
    }
}
