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
    @IBOutlet weak var titleTip: UILabel!
}

class HowToUseAppViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var tips: [Tips] = [
        Tips(photo: UIImage(named: "struggling")!, text: "Tip_1", title: "Tip_title_1"),
        Tips(photo: UIImage(named: "settings")!, text: "Tip_2", title: "Tip_title_2"),
        Tips(photo: UIImage(named: "confused")!, text: "Tip_3", title: "Tip_title_3"),
        Tips(photo: UIImage(named: "statistics")!, text: "Tip_4", title: "Tip_title_4"),
        Tips(photo: UIImage(named: "forgot")!, text: "Tip_5", title: "Tip_title_5"),
        Tips(photo: UIImage(named: "deleted")!, text: "Tip_6", title: "Tip_title_6"),
        Tips(photo: UIImage(named: "FAQ")!, text: "Tip_7", title: "Tip_title_7")
    ]
    
    var currentPosition = 0
    
    var thisWidth:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.myVeryLightGray
        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = tips.count
        pageControl.backgroundStyle = .prominent
        pageControl.currentPageIndicatorTintColor = Colors.myGreen
        pageControl.isUserInteractionEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        if currentPosition == 0 {
            leftButton.isHidden = true
        }
    }
    
    //MARK: - Localization
    
    func Localize(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    //MARK: - Collection View
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionView.contentOffset.y ,width : self.collectionView.frame.width,height : self.collectionView.frame.height)
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as? HowToUseCollectionCell {
            cell.photoTip.image = tips[indexPath.section].photo
            cell.photoTip.clipsToBounds = true
            cell.textTip.text = Localize(text: tips[indexPath.section].text)
            cell.textTip.numberOfLines = 0
            cell.textTip.sizeToFit()
            cell.titleTip.text = Localize(text: tips[indexPath.section].title)
            cell.titleTip.clipsToBounds = true
            cell.titleTip.numberOfLines = 0
            cell.titleTip.font = .boldSystemFont(ofSize: 18)
            cell.titleTip.sizeToFit()
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
    //MARK: - Actions

    @IBAction func didTouchLeftButton(_ sender: Any) {
        if rightButton.isHidden == true {
            rightButton.isHidden = false
        }
        currentPosition -= 1
        if currentPosition == 0 {
            leftButton.isHidden = true
        }
        
        let collectionBounds = self.collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x - collectionBounds.size.width))
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
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
}
