//
//  FAQTableViewCell.swift
//  Pomodoro
//
//  Created by Victor on 08/07/2021.
//

import UIKit

protocol RefreshProtocol {
    func refresh()
}

class FAQTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var showHideButton: UIButton!
    
    static let identifier = "FAQcellID"
    
    var section: Section?
    
    static func nib() -> UINib {
        return UINib(nibName: "FAQTableViewCell", bundle: nil)
    }
    
    var delegate: RefreshProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderColor = Colors.myVeryLightGray.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 8
        layer.shadowRadius = 10
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowColor = Colors.myVeryLightGray.cgColor
        answerLabel.isHidden = true
        
        questionLabel.font = .boldSystemFont(ofSize: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(section: Section) {
        self.section = section
        
        questionLabel.text = section.question
        answerLabel.text = section.answer
        
        let isOpen = section.isOpened
        answerLabel.isHidden = !isOpen
        
        if isOpen {
            showHideButton.setImage(UIImage(named: "substract"), for: .normal)
        } else {
            showHideButton.setImage(UIImage(named: "add"), for: .normal)
        }
    }
    
    @IBAction func didTouchShowHideButton(_ sender: Any) {
        guard let section = self.section else { return }
        
        answerLabel.isHidden = !section.isOpened
        
        if section.isOpened {
            showHideButton.setImage(UIImage(named: "substract"), for: .normal)
        } else {
            showHideButton.setImage(UIImage(named: "add"), for: .normal)
        }
        
        section.isOpened = !section.isOpened
        delegate?.refresh()
    }
    
}
