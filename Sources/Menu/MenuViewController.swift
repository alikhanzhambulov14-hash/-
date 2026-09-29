import UIKit

class MenuViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.1, green: 0.28, blue: 0.16, alpha: 1)
        setupUI()
    }

    private func setupUI() {
        // Original Menu Background
        let bgImageView = UIImageView(image: UIImage(named: "menu_bg"))
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.frame = UIScreen.main.bounds
        bgImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(bgImageView)

        // Version Label
        let versionLabel = UILabel()
        versionLabel.text = "PvZ Fusion iOS v3.9"
        versionLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        versionLabel.textColor = .white
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            versionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])

        // Adventure Button
        let advBtn = UIButton(type: .custom)
        advBtn.setImage(UIImage(named: "menu_adventure"), for: .normal)
        advBtn.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        advBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(advBtn)
        
        NSLayoutConstraint.activate([
            advBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 180),
            advBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            advBtn.widthAnchor.constraint(equalToConstant: 330),
            advBtn.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // Hover/pulse effect on adventure button
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction]) {
            advBtn.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }

        // Almanac button (temp text button until we extract almanac sprite)
        let almanacBtn = UIButton(type: .system)
        almanacBtn.setTitle("Альманах Слияний", for: .normal)
        almanacBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        almanacBtn.setTitleColor(.white, for: .normal)
        almanacBtn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        almanacBtn.layer.cornerRadius = 10
        almanacBtn.addTarget(self, action: #selector(almanacTapped), for: .touchUpInside)
        almanacBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(almanacBtn)
        
        NSLayoutConstraint.activate([
            almanacBtn.centerXAnchor.constraint(equalTo: advBtn.centerXAnchor),
            almanacBtn.topAnchor.constraint(equalTo: advBtn.bottomAnchor, constant: 20),
            almanacBtn.widthAnchor.constraint(equalToConstant: 250),
            almanacBtn.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    @objc private func playTapped() {
        let gameVC = GameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.modalTransitionStyle = .crossDissolve
        present(gameVC, animated: true)
    }

    @objc private func almanacTapped() {
        let alert = UIAlertController(title: "📖 Альманах Слияний", message: fusionAlmanacText(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func fusionAlmanacText() -> String {
        return """
        🌻 + 🌱 = ☀️🔫 Солнце-Стрелок
        Стреляет и даёт солнце!

        🌱 + ❄️ = 🧊 Ледяной Стрелок
        Двойные замораживающие снаряды

        🌻 + 🥜 = ☀️🛡 Солнце-Орех
        Блокирует и даёт солнце

        🌱 + 🥜 = 🔫🛡 Горохо-Орех
        Стреляет и блокирует

        ❄️ + 🥜 = 🧊🛡 Ледяной Орех
        Замораживает ближних зомби

        🍒 + 🌱 = 💥🔫 Пулемёт
        Скорострельная стрельба
        """
    }
}
