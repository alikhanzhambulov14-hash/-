import UIKit

class MenuViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }

    private func setupUI() {
        let bgImageView = UIImageView(image: UIImage(named: "menu_bg"))
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.frame = UIScreen.main.bounds
        bgImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(bgImageView)

        let sw = UIScreen.main.bounds.width
        let sh = UIScreen.main.bounds.height

        // Title/Version Label
        let versionLabel = UILabel()
        versionLabel.text = "PvZ Fusion iOS v3.9"
        versionLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        versionLabel.textColor = .white
        versionLabel.frame = CGRect(x: sw - 160, y: sh - 30, width: 150, height: 20)
        view.addSubview(versionLabel)
        
        let advBtn = makeButton(img: "menu_adventure", action: #selector(playTapped), cx: sw * 0.75, cy: sh * 0.25, w: 330, h: 120)
        let miniBtn = makeButton(img: "menu_challenges", action: #selector(playTapped), cx: sw * 0.75, cy: sh * 0.45, w: 310, h: 110)
        let puzzleBtn = makeButton(img: "menu_vasebreaker", action: #selector(playTapped), cx: sw * 0.76, cy: sh * 0.63, w: 290, h: 100)
        let survBtn = makeButton(img: "menu_survival", action: #selector(playTapped), cx: sw * 0.77, cy: sh * 0.80, w: 270, h: 90)

        // Tombstones
        let optionsBtn = makeButton(img: "menu_woodsign1", action: #selector(notImplemented), cx: sw * 0.78, cy: sh * 0.95, w: 120, h: 60)
        let helpBtn = makeButton(img: "menu_woodsign2", action: #selector(notImplemented), cx: sw * 0.88, cy: sh * 0.93, w: 100, h: 50)
        let quitBtn = makeButton(img: "menu_quit", action: #selector(notImplemented), cx: sw * 0.96, cy: sh * 0.91, w: 80, h: 40)
        
        let almanacBtn = makeButton(img: "menu_almanac", action: #selector(notImplemented), cx: sw * 0.50, cy: sh * 0.88, w: 150, h: 80)
        
        // Hover/pulse effect on adventure button
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction]) {
            advBtn.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    private func makeButton(img: String, action: Selector, cx: CGFloat, cy: CGFloat, w: CGFloat, h: CGFloat) -> UIButton {
        let btn = UIButton(type: .custom)
        if let image = UIImage(named: img) {
            btn.setImage(image, for: .normal)
        } else {
            btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            btn.setTitle(img, for: .normal)
        }
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.frame = CGRect(x: cx - w/2, y: cy - h/2, width: w, height: h)
        view.addSubview(btn)
        return btn
    }

    @objc private func playTapped() {
        let gameVC = GameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.modalTransitionStyle = .crossDissolve
        present(gameVC, animated: true)
    }

    @objc private func notImplemented() {
        let alert = UIAlertController(title: "Not Implemented", message: "This 1:1 UI feature is coming in the next patch!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
