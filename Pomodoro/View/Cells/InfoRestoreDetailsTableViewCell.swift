//
//  InfoRestoreDetailsTableViewCell.swift
//  Pomodoro
//
//  Created by Victor on 28/06/2021.
//

import UIKit

protocol RestoreDetailsProtocol: AnyObject {
    func restoreDetails()
}

class InfoRestoreDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var restoreDetailsButton: UIButton!
    
    var delegate: RestoreDetailsProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = Colors.myVeryLightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchRestoreDetailsButton(_ sender: Any) {
        delegate?.restoreDetails()
    }
}
