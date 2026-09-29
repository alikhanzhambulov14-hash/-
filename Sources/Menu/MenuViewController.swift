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
        // Background gradient layer
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.05, green: 0.2, blue: 0.1, alpha: 1).cgColor,
            UIColor(red: 0.15, green: 0.35, blue: 0.12, alpha: 1).cgColor,
            UIColor(red: 0.08, green: 0.22, blue: 0.08, alpha: 1).cgColor
        ]
        gradient.frame = UIScreen.main.bounds
        view.layer.insertSublayer(gradient, at: 0)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // Title
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        let titleText = NSMutableAttributedString()
        titleText.append(NSAttributedString(string: "Plants ", attributes: [
            .font: UIFont.systemFont(ofSize: 48, weight: .black),
            .foregroundColor: UIColor.systemGreen
        ]))
        titleText.append(NSAttributedString(string: "vs ", attributes: [
            .font: UIFont.systemFont(ofSize: 36, weight: .medium),
            .foregroundColor: UIColor.white.withAlphaComponent(0.8)
        ]))
        titleText.append(NSAttributedString(string: "Zombies", attributes: [
            .font: UIFont.systemFont(ofSize: 48, weight: .black),
            .foregroundColor: UIColor.systemBrown
        ]))
        titleLabel.attributedText = titleText
        stack.addArrangedSubview(titleLabel)

        let fusionLabel = UILabel()
        fusionLabel.text = "⚡ FUSION ⚡"
        fusionLabel.font = UIFont.systemFont(ofSize: 40, weight: .black)
        fusionLabel.textColor = UIColor.systemYellow
        fusionLabel.textAlignment = .center
        stack.addArrangedSubview(fusionLabel)

        let versionLabel = UILabel()
        versionLabel.text = "v3.9"
        versionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        versionLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        stack.addArrangedSubview(versionLabel)

        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stack.addArrangedSubview(spacer)

        // Play button
        let playBtn = makeButton(title: "▶  ИГРАТЬ", color: UIColor.systemGreen, big: true)
        playBtn.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        stack.addArrangedSubview(playBtn)

        // Almanac button
        let almanacBtn = makeButton(title: "📖  Альманах Слияний", color: UIColor.systemOrange, big: false)
        almanacBtn.addTarget(self, action: #selector(almanacTapped), for: .touchUpInside)
        stack.addArrangedSubview(almanacBtn)

        // Animate title
        animatePulse(fusionLabel)
    }

    private func makeButton(title: String, color: UIColor, big: Bool) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: big ? 28 : 20, weight: .bold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = color
        btn.layer.cornerRadius = big ? 18 : 14
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 6
        btn.contentEdgeInsets = UIEdgeInsets(top: big ? 16 : 12, left: 40, bottom: big ? 16 : 12, right: 40)
        btn.widthAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        return btn
    }

    private func animatePulse(_ view: UIView) {
        UIView.animate(withDuration: 1.2, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction]) {
            view.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }
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
