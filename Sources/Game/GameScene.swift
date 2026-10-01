import SpriteKit
import Foundation

// MARK: - Constants
struct C {
    static let rows       = 5
    static let cols       = 9
    static let cellW: CGFloat = 80
    static let cellH: CGFloat = 90
    static let gridOffX: CGFloat = 60   // left margin
    static let gridOffY: CGFloat = 60   // bottom margin
    static let sunInterval: Double = 8.0
    static let mowerSpeed: CGFloat = 600
}

// MARK: - Plant Definitions
enum PlantKind: String, CaseIterable {
    // Core plants shown in seed chooser
    case peashooter   = "peashooter"
    case sunflower    = "sunflower"
    case wallnut      = "wallnut"
    case cherrybomb   = "cherrybomb"
    case snowpea      = "snowpea"
    case repeater     = "repeater"
    case threepeater  = "threepeater"
    case chomper      = "chomper"
    case potatomine   = "potatomine"
    case jalapeno     = "jalapeno"
    case squash       = "squash"
    case tallnut      = "tallnut"
    case cactus       = "cactus"
    case magnetshroom = "magnetshroom"
    case sunshroom    = "sunshroom"
    case gloomshroom  = "gloomshroom"
    case lilypad      = "lilypad"
    case flowerpot    = "flowerpot"

    var cost: Int {
        switch self {
        case .peashooter:   return 100
        case .sunflower:    return 50
        case .wallnut:      return 50
        case .cherrybomb:   return 150
        case .snowpea:      return 175
        case .repeater:     return 200
        case .threepeater:  return 325
        case .chomper:      return 150
        case .potatomine:   return 25
        case .jalapeno:     return 125
        case .squash:       return 50
        case .tallnut:      return 125
        case .cactus:       return 125
        case .magnetshroom: return 100
        case .sunshroom:    return 25
        case .gloomshroom:  return 150
        case .lilypad:      return 25
        case .flowerpot:    return 25
        }
    }

    var hp: Int {
        switch self {
        case .wallnut, .tallnut: return 4000
        case .gloomshroom: return 600
        default: return 300
        }
    }

    var shootInterval: Double? {
        switch self {
        case .peashooter:   return 1.5
        case .snowpea:      return 1.5
        case .repeater:     return 0.8
        case .threepeater:  return 1.5
        case .gloomshroom:  return 1.5
        case .cactus:       return 1.5
        default: return nil
        }
    }

    var isInstant: Bool {
        switch self {
        case .cherrybomb, .jalapeno, .squash, .potatomine: return true
        default: return false
        }
    }

    var isDefensive: Bool {
        switch self {
        case .wallnut, .tallnut: return true
        default: return false
        }
    }

    // Fusion recipes: self + other = result
    func fuse(with other: PlantKind) -> PlantKind? {
        let pair = Set([self, other])
        let recipes: [Set<PlantKind>: PlantKind] = [
            [.peashooter, .snowpea]:     .snowpea,      // snowpeashooter (use snowpea sprite)
            [.peashooter, .repeater]:    .repeater,
            [.peashooter, .sunflower]:   .peashooter,
            [.sunflower, .sunshroom]:    .sunshroom,
            [.wallnut, .tallnut]:        .tallnut,
            [.cherrybomb, .jalapeno]:    .cherrybomb,
            [.squash, .potatomine]:      .squash,
            [.chomper, .peashooter]:     .chomper,
            [.gloomshroom, .peashooter]: .gloomshroom,
            [.cactus, .peashooter]:      .cactus,
            [.repeater, .snowpea]:       .snowpea,
        ]
        return recipes[pair]
    }
}

// MARK: - Zombie Definitions
enum ZombieKind: String {
    case normal      = "zombie"
    case cone        = "conezombie"
    case bucket      = "bucketzombie"
    case flag        = "flagzombie"
    case pole        = "polevaultzombie"
    case football    = "footballzombie"
    case dancer      = "dancerzombie"
    case ducky       = "duckyzombie"
    case digger      = "diggerzombie"
    case zomboni     = "zomboni"

    var hp: Int {
        switch self {
        case .normal:   return 270
        case .cone:     return 560
        case .bucket:   return 1300
        case .flag:     return 270
        case .pole:     return 270
        case .football: return 1600
        case .dancer:   return 500
        case .ducky:    return 400
        case .digger:   return 600
        case .zomboni:  return 1800
        }
    }

    var speed: CGFloat {
        switch self {
        case .football, .pole: return 42
        case .zomboni:         return 50
        default:               return 22
        }
    }

    var eatSpeed: Double { return 0.5 }
}

