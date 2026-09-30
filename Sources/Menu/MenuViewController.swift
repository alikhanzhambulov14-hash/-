import UIKit

class MenuViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    private var currentScreen: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        showMenuScreen()
    }

    private func createMenuButton(title: String, action: Selector, isPrimary: Bool = false) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = isPrimary ? UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0) : UIColor(white: 0.3, alpha: 1.0)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }

    private func createTitleLabel() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.alignment = .center
        container.spacing = 5
        container.translatesAutoresizingMaskIntoConstraints = false

        let pvzLabel = UILabel()
        let pvzAttr = NSMutableAttributedString(string: "Plants ", attributes: [.foregroundColor: UIColor.green])
        pvzAttr.append(NSAttributedString(string: "vs ", attributes: [.foregroundColor: UIColor.white]))
        pvzAttr.append(NSAttributedString(string: "Zombies", attributes: [.foregroundColor: UIColor.gray]))
        pvzLabel.attributedText = pvzAttr
        pvzLabel.font = UIFont.systemFont(ofSize: 50, weight: .black)

        let fusionLabel = UILabel()
        fusionLabel.text = "⚡ FUSION ⚡"
        fusionLabel.font = UIFont.systemFont(ofSize: 40, weight: .black)
        fusionLabel.textColor = .yellow

        let versionLabel = UILabel()
        versionLabel.text = "3.9"
        versionLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        versionLabel.textColor = .white

        container.addArrangedSubview(pvzLabel)
        container.addArrangedSubview(fusionLabel)
        container.addArrangedSubview(versionLabel)

        return container
    }

    private func switchScreen(to newScreen: UIView) {
        currentScreen?.removeFromSuperview()
        view.addSubview(newScreen)
        NSLayoutConstraint.activate([
            newScreen.topAnchor.constraint(equalTo: view.topAnchor),
            newScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        currentScreen = newScreen
    }

    private func showMenuScreen() {
        let screen = UIView()
        screen.translatesAutoresizingMaskIntoConstraints = false
        
        let bgView = UIImageView(image: UIImage(named: "menu_bg"))
        bgView.contentMode = .scaleAspectFill
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.alpha = 0.6
        screen.addSubview(bgView)

        let titleView = createTitleLabel()
        screen.addSubview(titleView)

        let playBtn = createMenuButton(title: "▶ ИГРАТЬ", action: #selector(playTapped), isPrimary: true)
        let almanacBtn = createMenuButton(title: "📖 Альманах", action: #selector(almanacTapped))
        let howBtn = createMenuButton(title: "❓ Как играть", action: #selector(howToPlayTapped))

        let stack = UIStackView(arrangedSubviews: [playBtn, almanacBtn, howBtn])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        screen.addSubview(stack)

        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: screen.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: screen.bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: screen.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: screen.trailingAnchor),

            titleView.centerXAnchor.constraint(equalTo: screen.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: screen.topAnchor, constant: 60),

            stack.centerXAnchor.constraint(equalTo: screen.centerXAnchor),
            stack.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 40),
            
            playBtn.heightAnchor.constraint(equalToConstant: 60),
            playBtn.widthAnchor.constraint(equalToConstant: 300),
            almanacBtn.heightAnchor.constraint(equalToConstant: 60),
            almanacBtn.widthAnchor.constraint(equalToConstant: 300),
            howBtn.heightAnchor.constraint(equalToConstant: 60),
            howBtn.widthAnchor.constraint(equalToConstant: 300)
        ])

        switchScreen(to: screen)
    }

    private func createPanelScreen(title: String, content: UIView, backAction: Selector) -> UIView {
        let screen = UIView()
        screen.translatesAutoresizingMaskIntoConstraints = false
        screen.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        let panel = UIView()
        panel.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        panel.layer.cornerRadius = 15
        panel.layer.borderWidth = 2
        panel.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        panel.translatesAutoresizingMaskIntoConstraints = false
        screen.addSubview(panel)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(titleLabel)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(content)

        let backBtn = createMenuButton(title: "← Назад", action: backAction)
        panel.addSubview(backBtn)

        NSLayoutConstraint.activate([
            panel.centerXAnchor.constraint(equalTo: screen.centerXAnchor),
            panel.centerYAnchor.constraint(equalTo: screen.centerYAnchor),
            panel.widthAnchor.constraint(equalTo: screen.widthAnchor, multiplier: 0.8),
            panel.heightAnchor.constraint(equalTo: screen.heightAnchor, multiplier: 0.8),

            titleLabel.topAnchor.constraint(equalTo: panel.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: panel.centerXAnchor),

            content.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            content.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
            content.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),
            content.bottomAnchor.constraint(equalTo: backBtn.topAnchor, constant: -20),

            backBtn.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -20),
            backBtn.centerXAnchor.constraint(equalTo: panel.centerXAnchor),
            backBtn.heightAnchor.constraint(equalToConstant: 50),
            backBtn.widthAnchor.constraint(equalToConstant: 200)
        ])

        return screen
    }

    @objc private func playTapped() {
        // According to HTML it goes to level screen, but here we go to SeedChooser
        let chooserVC = SeedChooserViewController()
        chooserVC.modalPresentationStyle = .fullScreen
        chooserVC.modalTransitionStyle = .crossDissolve
        present(chooserVC, animated: true)
    }

    @objc private func almanacTapped() {
        let content = UIView()
        let lbl = UILabel()
        lbl.text = "Список слияний здесь (в разработке...)"
        lbl.textColor = .lightGray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(lbl)
        NSLayoutConstraint.activate([
            lbl.centerXAnchor.constraint(equalTo: content.centerXAnchor),
            lbl.centerYAnchor.constraint(equalTo: content.centerYAnchor)
        ])
        let screen = createPanelScreen(title: "📖 Альманах слияний", content: content, backAction: #selector(backToMenu))
        switchScreen(to: screen)
    }

    @objc private func howToPlayTapped() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .equalSpacing

        let items = [
            ("☀️", "Собирай солнце, нажимая на него"),
            ("🌱", "Выбери растение снизу и нажми на клетку поля"),
            ("⚡", "FUSION: Поставь два растения на одну клетку, чтобы создать гибрид!"),
            ("🧟", "Зомби идут справа. Не дай им дойти до дома!")
        ]

        for (icon, text) in items {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 20
            row.alignment = .center

            let iconLbl = UILabel()
            iconLbl.text = icon
            iconLbl.font = UIFont.systemFont(ofSize: 40)
            
            let textLbl = UILabel()
            textLbl.text = text
            textLbl.textColor = .white
            textLbl.font = UIFont.systemFont(ofSize: 20)
            textLbl.numberOfLines = 0

            row.addArrangedSubview(iconLbl)
            row.addArrangedSubview(textLbl)
            stack.addArrangedSubview(row)
        }

        let screen = createPanelScreen(title: "Как играть", content: stack, backAction: #selector(backToMenu))
        switchScreen(to: screen)
    }

    @objc private func backToMenu() {
        showMenuScreen()
    }
}
