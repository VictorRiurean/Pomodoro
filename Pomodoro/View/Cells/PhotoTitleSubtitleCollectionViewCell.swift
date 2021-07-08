//
//  PhotoTitleSubtitleCollectionViewCell.swift
//  Pomodoro
//
//  Created by Victor on 07/07/2021.
//

import UIKit

class PhotoTitleSubtitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoTip: UIImageView!
    @IBOutlet weak var titleTip: UILabel!
    @IBOutlet weak var textTip: UILabel!
    
    static let identifier = "photoTitleSubtitleCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "PhotoTitleSubtitleCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
