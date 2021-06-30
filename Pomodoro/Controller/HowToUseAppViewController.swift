//
//  HowToUseAppViewController.swift
//  Pomodoro
//
//  Created by Victor on 29/04/2021.
//

import UIKit

class HowToUseCollectionCell: UICollectionViewCell {
    @IBOutlet weak var photoTip: UIImageView!
    @IBOutlet weak var textTip: UILabel!
}

class HowToUseAppViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var tips: [Tips] = [
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1")]
    
    var currentPosition = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
    }
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if currentPosition == 0 {
            leftButton.isHidden = true
        }
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {

        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionView.contentOffset.y ,width : self.collectionView.frame.width,height : self.collectionView.frame.height)
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as? HowToUseCollectionCell {
            cell.photoTip.image = tips[indexPath.row].photo
            cell.textTip.text = tips[indexPath.row].text
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = collectionView.bounds
        let width = screenSize.width
        let height = screenSize.height
        return CGSize(width: width, height: height)
    }
    
    @IBAction func didTouchLeftButton(_ sender: Any) {
        if rightButton.isHidden == true {
            rightButton.isHidden = false
        }
        currentPosition -= 1
        if currentPosition == 0 {
            leftButton.isHidden = true
        }
        
        let collectionBounds = self.collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x - 10 - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    @IBAction func didTouchRightButton(_ sender: Any) {
        if leftButton.isHidden == true {
            leftButton.isHidden = false
        }
        currentPosition += 1
        if currentPosition == tips.count - 1 {
            rightButton.isHidden = true
        }
        
        let collectionBounds = self.collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x + 10 + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
}
