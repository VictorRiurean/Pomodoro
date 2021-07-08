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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchShowHideButton(_ sender: Any) {
        if answerLabel.isHidden {
            answerLabel.isHidden = false
            showHideButton.setImage(UIImage(named: "substract"), for: .normal)
            delegate?.refresh()
        } else {
            answerLabel.isHidden = true
            showHideButton.setImage(UIImage(named: "add"), for: .normal)
            delegate?.refresh()
        }
    }
    
}
