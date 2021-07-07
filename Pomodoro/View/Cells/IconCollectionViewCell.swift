//
//  IconCollectionViewCell.swift
//  Pomodoro
//
//  Created by Victor on 06/07/2021.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    static let identifier = "iconCollectionViewCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "IconCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
