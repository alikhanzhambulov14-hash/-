import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    var levelIndex: Int = LevelManager.shared.currentLevelIndex

    private var skView: SKView!
    private var scene:  GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()

        skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
        view.addSubview(skView)

        presentGame()
    }

    func presentGame() {
        let sceneSize = CGSize(width: 1194, height: 834)
        scene = GameScene(size: sceneSize)
        scene.scaleMode  = .aspectFill
        scene.currentLevel = levelIndex
        scene.totalWaves   = LevelManager.shared.wavesForLevel(levelIndex)
        scene.sun          = LevelManager.shared.startingSunForLevel(levelIndex)
        skView.presentScene(scene)

        setupPauseButton()
    }

    func setupPauseButton() {
        let btn = UIButton(type: .system)
        btn.setTitle("⏸", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        btn.backgroundColor  = UIColor.black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 22
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        view.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            btn.widthAnchor.constraint(equalToConstant: 44),
            btn.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    @objc func pauseTapped() {
        scene.paused_ = !scene.paused_
        scene.isPaused = scene.paused_
    }

    func returnToMenu() {
        dismiss(animated: true)
    }
}