// MARK: - Bullet
class Bullet: SKSpriteNode {
    var damage: Int   = 20
    var frozen: Bool  = false
    var row: Int      = 0
    var targetRow: Int = -1  // for threepeater (-1 means same row)

    convenience init(kind: String, row: Int, damage: Int = 20, frozen: Bool = false) {
        self.init(imageNamed: kind)
        self.name   = "bullet"
        self.row    = row
        self.damage = damage
        self.frozen = frozen
        if texture == nil || texture!.size() == CGSize.zero {
            color = frozen ? .cyan : .green
            colorBlendFactor = 1
        }
        size = CGSize(width: 16, height: 16)
        physicsBody = nil
        zPosition = 30
    }
}

// MARK: - Plant Entity
class PlantNode: SKNode {
    var kind: PlantKind
    var row: Int
    var col: Int
    var hp: Int
    var maxHp: Int
    var shootTimer: Double = 0
    var chomping: Bool = false
    var targetZombie: ZombieNode? = nil
    var readyTimer: Double = 0    // for potato mine
    var sunTimer: Double  = 0    // for sunflower / sunshroom
    var sprite: SKSpriteNode

    init(kind: PlantKind, row: Int, col: Int) {
        self.kind  = kind
        self.row   = row
        self.col   = col
        self.hp    = kind.hp
        self.maxHp = kind.hp
        self.sprite = SKSpriteNode(imageNamed: kind.rawValue)
        if self.sprite.texture == nil || self.sprite.texture!.size() == CGSize.zero {
            self.sprite = SKSpriteNode(color: .green, size: CGSize(width: C.cellW - 4, height: C.cellH - 4))
        } else {
            self.sprite.size = CGSize(width: C.cellW - 4, height: C.cellH - 4)
        }
        super.init()
        addChild(sprite)
        zPosition = 10

        // Sunflower / sunshroom timer
        if kind == .sunflower {
            sunTimer = 10.0
        } else if kind == .sunshroom {
            sunTimer = 8.0
        }
        // Potato mine needs 14s to arm
        if kind == .potatomine {
            readyTimer = 14.0
            sprite.alpha = 0.5
        }
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

// MARK: - Zombie Entity
class ZombieNode: SKNode {
    var kind: ZombieKind
    var row: Int
    var hp: Int
    var maxHp: Int
    var isDead: Bool   = false
    var isFrozen: Bool = false
    var frozenTimer: Double = 0
    var eatTimer: Double    = 0
    var isEating: Bool      = false
    var targetPlant: PlantNode? = nil
    var speed: CGFloat
    var sprite: SKSpriteNode
    var healthBar: SKShapeNode?

    init(kind: ZombieKind, row: Int, startX: CGFloat) {
        self.kind   = kind
        self.row    = row
        self.hp     = kind.hp
        self.maxHp  = kind.hp
        self.speed  = kind.speed
        self.sprite = SKSpriteNode(imageNamed: kind.rawValue)
        if self.sprite.texture == nil || self.sprite.texture!.size() == CGSize.zero {
            self.sprite = SKSpriteNode(color: .purple, size: CGSize(width: 40, height: 60))
        } else {
            self.sprite.size = CGSize(width: 50, height: 70)
        }
        super.init()
        addChild(sprite)
        position.x = startX
        position.y = 0
        zPosition  = 20

        // Health bar
        let bar = SKShapeNode(rectOf: CGSize(width: 46, height: 5), cornerRadius: 2)
        bar.fillColor   = .red
        bar.strokeColor = .clear
        bar.position    = CGPoint(x: 0, y: 40)
        bar.name        = "hpbar"
        addChild(bar)
        healthBar = bar
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }

    func updateHealthBar() {
        let pct = CGFloat(hp) / CGFloat(maxHp)
        healthBar?.xScale = max(0, pct)
        healthBar?.fillColor = pct > 0.5 ? .green : pct > 0.25 ? .yellow : .red
    }
}

// MARK: - Sun Drop
class SunNode: SKSpriteNode {
    var value: Int = 25
    convenience init(value: Int = 25, at pos: CGPoint) {
        self.init(imageNamed: "sun")
        if texture == nil || texture!.size() == CGSize.zero {
            color = .yellow; colorBlendFactor = 1
        }
        self.value = value
        size       = CGSize(width: 50, height: 50)
        position   = pos
        zPosition  = 50
        name       = "sun"
        // Auto-remove after 10s
        run(SKAction.sequence([SKAction.wait(forDuration: 10), SKAction.removeFromParent()]))
    }
}

// MARK: - GameScene
class GameScene: SKScene {

    // MARK: State
    var sun: Int = 50 { didSet { updateHUD() } }
    var selectedPlant: PlantKind? = nil
    var plants:  [[PlantNode?]] = Array(repeating: Array(repeating: nil, count: C.cols), count: C.rows)
    var zombies: [ZombieNode]   = []
    var mowers:  [SKSpriteNode?] = Array(repeating: nil, count: C.rows)
    var mowerActive: [Bool]      = Array(repeating: true,  count: C.rows)

    var currentLevel: Int  = 1
    var currentWave: Int   = 0
    var totalWaves: Int    = 3
    var waveCooldown: Double = 0
    var waveDelay:    Double = 30
    var gameOver:     Bool   = false
    var paused_:      Bool   = false
    var sunDropTimer: Double = C.sunInterval

    // MARK: HUD refs
    var sunLabel:   SKLabelNode?
    var waveLabel:  SKLabelNode?
    var seedBar:    SKNode?
    var selectionIndicator: SKShapeNode?

    // MARK: Setup
    override func didMove(to view: SKView) {
        setupBackground()
        setupGrid()
        setupMowers()
        setupHUD()
        setupSeedBar()
        setupTapRecognizer()
        currentWave = 0
        waveCooldown = 5   // first wave in 5s
    }

    // MARK: Background + Grid
    func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "lawn")
        if bg.texture == nil || bg.texture!.size() == CGSize.zero {
            backgroundColor = SKColor(red: 0.22, green: 0.58, blue: 0.12, alpha: 1)
        } else {
            bg.size       = size
            bg.position   = CGPoint(x: size.width/2, y: size.height/2)
            bg.zPosition  = -10
            addChild(bg)
        }
    }

