import UIKit

class SeedChooserViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }
    
    var availableSeeds: [PlantType] = LevelManager.shared.getAvailablePlants()
    var selectedSeeds: [PlantType] = []
    
    let maxSelection = 8
    
    var topBar: UIView!
    var bottomBar: UIScrollView!
    var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        setupUI()
    }
    
    func setupUI() {
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 300, height: 40))
        titleLabel.text = "Choose Your Plants"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        view.addSubview(titleLabel)
        
        // Selected seeds bar
        topBar = UIView(frame: CGRect(x: 20, y: 70, width: view.bounds.width - 40, height: 100))
        topBar.backgroundColor = UIColor.brown.withAlphaComponent(0.8)
        topBar.layer.cornerRadius = 10
        topBar.layer.borderWidth = 2
        topBar.layer.borderColor = UIColor.orange.cgColor
        view.addSubview(topBar)
        
        // Available seeds scroll view
        bottomBar = UIScrollView(frame: CGRect(x: 20, y: 190, width: view.bounds.width - 40, height: view.bounds.height - 210))
        bottomBar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        bottomBar.layer.cornerRadius = 10
        view.addSubview(bottomBar)
        
        startButton = UIButton(type: .system)
        startButton.setTitle("LET'S ROCK!", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .black)
        startButton.backgroundColor = .systemGreen
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 25
        startButton.frame = CGRect(x: view.bounds.width - 220, y: 20, width: 200, height: 50)
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        startButton.alpha = 0.5
        startButton.isEnabled = false
        view.addSubview(startButton)
        
        renderBottomBar()
    }
    
    func renderBottomBar() {
        bottomBar.subviews.forEach { $0.removeFromSuperview() }
        
        let cardW: CGFloat = 60
        let cardH: CGFloat = 80
        let spacing: CGFloat = 10
        
        for (i, pt) in availableSeeds.enumerated() {
            let row = i / 10
            let col = i % 10
            
            let x = CGFloat(col) * (cardW + spacing) + spacing
            let y = CGFloat(row) * (cardH + spacing) + spacing
            
            let btn = UIButton(frame: CGRect(x: x, y: y, width: cardW, height: cardH))
            btn.tag = i
            
            // Try to load the texture, else use text
            if let img = UIImage(named: pt.textureName) {
                btn.setImage(img, for: .normal)
                btn.imageView?.contentMode = .scaleAspectFit
            } else {
                btn.backgroundColor = .brown
                btn.setTitle(pt.rawValue, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            }
            
            btn.layer.borderWidth = 2
            btn.layer.borderColor = UIColor.white.cgColor
            btn.addTarget(self, action: #selector(seedTapped(_:)), for: .touchUpInside)
            
            if selectedSeeds.contains(pt) {
                btn.alpha = 0.3
            } else {
                btn.alpha = 1.0
            }
            
            bottomBar.addSubview(btn)
        }
        
        let totalRows = (availableSeeds.count + 9) / 10
        bottomBar.contentSize = CGSize(width: bottomBar.bounds.width, height: CGFloat(totalRows) * (cardH + spacing) + spacing)
    }
    
    func renderTopBar() {
        topBar.subviews.forEach { $0.removeFromSuperview() }
        
        let cardW: CGFloat = 60
        let cardH: CGFloat = 80
        let spacing: CGFloat = 10
        
        for (i, pt) in selectedSeeds.enumerated() {
            let x = CGFloat(i) * (cardW + spacing) + spacing
            let y: CGFloat = 10
            
            let btn = UIButton(frame: CGRect(x: x, y: y, width: cardW, height: cardH))
            btn.tag = i
            
            if let img = UIImage(named: pt.textureName) {
                btn.setImage(img, for: .normal)
                btn.imageView?.contentMode = .scaleAspectFit
            } else {
                btn.backgroundColor = .brown
                btn.setTitle(pt.rawValue, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            }
            
            btn.layer.borderWidth = 2
            btn.layer.borderColor = UIColor.green.cgColor
            btn.addTarget(self, action: #selector(selectedSeedTapped(_:)), for: .touchUpInside)
            
            topBar.addSubview(btn)
        }
        
        if selectedSeeds.count > 0 {
            startButton.alpha = 1.0
            startButton.isEnabled = true
        } else {
            startButton.alpha = 0.5
            startButton.isEnabled = false
        }
    }
    
    @objc func seedTapped(_ sender: UIButton) {
        let pt = availableSeeds[sender.tag]
        if selectedSeeds.contains(pt) { return }
        if selectedSeeds.count >= maxSelection { return }
        
        selectedSeeds.append(pt)
        renderTopBar()
        renderBottomBar()
    }
    
    @objc func selectedSeedTapped(_ sender: UIButton) {
        selectedSeeds.remove(at: sender.tag)
        renderTopBar()
        renderBottomBar()
    }
    
    @objc func startGame() {
        let gameVC = GameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.modalTransitionStyle = .crossDissolve
        // Pass seeds to GameViewController
        // Need to update GameViewController to accept this
        gameVC.selectedSeeds = selectedSeeds
        present(gameVC, animated: true)
    }
}
