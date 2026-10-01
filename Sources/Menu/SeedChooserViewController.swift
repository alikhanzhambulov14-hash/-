import UIKit

class SeedChooserViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    var levelIndex: Int = LevelManager.shared.currentLevelIndex

    var availableSeeds: [PlantKind] = []
    var selectedSeeds:  [PlantKind] = []

    let maxSelection = 8

    var topBar:      UIView!
    var bottomBar:   UIScrollView!
    var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.05, green: 0.15, blue: 0.05, alpha: 1)
        availableSeeds = LevelManager.shared.availablePlants(forLevel: levelIndex)
        setupUI()
    }

    func setupUI() {
        // Background image
        let bg = UIImageView(frame: view.bounds)
        bg.image = UIImage(named: "lawn")
        bg.contentMode = .scaleAspectFill
        bg.alpha = 0.3
        view.addSubview(bg)

        // Title
        let titleLabel = UILabel()
        titleLabel.text = "🌱 Выбери растения"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .black)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Level label
        let levelLabel = UILabel()
        levelLabel.text = "Уровень \(levelIndex)"
        levelLabel.textColor = UIColor.yellow
        levelLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelLabel)

        // Start button
        startButton = UIButton(type: .system)
        startButton.setTitle("▶ ПОЕХАЛИ!", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        startButton.backgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.1, alpha: 1)
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 20
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        startButton.alpha = 0.5
        startButton.isEnabled = false
        view.addSubview(startButton)

        // Selected tray
        let topLabel = UILabel()
        topLabel.text = "Выбрано (до \(maxSelection)):"
        topLabel.textColor = UIColor(white: 0.8, alpha: 1)
        topLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topLabel)

        topBar = UIView()
        topBar.backgroundColor = UIColor(white: 0, alpha: 0.5)
        topBar.layer.cornerRadius = 8
        topBar.layer.borderWidth = 1
        topBar.layer.borderColor = UIColor.orange.withAlphaComponent(0.7).cgColor
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)

        // Available scroll view
        let availLabel = UILabel()
        availLabel.text = "Доступные:"
        availLabel.textColor = UIColor(white: 0.8, alpha: 1)
        availLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        availLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(availLabel)

        bottomBar = UIScrollView()
        bottomBar.backgroundColor = UIColor(white: 0, alpha: 0.4)
        bottomBar.layer.cornerRadius = 8
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)

        // Layout
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            levelLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),

            startButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startButton.widthAnchor.constraint(equalToConstant: 160),
            startButton.heightAnchor.constraint(equalToConstant: 44),

            topLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            topBar.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 4),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            topBar.heightAnchor.constraint(equalToConstant: 90),

            availLabel.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 8),
            availLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            bottomBar.topAnchor.constraint(equalTo: availLabel.bottomAnchor, constant: 4),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])

        renderBottomBar()
        renderTopBar()
    }

    func renderBottomBar() {
        bottomBar.subviews.forEach { $0.removeFromSuperview() }
        let cardW: CGFloat = 70
        let cardH: CGFloat = 82
        let spacing: CGFloat = 8
        let cols = 12

        for (i, pk) in availableSeeds.enumerated() {
            let col = i % cols
            let row = i / cols
            let x = CGFloat(col) * (cardW + spacing) + spacing
            let y = CGFloat(row) * (cardH + spacing) + spacing

            let btn = UIButton(frame: CGRect(x: x, y: y, width: cardW, height: cardH))
            btn.tag = i
            btn.layer.cornerRadius = 8
            btn.clipsToBounds = true
            btn.backgroundColor = UIColor(white: 0.15, alpha: 1)
            btn.layer.borderWidth = selectedSeeds.contains(pk) ? 2 : 1
            btn.layer.borderColor = selectedSeeds.contains(pk) ? UIColor.green.cgColor : UIColor(white: 0.5, alpha: 1).cgColor

            if let img = UIImage(named: pk.rawValue) {
                btn.setImage(img, for: .normal)
                btn.imageView?.contentMode = .scaleAspectFit
                btn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 24, right: 4)
            } else {
                btn.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.2, alpha: 1)
                btn.setTitle(String(pk.rawValue.prefix(6)), for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 9, weight: .bold)
                btn.titleLabel?.adjustsFontSizeToFitWidth = true
            }

            let costLbl = UILabel(frame: CGRect(x: 0, y: cardH - 22, width: cardW, height: 20))
            costLbl.text = "☀\(pk.cost)"
            costLbl.textColor = .yellow
            costLbl.font = UIFont.systemFont(ofSize: 11, weight: .bold)
            costLbl.textAlignment = .center
            btn.addSubview(costLbl)

            btn.alpha = selectedSeeds.contains(pk) ? 0.45 : 1.0
            btn.addTarget(self, action: #selector(seedTapped(_:)), for: .touchUpInside)
            bottomBar.addSubview(btn)
        }

        let totalRows = (availableSeeds.count + cols - 1) / cols
        bottomBar.contentSize = CGSize(width: bottomBar.bounds.width, height: CGFloat(totalRows) * (cardH + spacing) + spacing)
    }

    func renderTopBar() {
        topBar.subviews.forEach { $0.removeFromSuperview() }
        let cardW: CGFloat = 70
        let spacing: CGFloat = 8

        for (i, pk) in selectedSeeds.enumerated() {
            let x = CGFloat(i) * (cardW + spacing) + spacing
            let btn = UIButton(frame: CGRect(x: x, y: 6, width: cardW, height: 78))
            btn.tag = i
            btn.layer.cornerRadius = 8
            btn.clipsToBounds = true
            btn.backgroundColor = UIColor(white: 0.15, alpha: 1)
            btn.layer.borderWidth = 2
            btn.layer.borderColor = UIColor.green.cgColor

            if let img = UIImage(named: pk.rawValue) {
                btn.setImage(img, for: .normal)
                btn.imageView?.contentMode = .scaleAspectFit
                btn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 22, right: 4)
            } else {
                btn.backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.1, alpha: 1)
                btn.setTitle(String(pk.rawValue.prefix(6)), for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 9)
            }

            let costLbl = UILabel(frame: CGRect(x: 0, y: 58, width: cardW, height: 18))
            costLbl.text = "☀\(pk.cost)"
            costLbl.textColor = .yellow
            costLbl.font = UIFont.systemFont(ofSize: 11, weight: .bold)
            costLbl.textAlignment = .center
            btn.addSubview(costLbl)

            btn.addTarget(self, action: #selector(selectedSeedTapped(_:)), for: .touchUpInside)
            topBar.addSubview(btn)
        }

        startButton.isEnabled = !selectedSeeds.isEmpty
        startButton.alpha     = selectedSeeds.isEmpty ? 0.5 : 1.0
    }

    @objc func seedTapped(_ sender: UIButton) {
        let pk = availableSeeds[sender.tag]
        if selectedSeeds.contains(pk) { return }
        if selectedSeeds.count >= maxSelection { return }
        selectedSeeds.append(pk)
        renderTopBar()
        renderBottomBar()
    }

    @objc func selectedSeedTapped(_ sender: UIButton) {
        let pk = selectedSeeds[sender.tag]
        selectedSeeds.removeAll { $0 == pk }
        renderTopBar()
        renderBottomBar()
    }

    @objc func startGame() {
        let gameVC = GameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.modalTransitionStyle   = .crossDissolve
        gameVC.levelIndex             = levelIndex
        present(gameVC, animated: true)
    }
}