    func setupGrid() {
        for r in 0..<C.rows {
            let shade = r % 2 == 0 ? SKColor(white: 1, alpha: 0.04) : SKColor(white: 0, alpha: 0.04)
            for c in 0..<C.cols {
                let cell = SKShapeNode(rectOf: CGSize(width: C.cellW-1, height: C.cellH-1))
                cell.fillColor   = shade
                cell.strokeColor = SKColor(white: 1, alpha: 0.1)
                cell.position    = gridPos(row: r, col: c)
                cell.zPosition   = -5
                addChild(cell)
            }
        }
    }

    func setupMowers() {
        for r in 0..<C.rows {
            let mow = SKSpriteNode(imageNamed: "mower")
            if mow.texture == nil || mow.texture!.size() == CGSize.zero {
                mow.color = .yellow; mow.colorBlendFactor = 1
                mow.size  = CGSize(width: 40, height: 40)
            } else {
                mow.size = CGSize(width: 50, height: 50)
            }
            let p = gridPos(row: r, col: 0)
            mow.position  = CGPoint(x: p.x - C.cellW, y: p.y)
            mow.zPosition = 15
            mow.name      = "mower_\(r)"
            addChild(mow)
            mowers[r] = mow
        }
    }

    func setupHUD() {
        let panel = SKShapeNode(rectOf: CGSize(width: 160, height: 44), cornerRadius: 8)
        panel.fillColor   = SKColor(white: 0, alpha: 0.5)
        panel.strokeColor = .clear
        panel.position    = CGPoint(x: 90, y: size.height - 28)
        panel.zPosition   = 100
        addChild(panel)

        let sunIcon = SKSpriteNode(imageNamed: "sun")
        if sunIcon.texture == nil || sunIcon.texture!.size() == CGSize.zero {
            sunIcon.color = .yellow; sunIcon.colorBlendFactor = 1
        }
        sunIcon.size     = CGSize(width: 30, height: 30)
        sunIcon.position = CGPoint(x: -55, y: 0)
        panel.addChild(sunIcon)

        let lbl = SKLabelNode(fontNamed: "AvenirNext-Bold")
        lbl.fontSize     = 22
        lbl.fontColor    = .white
        lbl.text         = "\(sun)"
        lbl.position     = CGPoint(x: 10, y: -8)
        lbl.name         = "sunLabel"
        panel.addChild(lbl)
        sunLabel = lbl

        let wl = SKLabelNode(fontNamed: "AvenirNext-Bold")
        wl.fontSize   = 16
        wl.fontColor  = .white
        wl.text       = "Волна \(currentWave)/\(totalWaves)"
        wl.position   = CGPoint(x: size.width/2, y: size.height - 30)
        wl.zPosition  = 100
        wl.name       = "waveLabel"
        addChild(wl)
        waveLabel = wl
    }

