import UIKit

class SeedChooserViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    var levelIndex: Int = LevelManager.shared.currentLevelIndex

    var availableSeeds: [Plant] = []
    var selectedSeeds:  [Plant] = []

    let maxSelection = 8

    var seedBankView: UIView!
    var chooserPanelView: UIScrollView!
    var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        availableSeeds = LevelManager.shared.availablePlants(forLevel: levelIndex)
        setupUI()
    }

    func setupUI() {
        // Background image to simulate the game screen in the background
        let bg = UIImageView(frame: view.bounds)
        bg.image = UIImage(named: "lawn")
        bg.contentMode = .scaleAspectFill
        bg.alpha = 0.5
        view.addSubview(bg)

        // Seed Bank (Top Left)
        seedBankView = UIView()
        seedBankView.backgroundColor = UIColor(red: 0.53, green: 0.33, blue: 0.15, alpha: 1) // Wood color
        seedBankView.layer.borderColor = UIColor(red: 0.3, green: 0.15, blue: 0.05, alpha: 1).cgColor
        seedBankView.layer.borderWidth = 4
        seedBankView.layer.cornerRadius = 8
        seedBankView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(seedBankView)
        
        // Start Button (Top Right next to seed bank)
        startButton = UIButton(type: .system)
        startButton.setTitle("LET'S ROCK!", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .black)
        startButton.backgroundColor = UIColor(red: 0.1, green: 0.8, blue: 0.1, alpha: 1)
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.layer.borderColor = UIColor(red: 0.05, green: 0.4, blue: 0.05, alpha: 1).cgColor
        startButton.layer.borderWidth = 3
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        startButton.alpha = 0.5
        startButton.isEnabled = false
        view.addSubview(startButton)

        // Chooser Panel (Bottom Left)
        let panelContainer = UIView()
        panelContainer.backgroundColor = UIColor(red: 0.72, green: 0.53, blue: 0.3, alpha: 1) // Dirt/Wood color
        panelContainer.layer.borderColor = UIColor(red: 0.4, green: 0.25, blue: 0.1, alpha: 1).cgColor
        panelContainer.layer.borderWidth = 6
        panelContainer.layer.cornerRadius = 12
        panelContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(panelContainer)

        let titleLabel = UILabel()
        titleLabel.text = "Choose Your Seeds"
        titleLabel.textColor = UIColor(white: 0.9, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        panelContainer.addSubview(titleLabel)

        chooserPanelView = UIScrollView()
        chooserPanelView.translatesAutoresizingMaskIntoConstraints = false
        panelContainer.addSubview(chooserPanelView)

        // Layout Constraints
        NSLayoutConstraint.activate([
            // Seed Bank
            seedBankView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            seedBankView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            seedBankView.heightAnchor.constraint(equalToConstant: 90),
            
            // Start Button
            startButton.leadingAnchor.constraint(equalTo: seedBankView.trailingAnchor, constant: 16),
            startButton.centerYAnchor.constraint(equalTo: seedBankView.centerYAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 180),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Panel Container
            panelContainer.topAnchor.constraint(equalTo: seedBankView.bottomAnchor, constant: 10),
            panelContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            panelContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            panelContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            // Panel Title
            titleLabel.topAnchor.constraint(equalTo: panelContainer.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: panelContainer.centerXAnchor),
            
            // Chooser ScrollView
            chooserPanelView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            chooserPanelView.leadingAnchor.constraint(equalTo: panelContainer.leadingAnchor, constant: 10),
            chooserPanelView.trailingAnchor.constraint(equalTo: panelContainer.trailingAnchor, constant: -10),
            chooserPanelView.bottomAnchor.constraint(equalTo: panelContainer.bottomAnchor, constant: -10),
        ])

        renderSeedBank()
        renderChooserPanel()
    }

    func renderSeedBank() {
        seedBankView.subviews.forEach { $0.removeFromSuperview() }
        let cardW: CGFloat = 56
        let cardH: CGFloat = 76
        let spacing: CGFloat = 6
        
        let totalW = CGFloat(maxSelection) * (cardW + spacing) + spacing
        seedBankView.widthAnchor.constraint(equalToConstant: totalW).isActive = true

        for i in 0..<maxSelection {
            let x = spacing + CGFloat(i) * (cardW + spacing)
            
            let slot = UIView(frame: CGRect(x: x, y: 7, width: cardW, height: cardH))
            slot.backgroundColor = UIColor(white: 0, alpha: 0.3)
            slot.layer.cornerRadius = 4
            seedBankView.addSubview(slot)
            
            if i < selectedSeeds.count {
                let pk = selectedSeeds[i]
                let btn = createPlantCard(pk: pk, frame: slot.bounds, isSelected: false)
                btn.tag = i
                btn.addTarget(self, action: #selector(selectedSeedTapped(_:)), for: .touchUpInside)
                slot.addSubview(btn)
            }
        }
        
        startButton.isEnabled = !selectedSeeds.isEmpty
        startButton.alpha = selectedSeeds.isEmpty ? 0.5 : 1.0
    }

    func renderChooserPanel() {
        chooserPanelView.subviews.forEach { $0.removeFromSuperview() }
        let cardW: CGFloat = 56
        let cardH: CGFloat = 76
        let spacing: CGFloat = 8
        
        let availableWidth = view.bounds.width - 40
        let cols = max(8, Int(availableWidth / (cardW + spacing)))
        
        for (i, pk) in availableSeeds.enumerated() {
            let col = i % cols
            let row = i / cols
            let x = CGFloat(col) * (cardW + spacing) + spacing
            let y = CGFloat(row) * (cardH + spacing) + spacing
            
            let isPicked = selectedSeeds.contains(pk)
            let btn = createPlantCard(pk: pk, frame: CGRect(x: x, y: y, width: cardW, height: cardH), isSelected: isPicked)
            btn.tag = i
            btn.addTarget(self, action: #selector(seedTapped(_:)), for: .touchUpInside)
            chooserPanelView.addSubview(btn)
        }
        
        let totalRows = (availableSeeds.count + cols - 1) / cols
        let contentHeight = CGFloat(totalRows) * (cardH + spacing) + spacing
        chooserPanelView.contentSize = CGSize(width: chooserPanelView.bounds.width, height: contentHeight)
    }
    
    func createPlantCard(pk: Plant, frame: CGRect, isSelected: Bool) -> UIButton {
        let btn = UIButton(frame: frame)
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.backgroundColor = isSelected ? UIColor(white: 0.3, alpha: 1) : UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        
        if let img = UIImage(named: pk.rawValue) {
            btn.setImage(img, for: .normal)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 20, right: 4)
            if isSelected { btn.imageView?.alpha = 0.5 }
        } else {
            btn.backgroundColor = isSelected ? UIColor(white: 0.2, alpha: 1) : UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1)
            btn.setTitle(String(pk.rawValue.prefix(6)), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
            btn.setTitleColor(isSelected ? .gray : .white, for: .normal)
        }
        
        let costBg = UIView(frame: CGRect(x: 0, y: frame.height - 18, width: frame.width, height: 18))
        costBg.backgroundColor = UIColor(white: 0, alpha: 0.5)
        btn.addSubview(costBg)
        
        let costLbl = UILabel(frame: costBg.bounds)
        costLbl.text = "\(pk.cost)"
        costLbl.textColor = isSelected ? .gray : .white
        costLbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        costLbl.textAlignment = .center
        costBg.addSubview(costLbl)
        
        return btn
    }

    @objc func seedTapped(_ sender: UIButton) {
        let pk = availableSeeds[sender.tag]
        if selectedSeeds.contains(pk) { return }
        if selectedSeeds.count >= maxSelection { return }
        selectedSeeds.append(pk)
        renderSeedBank()
        renderChooserPanel()
    }

    @objc func selectedSeedTapped(_ sender: UIButton) {
        selectedSeeds.remove(at: sender.tag)
        renderSeedBank()
        renderChooserPanel()
    }

    @objc func startGame() {
        let gameVC = GameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.modalTransitionStyle   = .crossDissolve
        gameVC.levelIndex             = levelIndex
        gameVC.selectedSeeds          = selectedSeeds
        present(gameVC, animated: true)
    }
}
