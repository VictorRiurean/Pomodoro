//
//  TutorialViewController.swift
//  Pomodoro
//
//  Created by Victor on 11/05/2021.
//

import UIKit

class TutorialViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skipButton: UIButton!
    
    var tips: [Tips] = [
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1"),
        Tips(photo: UIImage(named: "tomato")!, text: "Tip number 1")]
    
    let sawTutorialKey = "sawTutorialBool"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - Collection View
    
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
    
    //MARK: - Actions
    
    @IBAction func didTouchSkipTutorialButton(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: sawTutorialKey)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTouchLeftButton(_ sender: Any) {
        let collectionBounds = self.collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x - 10 - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    @IBAction func didTouchRightButton(_ sender: Any) {
        let collectionBounds = self.collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x + 10 + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
}