    func setupSeedBar() {
        let plants: [PlantKind] = [.sunflower, .peashooter, .wallnut, .snowpea, .cherrybomb,
                                   .repeater, .chomper, .potatomine, .squash, .tallnut,
                                   .threepeater, .jalapeno, .cactus, .sunshroom]
        let barH: CGFloat = 70
        let barW: CGFloat = CGFloat(plants.count) * 64 + 8
        let panel = SKShapeNode(rectOf: CGSize(width: barW, height: barH), cornerRadius: 8)
        panel.fillColor   = SKColor(red: 0.1, green: 0.3, blue: 0.1, alpha: 0.85)
        panel.strokeColor = SKColor(white: 1, alpha: 0.15)
        panel.position    = CGPoint(x: size.width/2, y: 38)
        panel.zPosition   = 100
        panel.name        = "seedBar"
        addChild(panel)
        seedBar = panel

        for (i, pk) in plants.enumerated() {
            let card = SKShapeNode(rectOf: CGSize(width: 56, height: 60), cornerRadius: 6)
            card.fillColor   = SKColor(white: 0, alpha: 0.4)
            card.strokeColor = SKColor(white: 1, alpha: 0.2)
            let x = -barW/2 + 32 + CGFloat(i) * 64
            card.position = CGPoint(x: x, y: 0)
            card.name     = "card_\(pk.rawValue)"
            panel.addChild(card)

            let icon = SKSpriteNode(imageNamed: pk.rawValue)
            if icon.texture == nil || icon.texture!.size() == CGSize.zero {
                icon.color = .green; icon.colorBlendFactor = 1
            }
            icon.size = CGSize(width: 42, height: 42)
            icon.position = CGPoint(x: 0, y: 8)
            icon.name = "icon_\(pk.rawValue)"
            card.addChild(icon)

            let costLbl = SKLabelNode(fontNamed: "AvenirNext-Bold")
            costLbl.fontSize = 11
            costLbl.fontColor = .yellow
            costLbl.text = "\(pk.cost)"
            costLbl.position = CGPoint(x: 0, y: -22)
            card.addChild(costLbl)
        }
    }

