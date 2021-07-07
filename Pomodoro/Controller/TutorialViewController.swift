//
//  TutorialViewController.swift
//  Pomodoro
//
//  Created by Victor on 11/05/2021.
//

import UIKit

class TutorialViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
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
    
    let sawTutorialKey = "sawTutorialBool"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        collectionView.register(PhotoTitleSubtitleCollectionViewCell.nib(), forCellWithReuseIdentifier: PhotoTitleSubtitleCollectionViewCell.identifier)
        
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = tips.count
        pageControl.backgroundStyle = .prominent
        pageControl.currentPageIndicatorTintColor = Colors.myGreen
        pageControl.isUserInteractionEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if currentPosition == 0 {
            leftButton.isHidden = true
        }
        skipButton.setTitleColor(Colors.myOrange, for: .normal)
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoTitleSubtitleCollectionViewCell.identifier, for: indexPath) as? PhotoTitleSubtitleCollectionViewCell {
            cell.photoTip.image = tips[indexPath.section].photo
            cell.photoTip.clipsToBounds = true
            cell.textTip.text = Localize(text: tips[indexPath.section].text)
            cell.textTip.numberOfLines = 0
            cell.textTip.sizeToFit()
            cell.titleTip.text = Localize(text: tips[indexPath.section].title)
            cell.titleTip.clipsToBounds = true
            cell.titleTip.numberOfLines = 4
            cell.titleTip.font = .boldSystemFont(ofSize: 18)
            cell.titleTip.sizeToFit()
            
            if indexPath.section % 2 == 0 {
                cell.backgroundColor = .red
            } else {
                cell.backgroundColor = .blue
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGRect = collectionView.bounds
        let width = size.width
        let height = size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
    //MARK: - Actions
    
    @IBAction func didTouchSkipTutorialButton(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: sawTutorialKey)
        dismiss(animated: true, completion: nil)
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
