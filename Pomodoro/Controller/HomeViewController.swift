//
//  ViewController.swift
//  Pomodoro
//
//  Created by Victor on 29/04/2021.
//

import UIKit
import SideMenu
import RealmSwift

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MenuControllerDelegateProtocol {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var sideMenu: SideMenuNavigationController?
    
    private var settingsController: SettingsViewController? = nil
    private var statisticsController: StatisticsViewController? = nil
    private var FAQController: FAQViewController? = nil
    private var howToUseAppController: HowToUseAppViewController? = nil
    
    let playButton: UIButton = {
        let playButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        playButton.backgroundColor = .green
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.clipsToBounds = true
        playButton.addTarget(self, action: #selector(didTouchPlayButton), for: .touchUpInside)
        return playButton
    }()
    let pauseButton: UIButton = {
        let pauseButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        pauseButton.backgroundColor = .green
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        pauseButton.clipsToBounds = true
        pauseButton.addTarget(self, action: #selector(didTouchPauseButton), for: .touchUpInside)
        return pauseButton
    }()
    let stopButton: UIButton = {
        let stopButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        stopButton.backgroundColor = .green
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.setImage(UIImage(named: "stop"), for: .normal)
        stopButton.clipsToBounds = true
        stopButton.addTarget(self, action: #selector(didTouchStopButton), for: .touchUpInside)
        return stopButton
    }()
    
    let enjoyBreakLabel: UILabel = {
        let enjoyBreakLabel = UILabel()
        enjoyBreakLabel.text = "Break time, enjoy it while it lasts!"
        enjoyBreakLabel.translatesAutoresizingMaskIntoConstraints = false
        return enjoyBreakLabel
    }()
    let minutesLeftLabel: UILabel = {
        let minutesLabel = UILabel()
        minutesLabel.translatesAutoresizingMaskIntoConstraints = false
        return minutesLabel
    }()
    let secondsLeftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
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
    
    var photos = [UIImage]()
    
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
        
        view.backgroundColor = Colors.myVeryLightGray
        setupUI()
    }
    
    //MARK: - Prepare UI
  
    func setupUI() {
        preparePhotosArray()
        setupCollectionView()
        setupLabels()
        addConstraints()
        drawShapes()
        subscribeToNotificationsFromSettings()
        setupMenuController()
        addChildControllers()
        setupTimer()
        checkIfTutorialWasSeen()
    }
    
    func preparePhotosArray() {
        if let settings = self.realm?.objects(PomodoroSettings.self).first {
            sessions = settings.sets
            for _ in 0..<sessions {
                photos.append(UIImage(named: "pomoEmpty")!)
            }
        } else {
            sessions = settings.sets
            for _ in 0..<sessions {
                photos.append(UIImage(named: "pomoEmpty")!)
            }
        }
        collectionView.reloadData()
    }
    
    func setupCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(IconCollectionViewCell.nib(), forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
    }
    
    func setupLabels() {
        minutesLeftLabel.textColor = Colors.myGreen
        minutesLeftLabel.font = UIFont(name: "Roboto-Black", size: 110)
        minutesLeftLabel.sizeToFit()
        
        secondsLeftLabel.textColor = Colors.myGreen
        secondsLeftLabel.font = UIFont(name: "Roboto-Black", size: 60)
        secondsLeftLabel.sizeToFit()
        
        enjoyBreakLabel.isHidden = true
        enjoyBreakLabel.font = UIFont(name: "Roboto-Black", size: 25)
        enjoyBreakLabel.sizeToFit()
        
        self.view.addSubview(enjoyBreakLabel)
        self.view.addSubview(minutesLeftLabel)
        self.view.addSubview(secondsLeftLabel)
        self.view.addSubview(playButton)
        self.view.addSubview(pauseButton)
        self.view.addSubview(stopButton)
    }
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(enjoyBreakLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20))
        constraints.append(enjoyBreakLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(minutesLeftLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(minutesLeftLabel.topAnchor.constraint(equalTo: enjoyBreakLabel.centerYAnchor, constant: self.view.bounds.width / 2))
        constraints.append(secondsLeftLabel.bottomAnchor.constraint(equalTo: minutesLeftLabel.topAnchor))
        constraints.append(secondsLeftLabel.leadingAnchor.constraint(equalTo: minutesLeftLabel.trailingAnchor))
        constraints.append(playButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(playButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30))
        constraints.append(pauseButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: 0))
        constraints.append(pauseButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30))
        constraints.append(stopButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 0))
        constraints.append(stopButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func drawShapes() {
        let bounds = UIScreen.main.bounds
        let width = bounds.width
        let anchor = CGPoint(x: width / 2, y: (width / 2) + 154)
       
        let circlePath = UIBezierPath(arcCenter: anchor,
                                      radius: width / 2.2,
                                      startAngle: -(.pi / 2),
                                      endAngle: .pi * 3 / 2,
                                      clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 15
        trackShape.strokeColor = UIColor.lightGray.cgColor
        
        shape.path = circlePath.cgPath
        shape.lineWidth = 15
        shape.strokeColor = Colors.myGreen.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        shape.lineCap = .round
        
        view.layer.addSublayer(trackShape)
        view.layer.addSublayer(shape)
    }
    
    func checkIfTutorialWasSeen() {
        let sawTutorial = defaults.bool(forKey: sawTutorialKey)
        if !sawTutorial {
            if let vc = storyboard?.instantiateViewController(identifier: "tutorialVC") as? TutorialViewController {
                navigationController?.present(vc, animated: true, completion: nil)
            }
        }
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
        if let settings = self.realm?.objects(PomodoroSettings.self).first {
            timeRemaining = settings.focus * 60
            sessionsLeft = settings.sets
            sessions = sessionsLeft
            sessionLength = settings.focus * 60
            shortPauseLength = settings.shortBreak * 60
            longPauseLength = settings.longBreak * 60
        } else {
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
                shape.strokeColor = Colors.myOrange.cgColor
                enjoyBreakLabel.isHidden = false
                
                minutesLeftLabel.textColor = Colors.myOrange
                secondsLeftLabel.textColor = Colors.myOrange
                
                sessionsLeft -= 1
                photos[sessions - sessionsLeft - 1] = UIImage(named: "pomoFull")!
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
                shape.strokeColor = Colors.myGreen.cgColor
                enjoyBreakLabel.isHidden = true
                
                minutesLeftLabel.textColor = Colors.myGreen
                secondsLeftLabel.textColor = Colors.myGreen
                
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
                    
                    for i in 0..<sessions {
                        photos[i] = UIImage(named: "pomoEmpty")!
                    }
                    
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
        collectionView?.reloadData()
    }
    
    //MARK: - Notifications
    
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
            
            photos = []
            for _ in 0..<sessions {
                if let photo = UIImage(named: "pomoEmpty") {
                    photos.append(photo)
                }
            }
            collectionView?.reloadData()
        }
    }
    
    //MARK: - Shape Layer Actions
    
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
    
    @objc func didTouchPlayButton() {
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
    
    @objc func didTouchPauseButton() {
        timer.invalidate()
        animationPause = !animationPause
        pauseLayer(layer: shape)

        playButton.isHidden = false
        pauseButton.isHidden = true
        stopButton.isHidden = true
    }
    
    @objc func didTouchStopButton() {
        timer.invalidate()
        shape.removeAllAnimations()
        
        timeRemaining = sessionLength
        minutesLeftLabel.text = "\(timeRemaining / 60)"
        secondsLeftLabel.text = "\(timeRemaining % 60)"
        
        playButton.isHidden = false
        pauseButton.isHidden = true
        stopButton.isHidden = true
    }
    
    //MARK: - Alerts
    
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
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.identifier, for: indexPath) as? IconCollectionViewCell {
            cell.icon.image = photos[indexPath.row]
            return cell
    }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 50, height: 50)
        }
}

