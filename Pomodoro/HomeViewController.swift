//
//  ViewController.swift
//  Pomodoro
//
//  Created by Victor on 29/04/2021.
//

import UIKit
import SideMenu
import RealmSwift

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MenuControllerDelegateProtocol {
   
    @IBOutlet weak var minutesLeftLabel: UILabel!
    @IBOutlet weak var secondsLeftLabel: UILabel!
    @IBOutlet weak var enjoyBreakLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var sideMenu: SideMenuNavigationController?
    
    private var settingsController: SettingsViewController? = nil
    private var statisticsController: StatisticsViewController? = nil
    private var FAQController: FAQViewController? = nil
    private var howToUseAppController: HowToUseAppViewController? = nil
    
    var animationAdded: Bool = false
   
    var realm: Realm? = {
        do {
            let realm = try Realm()
            return realm
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    var settings = PomodoroSettings()
    
    var timer: Timer!
    var timeRemaining = 0
    var sessionsLeft = 0
    var sessions = 0
    var sessionLength = 0
    var shortPauseLength = 0
    var longPauseLength = 0
    var isPauseTime = false
    var animationPause = false
    
    let shape = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    let defaults = UserDefaults.standard
    let sawTutorialKey = "sawTutorialBool"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        enjoyBreakLabel.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        playButton.addTarget(self, action: #selector(didTouchPlayButton), for: .touchUpInside)
       
        drawShapes()
        subscribeToNotificationsFromSettings()
        setupMenuController()
        addChildControllers()
        setupTimer()
        
        let sawTutorial = defaults.bool(forKey: sawTutorialKey)
        if !sawTutorial {
            if let vc = storyboard?.instantiateViewController(identifier: "tutorialVC") as? TutorialViewController {
                navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func drawShapes() {
        let circlePath = UIBezierPath(arcCenter: view.center,
                                      radius: 150,
                                      startAngle: -(.pi / 2),
                                      endAngle: .pi * 3 / 2,
                                      clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 15
        trackShape.strokeColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(trackShape)
        
        shape.path = circlePath.cgPath
        shape.lineWidth = 15
        shape.strokeColor = UIColor.blue.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        shape.lineCap = .round
        view.layer.addSublayer(shape)
    }
    
    //MARK: - Setup menu
    
    private func setupMenuController() {
        let menu = MenuController(with: SideMenuItem.allCases)
        menu.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        
        settingsController = storyboard?.instantiateViewController(identifier: "settingsVC") as? SettingsViewController
        howToUseAppController = storyboard?.instantiateViewController(identifier: "howToUseAppVC") as? HowToUseAppViewController
        FAQController = storyboard?.instantiateViewController(identifier: "FAQVC") as? FAQViewController
        statisticsController = storyboard?.instantiateViewController(identifier: "statisticsVC") as? StatisticsViewController
    }
    
    private func addChildControllers() {
        guard let settingsController = settingsController, let statisticsController = statisticsController, let FAQController = FAQController, let howToUseAppController = howToUseAppController else {
            return
        }
        addChild(settingsController)
        addChild(howToUseAppController)
        addChild(FAQController)
        addChild(statisticsController)
       
        view.addSubview(settingsController.view)
        view.addSubview(howToUseAppController.view)
        view.addSubview(FAQController.view)
        view.addSubview(statisticsController.view)
        
        settingsController.view.frame = view.bounds
        howToUseAppController.view.frame = view.bounds
        FAQController.view.frame = view.bounds
        statisticsController.view.frame = view.bounds
        
        settingsController.didMove(toParent: self)
        howToUseAppController.didMove(toParent: self)
        FAQController.didMove(toParent: self)
        statisticsController.didMove(toParent: self)
        
        settingsController.view.isHidden = true
        howToUseAppController.view.isHidden = true
        FAQController.view.isHidden = true
        statisticsController.view.isHidden = true
    }
    
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
        
        self.title = named.rawValue
        
        switch named {
        case .home:
            settingsController?.view.isHidden = true
            howToUseAppController?.view.isHidden = true
            FAQController?.view.isHidden = true
            statisticsController?.view.isHidden = true
        case .howToUseIt:
            settingsController?.view.isHidden = true
            howToUseAppController?.view.isHidden = false
            FAQController?.view.isHidden = true
            statisticsController?.view.isHidden = true
        case .statistics:
            settingsController?.view.isHidden = true
            howToUseAppController?.view.isHidden = true
            FAQController?.view.isHidden = true
            statisticsController?.view.isHidden = false
        case .FAQ:
            settingsController?.view.isHidden = true
            howToUseAppController?.view.isHidden = true
            FAQController?.view.isHidden = false
            statisticsController?.view.isHidden = true
        case .settings:
            settingsController?.view.isHidden = false
            howToUseAppController?.view.isHidden = true
            FAQController?.view.isHidden = true
            statisticsController?.view.isHidden = true
        }
    }
    
    //MARK: - Timer
    
    func setupTimer() {
        if let settings = self.realm?.objects(PomodoroSettings.self)[0] {
            timeRemaining = settings.focus * 60
            sessionsLeft = settings.sets
            sessions = sessionsLeft
            sessionLength = settings.focus * 60
            shortPauseLength = settings.shortBreak * 60
            longPauseLength = settings.longBreak * 60
        }
        
        minutesLeftLabel.text = "\(timeRemaining / 60)"
        secondsLeftLabel.text = "0"
        
        pauseButton.isHidden = true
        stopButton.isHidden = true
    }
    
    @objc func step() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            if !isPauseTime {
                enjoyBreakLabel.isHidden = false
                
                sessionsLeft -= 1
                isPauseTime = !isPauseTime
                
                let session = FocusSession()
                let date = Date()
                session.date = date
                session.sessionLength = sessionLength
                
                try! realm!.write {
                    realm?.add(session)
                }

                let notification = Notification(name: .statisticsUpdated)
                NotificationCenter.default.post(notification)
                
                if sessionsLeft == 0 {
                    timeRemaining = longPauseLength
                } else {
                    timeRemaining = shortPauseLength
                }
                
                animation.toValue = 1
                animation.duration = Double(timeRemaining / 100)
                animation.isRemovedOnCompletion = true
                animation.fillMode = .forwards
                shape.add(animation, forKey: "animation")
            } else {
                enjoyBreakLabel.isHidden = true
                
                isPauseTime = !isPauseTime
                
                if sessionsLeft == 0 {
                    let pomodoro = Pomodoro()
                    let date = Date()
                    pomodoro.date = date
                    pomodoro.pomodoroLength = sessionLength
                    pomodoro.sessions = sessions
                    
                    try! realm!.write {
                        realm?.add(pomodoro)
                    }
                    
                    let notification = Notification(name: .statisticsUpdated)
                    NotificationCenter.default.post(notification)
                    
                    timer.invalidate()
                    
                    pauseButton.isHidden = true
                    stopButton.isHidden = true
                    playButton.isHidden = false
                    
                    setupTimer()
                    
                    showAlertWith(title: Localize(text: "Congrats"), message: Localize(text: "Pomodoro_completed"))
                } else {
                    timeRemaining = sessionLength
                    
                    animation.toValue = 1
                    animation.duration = Double(timeRemaining / 100)
                    animation.isRemovedOnCompletion = true
                    animation.fillMode = .forwards
                    shape.add(animation, forKey: "animation")
                }
            }
        }
        minutesLeftLabel.text = "\(timeRemaining / 60)"
        secondsLeftLabel.text = "\(timeRemaining % 60)"
        collectionView.reloadData()
    }
    
    func subscribeToNotificationsFromSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSettings(notification:)), name: .settingsChanged, object: nil)
    }
    
    @objc func didReceiveSettings(notification: Notification) {
        if let settings = notification.object as? PomodoroSettings {
            timeRemaining = settings.focus * 60
            sessionsLeft = settings.sets
            sessions = settings.sets
            sessionLength = settings.focus * 60
            shortPauseLength = settings.shortBreak * 60
            longPauseLength = settings.longBreak * 60
            
            minutesLeftLabel.text = "\(timeRemaining / 60)"
            secondsLeftLabel.text = "0"
            
            collectionView.reloadData()
        }
    }
    
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    //MARK: - Actions
    
    @IBAction func didTapMenuButton() {
        present(sideMenu!, animated: true)
    }
    @IBAction func didTouchPlayButton(_ sender: Any) {
        if animationPause {
            resumeLayer(layer: shape)
            animationPause = !animationPause
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(step), userInfo: nil, repeats: true)
            playButton.isHidden = true
            pauseButton.isHidden = false
            stopButton.isHidden = false
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(step), userInfo: nil, repeats: true)
            playButton.isHidden = true
            pauseButton.isHidden = false
            stopButton.isHidden = false
            
            animation.toValue = 1
            animation.duration = Double(timeRemaining / 100)
            animation.isRemovedOnCompletion = true
            animation.fillMode = .forwards
            shape.add(animation, forKey: "animation")
        }
    }
    @IBAction func didTouchPauseButton(_ sender: Any) {
        timer.invalidate()
        animationPause = !animationPause
        pauseLayer(layer: shape)

        playButton.isHidden = false
        pauseButton.isHidden = true
        stopButton.isHidden = true
    }
    @IBAction func didTouchStopButton(_ sender: Any) {
        timer.invalidate()
        shape.removeAllAnimations()
        
        timeRemaining = sessionLength
        minutesLeftLabel.text = "\(timeRemaining / 60)"
        secondsLeftLabel.text = "\(timeRemaining % 60)"
        
        playButton.isHidden = false
        pauseButton.isHidden = true
        stopButton.isHidden = true
    }
    
    //MARK: - Alert
    
    func Localize(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessionsLeft
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
            if let icon = cell.viewWithTag(100) as? UIImageView {
                icon.frame = cell.bounds
                icon.image = UIImage(named: "tomato")
            return cell
            }
        return UICollectionViewCell()
    }
}