    func setupTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view?.addGestureRecognizer(tap)
    }

    // MARK: Coordinate helpers
    func gridPos(row: Int, col: Int) -> CGPoint {
        let x = C.gridOffX + CGFloat(col) * C.cellW + C.cellW/2
        let y = C.gridOffY + CGFloat(row) * C.cellH + C.cellH/2
        return CGPoint(x: x, y: y)
    }

    func gridCell(at point: CGPoint) -> (row: Int, col: Int)? {
        let col = Int((point.x - C.gridOffX) / C.cellW)
        let row = Int((point.y - C.gridOffY) / C.cellH)
        if row >= 0 && row < C.rows && col >= 0 && col < C.cols {
            return (row, col)
        }
        return nil
    }

    // MARK: HUD Update
    func updateHUD() {
        sunLabel?.text = "\(sun)"
        waveLabel?.text = "Волна \(currentWave)/\(totalWaves)"
        // Dim cards we can't afford
        seedBar?.children.forEach { node in
            guard let card = node as? SKShapeNode, let name = card.name, name.hasPrefix("card_"),
                  let rawVal = name.components(separatedBy: "_").dropFirst().first,
                  let pk = PlantKind(rawValue: rawVal) else { return }
            card.alpha = sun >= pk.cost ? 1.0 : 0.5
        }
    }

    // MARK: Touch / Tap
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard !gameOver, !paused_ else { return }
        let viewPoint = recognizer.location(in: view)
        let scenePoint = convertPoint(fromView: viewPoint)

        // Tap on seed bar card?
        if let bar = seedBar {
            let barPoint = bar.convert(scenePoint, from: self)
            for child in bar.children {
                guard let card = child as? SKShapeNode,
                      let name = card.name, name.hasPrefix("card_") else { continue }
                if card.contains(barPoint) {
                    let raw = String(name.dropFirst(5))
                    if let pk = PlantKind(rawValue: raw) {
                        if selectedPlant == pk {
                            clearSelection()
                        } else {
                            selectPlant(pk)
                        }
                    }
                    return
                }
            }
        }

        // Tap on sun?
        let tapped = nodes(at: scenePoint)
        for n in tapped {
            if n.name == "sun", let sn = n as? SunNode {
                sun += sn.value
                sn.run(SKAction.sequence([
                    SKAction.scale(to: 1.4, duration: 0.1),
                    SKAction.removeFromParent()
                ]))
                return
            }
        }

        // Tap on grid cell — place plant
        if let selected = selectedPlant, let (row, col) = gridCell(at: scenePoint) {
            tryPlant(selected, row: row, col: col)
        }
    }

    func selectPlant(_ pk: PlantKind) {
        selectionIndicator?.removeFromParent()
        selectedPlant = pk

        guard let bar = seedBar else { return }
        let card = bar.childNode(withName: "card_\(pk.rawValue)") as? SKShapeNode
        let ind = SKShapeNode(rectOf: CGSize(width: 56, height: 60), cornerRadius: 6)
        ind.fillColor   = .clear
        ind.strokeColor = .yellow
        ind.lineWidth   = 2
        ind.position    = card?.position ?? .zero
        ind.zPosition   = 5
        ind.name        = "selInd"
        bar.addChild(ind)
        selectionIndicator = ind
    }

    func clearSelection() {
        selectedPlant = nil
        selectionIndicator?.removeFromParent()
        selectionIndicator = nil
    }

    // MARK: Plant placement
    func tryPlant(_ pk: PlantKind, row: Int, col: Int) {
        guard sun >= pk.cost else { showNotEnoughSun(); return }

        let existing = plants[row][col]

        // Fusion attempt
        if let ex = existing {
            if let fusedKind = ex.kind.fuse(with: pk) {
                sun -= pk.cost
                // Replace with fused plant
                ex.removeFromParent()
                plants[row][col] = nil
                placePlant(fusedKind, row: row, col: col, isFusion: true)
                clearSelection()
                return
            }
            // Can't place on top of existing plant (no fusion)
            return
        }

        // Lily pad / flowerpot requirement (simplified — no pool/roof in this build)
        sun -= pk.cost
        placePlant(pk, row: row, col: col, isFusion: false)
        clearSelection()
    }

    @discardableResult
    func placePlant(_ pk: PlantKind, row: Int, col: Int, isFusion: Bool) -> PlantNode {
        let node = PlantNode(kind: pk, row: row, col: col)
        node.position = gridPos(row: row, col: col)
        if isFusion {
            node.run(SKAction.sequence([
                SKAction.scale(to: 1.3, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ]))
        }
        addChild(node)
        plants[row][col] = node

        // Instant-use plants
        switch pk {
        case .cherrybomb:
            triggerCherryBomb(row: row, col: col, node: node)
        case .jalapeno:
            triggerJalapeno(row: row, node: node)
        case .squash:
            triggerSquash(row: row, col: col, node: node)
        case .potatomine:
            break // handled in update loop
        default:
            break
        }
        return node
    }

    // MARK: Instant plant actions
    func triggerCherryBomb(row: Int, col: Int, node: PlantNode) {
        let pos = node.position
        let exp = SKSpriteNode(imageNamed: "cherrybombexp")
        if exp.texture == nil || exp.texture!.size() == CGSize.zero {
            exp.color = .orange; exp.colorBlendFactor = 1; exp.size = CGSize(width: 1, height: 1)
        } else {
            exp.size = CGSize(width: 1, height: 1)
        }
        exp.position  = pos
        exp.zPosition = 60
        addChild(exp)
        exp.run(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: CGFloat(C.cellW * 3) / 10, duration: 0.3),
                SKAction.fadeAlpha(to: 0, duration: 0.3)
            ]),
            SKAction.removeFromParent()
        ]))
        // Damage 3x3 area
        for dr in -1...1 {
            for dc in -1...1 {
                let tr = row + dr; let tc = col + dc
                if tr >= 0 && tr < C.rows && tc >= 0 && tc < C.cols {
                    zombies.filter { $0.row == tr && !$0.isDead && $0.position.x >= gridPos(row: tr, col: tc).x - C.cellW/2 && $0.position.x <= gridPos(row: tr, col: tc).x + C.cellW/2 + C.cellW }.forEach {
                        $0.hp = 0; $0.isDead = true
                    }
                }
            }
        }
        // Broader sweep
        let cx = pos.x; let cy = pos.y
        zombies.filter { !$0.isDead && abs($0.position.y - cy) < C.cellH * 1.5 && $0.position.x > cx - C.cellW * 1.5 && $0.position.x < cx + C.cellW * 1.5 }.forEach {
            $0.hp = 0; $0.isDead = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            node.removeFromParent()
            self.plants[row][col] = nil
        }
    }

    func triggerJalapeno(row: Int, node: PlantNode) {
        let pos = node.position
        let fire = SKShapeNode(rectOf: CGSize(width: size.width, height: C.cellH - 4))
        fire.fillColor   = SKColor.orange.withAlphaComponent(0.8)
        fire.strokeColor = .red
        fire.position    = CGPoint(x: size.width/2, y: pos.y)
        fire.zPosition   = 60
        addChild(fire)
        fire.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.6), SKAction.removeFromParent()]))
        zombies.filter { !$0.isDead && $0.row == row }.forEach { $0.hp = 0; $0.isDead = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            node.removeFromParent(); self.plants[row][self.colOf(node)] = nil
        }
    }

    func triggerSquash(row: Int, col: Int, node: PlantNode) {
        let nearest = zombies.filter { !$0.isDead && ($0.row == row || abs($0.row - row) <= 1) }
            .sorted { a, b in abs(a.position.x - node.position.x) < abs(b.position.x - node.position.x) }
            .first
        guard let z = nearest else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                node.removeFromParent(); self.plants[row][col] = nil
            }
            return
        }
        let jump = SKAction.sequence([
            SKAction.move(to: CGPoint(x: node.position.x, y: node.position.y + 60), duration: 0.2),
            SKAction.move(to: z.position, duration: 0.2),
        ])
        node.run(SKAction.sequence([jump, SKAction.run {
            z.hp = 0; z.isDead = true
            node.removeFromParent(); self.plants[row][col] = nil
        }]))
    }

    func colOf(_ node: PlantNode) -> Int {
        for c in 0..<C.cols { if plants[node.row][c] === node { return c } }
        return 0
    }

    // MARK: Wave spawning
    func spawnWave(_ wave: Int) {
        currentWave = wave
        updateHUD()
        let defs = waveDefinition(wave: wave)
        var delay: Double = 0
        for def in defs {
            let row = def.row
            let kind = def.kind
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self = self, !self.gameOver else { return }
                self.spawnZombie(kind: kind, row: row)
            }
            delay += Double.random(in: 0.4...1.2)
        }
    }

    struct ZombieDef { var kind: ZombieKind; var row: Int }

    func waveDefinition(wave: Int) -> [ZombieDef] {
        var defs: [ZombieDef] = []
        let count = 3 + wave * 2
        for _ in 0..<count {
            let row = Int.random(in: 0..<C.rows)
            let kinds: [ZombieKind]
            if wave <= 2       { kinds = [.normal, .flag] }
            else if wave <= 5  { kinds = [.normal, .cone, .flag] }
            else if wave <= 10 { kinds = [.normal, .cone, .bucket, .pole] }
            else               { kinds = [.normal, .cone, .bucket, .pole, .football, .dancer] }
            let kind = kinds.randomElement()!
            defs.append(ZombieDef(kind: kind, row: row))
        }
        return defs
    }

    func spawnZombie(kind: ZombieKind, row: Int) {
        let startX = size.width + 60
        let z = ZombieNode(kind: kind, row: row, startX: startX)
        let yPos = gridPos(row: row, col: 0).y
        z.position = CGPoint(x: startX, y: yPos)
        addChild(z)
        zombies.append(z)
    }

    // MARK: Sun drops from sky
    func dropSunFromSky() {
        let x = CGFloat.random(in: C.gridOffX + C.cellW ... C.gridOffX + CGFloat(C.cols) * C.cellW - C.cellW)
        let startY = size.height + 30
        let endY   = CGFloat.random(in: C.gridOffY + C.cellH ... size.height - 100)
        let sn = SunNode(value: 25, at: CGPoint(x: x, y: startY))
        addChild(sn)
        sn.run(SKAction.move(to: CGPoint(x: x, y: endY), duration: 1.5))
    }

    func dropSunAt(_ pos: CGPoint, value: Int = 25) {
        let sn = SunNode(value: value, at: pos)
        addChild(sn)
        sn.run(SKAction.move(by: CGVector(dx: 0, dy: 30), duration: 0.5))
    }

    // MARK: Main Update Loop
    override func update(_ currentTime: TimeInterval) {
        guard !gameOver, !paused_ else { return }
        let dt: Double = 1.0/60.0

        // Wave logic
        if waveCooldown > 0 {
            waveCooldown -= dt
            if waveCooldown <= 0 {
                let nextWave = currentWave + 1
                if nextWave <= totalWaves {
                    spawnWave(nextWave)
                    waveCooldown = waveDelay
                }
            }
        }

        // Sun from sky
        sunDropTimer -= dt
        if sunDropTimer <= 0 {
            sunDropTimer = C.sunInterval
            dropSunFromSky()
        }

        // Update plants
        updatePlants(dt: dt)

        // Update zombies
        updateZombies(dt: dt)

        // Update bullets
        updateBullets(dt: dt)

        // Check win
        checkWin()
    }

    // MARK: Plant Update
    func updatePlants(dt: Double) {
        for r in 0..<C.rows {
            for c in 0..<C.cols {
                guard let p = plants[r][c] else { continue }

                // Sunflower / sunshroom sun production
                if p.kind == .sunflower || p.kind == .sunshroom {
                    p.sunTimer -= dt
                    if p.sunTimer <= 0 {
                        p.sunTimer = p.kind == .sunflower ? 24.0 : 18.0
                        let v = p.kind == .sunshroom ? 15 : 25
                        dropSunAt(p.position, value: v)
                    }
                }

                // Potato mine arming
                if p.kind == .potatomine {
                    if p.readyTimer > 0 {
                        p.readyTimer -= dt
                        if p.readyTimer <= 0 {
                            p.sprite.alpha = 1.0
                        }
                    } else {
                        // Check for zombie on same cell
                        if let z = zombies.first(where: { !$0.isDead && $0.row == r && abs($0.position.x - p.position.x) < C.cellW/2 }) {
                            z.hp = 0; z.isDead = true
                            p.removeFromParent(); plants[r][c] = nil
                        }
                    }
                    continue
                }

                // Shooting plants
                guard let interval = p.kind.shootInterval else { continue }
                let zombiesInRow = zombies.filter { !$0.isDead && $0.row == r && $0.position.x > p.position.x - 20 }
                let extraRows: [Int]
                if p.kind == .threepeater { extraRows = [r-1, r, r+1] } else { extraRows = [r] }
                let hasTarget = extraRows.contains { tRow in
                    tRow >= 0 && tRow < C.rows && zombies.contains { !$0.isDead && $0.row == tRow && $0.position.x > p.position.x - 20 }
                }
                guard hasTarget || p.kind == .gloomshroom else { continue }

                p.shootTimer -= dt
                if p.shootTimer <= 0 {
                    p.shootTimer = interval
                    shootFromPlant(p, extraRows: extraRows)
                }
            }
        }
    }

    func shootFromPlant(_ p: PlantNode, extraRows: [Int]) {
        for tRow in extraRows {
            guard tRow >= 0 && tRow < C.rows else { continue }
            let frozen = p.kind == .snowpea
            let dmg: Int
            switch p.kind {
            case .repeater:     dmg = 20
            case .threepeater:  dmg = 20
            case .gloomshroom:  dmg = 40
            case .cactus:       dmg = 20
            default:            dmg = 20
            }
            let texName = frozen ? "projectilesnowpea" : "bullet_pea"
            let b = Bullet(kind: texName, row: tRow, damage: dmg, frozen: frozen)
            b.position = CGPoint(x: p.position.x + 20, y: p.position.y)
            addChild(b)

            // Gloomshroom shoots in all 8 directions (simulated as aoe)
            if p.kind == .gloomshroom {
                b.removeFromParent()
                // AOE: damage nearby zombies
                let range = C.cellW * 1.5
                zombies.filter { !$0.isDead && abs($0.position.x - p.position.x) < range && abs($0.position.y - p.position.y) < range }
                    .forEach { dealDamage(to: $0, dmg: dmg, frozen: false) }
            }

            // Repeater fires twice
            if p.kind == .repeater {
                let b2 = Bullet(kind: texName, row: tRow, damage: dmg, frozen: frozen)
                b2.position = CGPoint(x: p.position.x + 10, y: p.position.y)
                addChild(b2)
                b2.run(SKAction.wait(forDuration: 0.3)) // slight delay
            }
        }
    }

    // MARK: Zombie Update
    func updateZombies(dt: Double) {
        zombies = zombies.filter { !$0.isDead || $0.parent != nil }

        for z in zombies {
            if z.isDead {
                z.run(SKAction.sequence([
                    SKAction.fadeOut(withDuration: 0.3),
                    SKAction.removeFromParent()
                ]))
                continue
            }

            // Frozen slow
            let speedMult: CGFloat = z.isFrozen ? 0.5 : 1.0
            if z.isFrozen {
                z.frozenTimer -= dt
                if z.frozenTimer <= 0 { z.isFrozen = false }
            }

            // Check if eating a plant
            let frontX   = z.position.x - 28
            let eatTarget = plants[z.row].compactMap { $0 }.filter { p in
                p.position.x >= frontX - 10 && p.position.x <= frontX + C.cellW
            }.sorted { $0.position.x > $1.position.x }.first

            if let target = eatTarget {
                z.isEating = true
                z.eatTimer += dt
                if z.eatTimer >= z.kind.eatSpeed {
                    z.eatTimer = 0
                    target.hp -= 100
                    if target.hp <= 0 {
                        target.removeFromParent()
                        if let c = (0..<C.cols).first(where: { plants[z.row][$0] === target }) {
                            plants[z.row][c] = nil
                        }
                    }
                }
            } else {
                z.isEating = false
                z.eatTimer = 0
                // Move left
                z.position.x -= z.speed * speedMult * CGFloat(dt)
            }

            z.updateHealthBar()

            // Check mower trigger (zombie reached left edge)
            let mowerX = gridPos(row: z.row, col: 0).x - C.cellW
            if z.position.x <= mowerX + 20 && mowerActive[z.row] {
                triggerMower(row: z.row)
            }

            // Check house (game over)
            if z.position.x <= 0 {
                triggerGameOver()
                return
            }
        }

        // Clean truly dead
        zombies.removeAll { $0.isDead && $0.parent == nil }
    }

    func triggerMower(row: Int) {
        guard mowerActive[row], let mow = mowers[row] else { return }
        mowerActive[row] = false
        // Kill all zombies in this row
        let mowAction = SKAction.moveBy(x: size.width + 100, y: 0, duration: (size.width + 100) / C.mowerSpeed)
        mow.run(SKAction.sequence([mowAction, SKAction.removeFromParent()]))
        zombies.filter { !$0.isDead && $0.row == row }.forEach { $0.hp = 0; $0.isDead = true }
        mowers[row] = nil
    }

    // MARK: Bullet Update
    func updateBullets(dt: Double) {
        children.compactMap { $0 as? Bullet }.forEach { b in
            b.position.x += 250 * CGFloat(dt)

            // Off screen
            if b.position.x > size.width + 50 {
                b.removeFromParent()
                return
            }

            // Hit zombie in correct row
            for z in zombies {
                guard !z.isDead, z.row == b.row else { continue }
                if abs(z.position.x - b.position.x) < 30 && abs(z.position.y - b.position.y) < C.cellH/2 {
                    dealDamage(to: z, dmg: b.damage, frozen: b.frozen)
                    b.removeFromParent()
                    return
                }
            }
        }
    }

    func dealDamage(to z: ZombieNode, dmg: Int, frozen: Bool) {
        z.hp -= dmg
        if frozen {
            z.isFrozen    = true
            z.frozenTimer = 3.0
        }
        if z.hp <= 0 { z.isDead = true }
        // Small hit flash
        z.sprite.run(SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 0.8, duration: 0.05),
            SKAction.colorize(withColorBlendFactor: 0, duration: 0.1)
        ]))
    }

    // MARK: Win/Lose
    func checkWin() {
        if currentWave >= totalWaves && zombies.filter({ !$0.isDead }).isEmpty && waveCooldown <= 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.triggerWin()
            }
        }
    }

    func triggerWin() {
        gameOver = true
        showResult(win: true)
    }

    func triggerGameOver() {
        gameOver = true
        showResult(win: false)
    }

    func showResult(win: Bool) {
        let overlay = SKShapeNode(rectOf: size)
        overlay.fillColor   = win ? SKColor(red: 0, green: 0.5, blue: 0, alpha: 0.7) : SKColor(red: 0.5, green: 0, blue: 0, alpha: 0.7)
        overlay.strokeColor = .clear
        overlay.position    = CGPoint(x: size.width/2, y: size.height/2)
        overlay.zPosition   = 200
        addChild(overlay)

        let title = SKLabelNode(fontNamed: "AvenirNext-Bold")
        title.text      = win ? "🎉 ПОБЕДА!" : "💀 ПОРАЖЕНИЕ"
        title.fontSize  = 48
        title.fontColor = .white
        title.position  = CGPoint(x: 0, y: 40)
        overlay.addChild(title)

        let sub = SKLabelNode(fontNamed: "AvenirNext-Medium")
        sub.text      = win ? "Уровень пройден!" : "Зомби добрались до дома..."
        sub.fontSize  = 22
        sub.fontColor = .white
        sub.position  = CGPoint(x: 0, y: -10)
        overlay.addChild(sub)

        // Retry button
        let btn = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 12)
        btn.fillColor   = .white
        btn.strokeColor = .clear
        btn.position    = CGPoint(x: 0, y: -70)
        btn.name        = "retryBtn"
        overlay.addChild(btn)
        let btnLbl = SKLabelNode(fontNamed: "AvenirNext-Bold")
        btnLbl.text      = win ? "Следующий →" : "▶ Заново"
        btnLbl.fontSize  = 20
        btnLbl.fontColor = .black
        btnLbl.verticalAlignmentMode = .center
        btn.addChild(btnLbl)
    }

    func showNotEnoughSun() {
        let lbl = SKLabelNode(fontNamed: "AvenirNext-Bold")
        lbl.text      = "Нет солнца! ☀️"
        lbl.fontSize  = 20
        lbl.fontColor = .yellow
        lbl.position  = CGPoint(x: size.width/2, y: size.height/2 + 60)
        lbl.zPosition = 150
        addChild(lbl)
        lbl.run(SKAction.sequence([
            SKAction.moveBy(x: 0, y: 30, duration: 0.6),
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
        ]))
    }

    // MARK: Touch began (for retry button)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)
        let tapped = nodes(at: loc)
        for n in tapped {
            if n.name == "retryBtn" {
                if let view = view {
                    let newScene = GameScene(size: size)
                    newScene.currentLevel = currentLevel
                    newScene.totalWaves   = totalWaves
                    newScene.scaleMode    = scaleMode
                    view.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
                }
                return
            }
        }
    }
}
