import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    var selectedSeeds: [PlantType] = []
    private var skView: SKView!
    private var scene: GameScene!

    // UI Elements
    private let sunAmountLabel = UILabel()
    private let waveTextLabel = UILabel()
    
    private var pauseOverlay: UIView?
    private var resultOverlay: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.ignoresSiblingOrder = true
        view.addSubview(skView)

        scene = GameScene(size: CGSize(width: 1194, height: 834))
        scene.scaleMode = .aspectFill
        scene.gameVC = self
        if !selectedSeeds.isEmpty {
            scene.selectedSeeds = selectedSeeds
        }
        skView.presentScene(scene)
        
        setupHUD()
    }
    
    private func setupHUD() {
        // Sun Counter
        let sunCounter = UIStackView()
        sunCounter.axis = .horizontal
        sunCounter.spacing = 10
        sunCounter.alignment = .center
        sunCounter.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        sunCounter.layer.cornerRadius = 20
        sunCounter.layoutMargins = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        sunCounter.isLayoutMarginsRelativeArrangement = true
        sunCounter.translatesAutoresizingMaskIntoConstraints = false
        
        let sunIcon = UILabel()
        sunIcon.text = "☀️"
        sunIcon.font = UIFont.systemFont(ofSize: 24)
        
        sunAmountLabel.text = "50"
        sunAmountLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        sunAmountLabel.textColor = .white
        
        sunCounter.addArrangedSubview(sunIcon)
        sunCounter.addArrangedSubview(sunAmountLabel)
        view.addSubview(sunCounter)
        
        // Wave Info
        let waveInfo = UIView()
        waveInfo.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        waveInfo.layer.cornerRadius = 15
        waveInfo.translatesAutoresizingMaskIntoConstraints = false
        
        waveTextLabel.text = "Волна 1"
        waveTextLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        waveTextLabel.textColor = .white
        waveTextLabel.textAlignment = .center
        waveTextLabel.translatesAutoresizingMaskIntoConstraints = false
        waveInfo.addSubview(waveTextLabel)
        view.addSubview(waveInfo)
        
        // Pause Button
        let pauseBtn = UIButton(type: .system)
        pauseBtn.setTitle("⏸", for: .normal)
        pauseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        pauseBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        pauseBtn.layer.cornerRadius = 25
        pauseBtn.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        pauseBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseBtn)
        
        // Fusion Hint
        let fusionHint = UIView()
        fusionHint.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        fusionHint.layer.cornerRadius = 10
        fusionHint.layer.borderWidth = 2
        fusionHint.layer.borderColor = UIColor.yellow.cgColor
        fusionHint.translatesAutoresizingMaskIntoConstraints = false
        fusionHint.alpha = 0 // Hidden by default
        
        let hintLabel = UILabel()
        hintLabel.text = "⚡ FUSION! Поставь на существующее растение для слияния!"
        hintLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        hintLabel.textColor = .yellow
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        fusionHint.addSubview(hintLabel)
        view.addSubview(fusionHint)
        self.fusionHintView = fusionHint
        
        NSLayoutConstraint.activate([
            sunCounter.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sunCounter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            waveInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            waveInfo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            waveTextLabel.leadingAnchor.constraint(equalTo: waveInfo.leadingAnchor, constant: 15),
            waveTextLabel.trailingAnchor.constraint(equalTo: waveInfo.trailingAnchor, constant: -15),
            waveTextLabel.topAnchor.constraint(equalTo: waveInfo.topAnchor, constant: 5),
            waveTextLabel.bottomAnchor.constraint(equalTo: waveInfo.bottomAnchor, constant: -5),
            
            pauseBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            pauseBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pauseBtn.widthAnchor.constraint(equalToConstant: 50),
            pauseBtn.heightAnchor.constraint(equalToConstant: 50),
            
            fusionHint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fusionHint.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            hintLabel.leadingAnchor.constraint(equalTo: fusionHint.leadingAnchor, constant: 15),
            hintLabel.trailingAnchor.constraint(equalTo: fusionHint.trailingAnchor, constant: -15),
            hintLabel.topAnchor.constraint(equalTo: fusionHint.topAnchor, constant: 10),
            hintLabel.bottomAnchor.constraint(equalTo: fusionHint.bottomAnchor, constant: -10)
        ])
    }
    
    private var fusionHintView: UIView?
    
    func showFusionHint() {
        guard let hint = fusionHintView else { return }
        hint.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.3, animations: {
            hint.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
                hint.alpha = 0
            }, completion: nil)
        }
    }

    private func createOverlayPanel(title: String, buttons: [(String, Selector, Bool)]) -> UIView {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let panel = UIView()
        panel.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        panel.layer.cornerRadius = 15
        panel.layer.borderWidth = 2
        panel.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        panel.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(panel)
        
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [titleLbl])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(stack)
        
        for (btnTitle, action, isPrimary) in buttons {
            let btn = UIButton(type: .system)
            btn.setTitle(btnTitle, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = isPrimary ? UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0) : UIColor(white: 0.3, alpha: 1.0)
            btn.layer.cornerRadius = 8
            btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
            btn.addTarget(self, action: action, for: .touchUpInside)
            stack.addArrangedSubview(btn)
        }
        
        NSLayoutConstraint.activate([
            panel.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            panel.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            panel.widthAnchor.constraint(equalToConstant: 350),
            
            stack.topAnchor.constraint(equalTo: panel.topAnchor, constant: 30),
            stack.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -30),
            stack.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -30)
        ])
        
        return overlay
    }

    @objc private func pauseTapped() {
        scene.isGamePaused = true
        scene.isPaused = true
        
        let overlay = createOverlayPanel(title: "⏸ Пауза", buttons: [
            ("▶ Продолжить", #selector(resumeTapped), true),
            ("🏠 В меню", #selector(quitToMenu), false)
        ])
        view.addSubview(overlay)
        pauseOverlay = overlay
    }
    
    @objc private func resumeTapped() {
        pauseOverlay?.removeFromSuperview()
        pauseOverlay = nil
        scene.isGamePaused = false
        scene.isPaused = false
    }

    @objc private func quitToMenu() {
        returnToMenu()
    }
    
    @objc private func retryTapped() {
        resultOverlay?.removeFromSuperview()
        resultOverlay = nil
        // Restart scene
        let newScene = GameScene(size: CGSize(width: 1194, height: 834))
        newScene.scaleMode = .aspectFill
        newScene.gameVC = self
        newScene.selectedSeeds = self.selectedSeeds
        self.scene = newScene
        skView.presentScene(newScene)
    }

    func returnToMenu() {
        // Find presenting menu and dismiss
        view.window?.rootViewController?.dismiss(animated: true)
    }
    
    // MARK: - Updates from GameScene
    func updateSun(_ amount: Int) {
        sunAmountLabel.text = "\(amount)"
    }
    
    func updateWave(_ text: String) {
        waveTextLabel.text = text
    }
    
    func showResult(title: String) {
        scene.isGamePaused = true
        scene.isPaused = true
        let overlay = createOverlayPanel(title: title, buttons: [
            ("🔄 Ещё раз", #selector(retryTapped), true),
            ("🏠 В меню", #selector(quitToMenu), false)
        ])
        view.addSubview(overlay)
        resultOverlay = overlay
    }
}
