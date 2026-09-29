import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.ignoresSiblingOrder = true
        view.addSubview(skView)

        let scene = GameScene(size: CGSize(width: 1194, height: 834))
        scene.scaleMode = .aspectFill
        scene.gameVC = self
        skView.presentScene(scene)
    }

    func returnToMenu() {
        dismiss(animated: true)
    }
}
