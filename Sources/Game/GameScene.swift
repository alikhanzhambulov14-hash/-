import SpriteKit

// MARK: - Data Models

enum PlantType: String, CaseIterable {
    case sunflower, peashooter, wallnut, snowpea, cherrybomb
    var textureName: String {
        switch self {
        case .sunflower: return "sunflower"
        case .peashooter: return "peashooter"
        case .wallnut: return "wallnut"
        case .snowpea: return "snowpea"
        case .cherrybomb: return "cherrybomb"
        }
    }
    var cost: Int {
        switch self {
        case .sunflower: return 50
        case .peashooter: return 100
        case .wallnut: return 50
        case .snowpea: return 175
        case .cherrybomb: return 150
        }
    }
    var hp: Int {
        switch self {
        case .wallnut: return 4000
        default: return 300
        }
    }
}

enum FusionType: String {
    case sunPea       // sunflower + peashooter
    case iceShooter   // peashooter + snowpea
    case sunNut       // sunflower + wallnut
    case peaNut       // peashooter + wallnut
    case iceNut       // snowpea + wallnut
    case gatlingPea   // cherrybomb + peashooter

    var textureName: String {
        switch self {
        case .sunPea: return "sunpea"
        case .iceShooter: return "snowpea"
        case .sunNut: return "sunnut"
        case .peaNut: return "peanut"
        case .iceNut: return "icenut"
        case .gatlingPea: return "gatlingpea"
        }
    }
    var hp: Int {
        switch self {
        case .sunNut, .peaNut, .iceNut: return 8000
        default: return 600
        }
    }

    static func fuse(_ a: PlantType, _ b: PlantType) -> FusionType? {
        let pair: Set<PlantType> = [a, b]
        if pair == [.sunflower, .peashooter] { return .sunPea }
        if pair == [.peashooter, .snowpea] { return .iceShooter }
        if pair == [.sunflower, .wallnut] { return .sunNut }
        if pair == [.peashooter, .wallnut] { return .peaNut }
        if pair == [.snowpea, .wallnut] { return .iceNut }
        if pair == [.cherrybomb, .peashooter] { return .gatlingPea }
        return nil
    }
}

enum ZombieType {
    case basic, cone, bucket
    var textureName: String { return "zombie" } // we only have 1 zombie texture copied so far
    var hp: Int {
        switch self {
        case .basic: return 200
        case .cone: return 560
        case .bucket: return 1300
        }
    }
    var speed: CGFloat {
        switch self {
        case .basic: return 15
        case .cone: return 18
        case .bucket: return 15
        }
    }
}

// MARK: - Game Entities

class PlantEntity {
    var type: PlantType?
    var fusion: FusionType?
    var hp: Int
    var row: Int
    var col: Int
    var node: SKNode
    var shootTimer: TimeInterval = 0
    var sunTimer: TimeInterval = 0

    init(type: PlantType, row: Int, col: Int, node: SKNode) {
        self.type = type
        self.hp = type.hp
        self.row = row
        self.col = col
        self.node = node
    }
    init(fusion: FusionType, row: Int, col: Int, node: SKNode) {
        self.fusion = fusion
        self.hp = fusion.hp
        self.row = row
        self.col = col
        self.node = node
    }
    var canShoot: Bool {
        if let f = fusion { return [.sunPea, .iceShooter, .peaNut, .gatlingPea].contains(f) }
        return type == .peashooter || type == .snowpea
    }
    var shootsIce: Bool {
        if let f = fusion { return f == .iceShooter || f == .iceNut }
        return type == .snowpea
    }
    var producesSun: Bool {
        if let f = fusion { return f == .sunPea || f == .sunNut }
        return type == .sunflower
    }
    var shootInterval: TimeInterval {
        if fusion == .gatlingPea { return 0.5 }
        return 1.5
    }
}

class ZombieEntity {
    var type: ZombieType
    var hp: Int
    var row: Int
    var node: SKNode
    var speed: CGFloat
    var frozenTimer: TimeInterval = 0
    var isDead = false

    init(type: ZombieType, row: Int, node: SKNode) {
        self.type = type
        self.hp = type.hp
        self.row = row
        self.node = node
        self.speed = type.speed
    }
}

class Projectile {
    var node: SKNode
    var row: Int
    var isIce: Bool
    var damage: Int
    var isDead = false

    init(node: SKNode, row: Int, isIce: Bool, damage: Int = 20) {
        self.node = node
        self.row = row
        self.isIce = isIce
        self.damage = damage
    }
}

class SunDrop {
    var node: SKNode
    var targetY: CGFloat
    var collected = false

    init(node: SKNode, targetY: CGFloat) {
        self.node = node
        self.targetY = targetY
    }
}

// MARK: - Game Scene

class GameScene: SKScene {
    let rows = 5
    let cols = 9
    let cellW: CGFloat = 85
    let cellH: CGFloat = 100
    let gridOffsetX: CGFloat = 180
    let gridOffsetY: CGFloat = 120

    var sun = 500
    var plants: [[PlantEntity?]] = []
    var zombies: [ZombieEntity] = []
    var projectiles: [Projectile] = []
    var sunDrops: [SunDrop] = []
    var selectedPlant: PlantType? = nil
    
    var sunLabel: SKLabelNode!
    var plantButtons: [SKNode] = []
    var selectionIndicator: SKShapeNode?
    weak var gameVC: GameViewController?
    var isGamePaused = false
    
    override func didMove(to view: SKView) {
        plants = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        setupBackground()
        setupHUD()
        setupPlantBar()
        startSpawning()
    }

    func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "lawn")
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.zPosition = -10
        // scale to fit
        bg.xScale = size.width / bg.size.width
        bg.yScale = size.height / bg.size.height
        if bg.texture == nil {
            backgroundColor = SKColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1)
        } else {
            addChild(bg)
        }
    }

    func setupHUD() {
        // Sun counter
        let sunIcon = SKSpriteNode(imageNamed: "sun")
        sunIcon.position = CGPoint(x: 50, y: size.height - 40)
        sunIcon.setScale(0.8)
        sunIcon.zPosition = 100
        addChild(sunIcon)

        sunLabel = SKLabelNode(text: "\(sun)")
        sunLabel.fontName = "Helvetica-Bold"
        sunLabel.fontSize = 28
        sunLabel.fontColor = .black
        sunLabel.position = CGPoint(x: 100, y: size.height - 50)
        sunLabel.zPosition = 100
        addChild(sunLabel)

        let quitBtn = SKLabelNode(text: "✖️")
        quitBtn.fontSize = 30
        quitBtn.position = CGPoint(x: size.width - 50, y: size.height - 50)
        quitBtn.zPosition = 100
        quitBtn.name = "quit"
        addChild(quitBtn)
    }

    func setupPlantBar() {
        let barY: CGFloat = size.height - 50
        let types: [PlantType] = [.sunflower, .peashooter, .wallnut, .snowpea, .cherrybomb]
        let startX: CGFloat = 200

        for (i, pt) in types.enumerated() {
            let card = SKSpriteNode(imageNamed: "seedpacket")
            if card.texture == nil {
                card.color = .brown
                card.size = CGSize(width: 60, height: 80)
            } else {
                card.setScale(0.7)
            }
            card.position = CGPoint(x: startX + CGFloat(i) * 70, y: barY)
            card.zPosition = 90
            card.name = "plant_\(pt.rawValue)"

            let icon = SKSpriteNode(imageNamed: pt.textureName)
            if icon.texture == nil {
                let lbl = SKLabelNode(text: "?")
                lbl.verticalAlignmentMode = .center
                icon.addChild(lbl)
            } else {
                icon.setScale(0.4)
            }
            icon.zPosition = 91
            icon.position = card.position
            icon.name = "plant_\(pt.rawValue)"
            addChild(icon)

            addChild(card)
            plantButtons.append(card)
        }
    }

    func gridPos(row: Int, col: Int) -> CGPoint {
        return CGPoint(x: gridOffsetX + CGFloat(col) * cellW + cellW/2,
                       y: gridOffsetY + CGFloat(rows - 1 - row) * cellH + cellH/2)
    }

    func gridCell(at point: CGPoint) -> (row: Int, col: Int)? {
        let c = Int((point.x - gridOffsetX) / cellW)
        let r = rows - 1 - Int((point.y - gridOffsetY) / cellH)
        if r >= 0 && r < rows && c >= 0 && c < cols { return (r, c) }
        return nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        let tapped = nodes(at: loc)
        if tapped.contains(where: { $0.name == "quit" }) {
            gameVC?.returnToMenu()
            return
        }

        // Collect Sun
        for sun in sunDrops where !sun.collected {
            if sun.node.frame.contains(loc) || sun.node.position.distance(to: loc) < 50 {
                collectSun(sun)
                return
            }
        }

        // Select Plant
        for node in tapped {
            if let name = node.name, name.hasPrefix("plant_") {
                let typeName = name.replacingOccurrences(of: "plant_", with: "")
                if let pt = PlantType(rawValue: typeName), self.sun >= pt.cost {
                    selectedPlant = pt
                    updateSelectionHighlight(node.position)
                }
                return
            }
        }

        // Place Plant
        if let (r, c) = gridCell(at: loc), let sp = selectedPlant {
            placePlant(sp, row: r, col: c)
        }
    }

    func updateSelectionHighlight(_ pos: CGPoint) {
        selectionIndicator?.removeFromParent()
        let highlight = SKShapeNode(rectOf: CGSize(width: 65, height: 85), cornerRadius: 4)
        highlight.strokeColor = .systemGreen
        highlight.lineWidth = 3
        highlight.position = pos
        highlight.zPosition = 101
        addChild(highlight)
        selectionIndicator = highlight
    }

    func placePlant(_ type: PlantType, row: Int, col: Int) {
        if let existing = plants[row][col] {
            if let existType = existing.type, let fusionResult = FusionType.fuse(existType, type) {
                sun -= type.cost
                existing.node.removeFromParent()
                spawnPlantNode(texture: fusionResult.textureName, row: row, col: col, isFusion: true)
                let plant = PlantEntity(fusion: fusionResult, row: row, col: col, node: plants[row][col]!.node) // wait, update ref
                plants[row][col] = plant
                selectedPlant = nil
                selectionIndicator?.removeFromParent()
                updateSun()
            }
            return
        }

        if type == .cherrybomb {
            sun -= type.cost
            cherrybombExplode(row: row, col: col)
            selectedPlant = nil
            selectionIndicator?.removeFromParent()
            updateSun()
            return
        }

        sun -= type.cost
        let node = spawnPlantNode(texture: type.textureName, row: row, col: col, isFusion: false)
        plants[row][col] = PlantEntity(type: type, row: row, col: col, node: node)
        
        selectedPlant = nil
        selectionIndicator?.removeFromParent()
        updateSun()
    }

    func spawnPlantNode(texture: String, row: Int, col: Int, isFusion: Bool) -> SKNode {
        let pos = gridPos(row: row, col: col)
        let sprite = SKSpriteNode(imageNamed: texture)
        sprite.position = pos
        sprite.zPosition = 10
        if sprite.texture == nil {
            sprite.color = .green
            sprite.size = CGSize(width: 50, height: 50)
        } else {
            sprite.setScale(isFusion ? 0.8 : 0.6)
        }
        addChild(sprite)
        
        sprite.setScale(0)
        sprite.run(SKAction.scale(to: isFusion ? 0.8 : 0.6, duration: 0.2))
        
        if isFusion {
            let flash = SKShapeNode(circleOfRadius: 60)
            flash.fillColor = .white
            flash.position = pos
            flash.zPosition = 50
            addChild(flash)
            flash.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
        }
        
        return sprite
    }

    func cherrybombExplode(row: Int, col: Int) {
        let center = gridPos(row: row, col: col)
        let boom = SKShapeNode(circleOfRadius: 120)
        boom.fillColor = .red
        boom.position = center
        boom.zPosition = 60
        addChild(boom)
        boom.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.4), SKAction.removeFromParent()]))

        for z in zombies {
            if abs(z.node.position.x - center.x) < 150 && abs(z.node.position.y - center.y) < 150 {
                z.hp = 0
            }
        }
    }

    func startSpawning() {
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 4.0),
            SKAction.run { [weak self] in self?.spawnZombie() }
        ])))
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 6.0),
            SKAction.run { [weak self] in self?.spawnSkySun() }
        ])))
    }

    func spawnZombie() {
        let row = Int.random(in: 0..<rows)
        let sprite = SKSpriteNode(imageNamed: "zombie")
        sprite.position = CGPoint(x: size.width + 50, y: gridPos(row: row, col: 0).y)
        sprite.zPosition = 15
        if sprite.texture == nil {
            sprite.color = .gray
            sprite.size = CGSize(width: 40, height: 80)
        } else {
            sprite.setScale(0.6)
        }
        addChild(sprite)
        zombies.append(ZombieEntity(type: .basic, row: row, node: sprite))
    }

    override func update(_ currentTime: TimeInterval) {
        if isGamePaused { return }
        let dt = 1.0 / 60.0

        // Plants
        for r in 0..<rows {
            for c in 0..<cols {
                guard let p = plants[r][c] else { continue }
                if p.canShoot {
                    p.shootTimer += dt
                    if p.shootTimer >= p.shootInterval {
                        p.shootTimer = 0
                        if zombies.contains(where: { $0.row == r && $0.node.position.x > p.node.position.x && !$0.isDead }) {
                            shootPea(from: p)
                        }
                    }
                }
                if p.producesSun {
                    p.sunTimer += dt
                    if p.sunTimer >= 8.0 {
                        p.sunTimer = 0
                        spawnSun(at: p.node.position)
                    }
                }
            }
        }

        // Zombies
        for z in zombies {
            z.node.position.x -= z.speed * dt
            if z.node.position.x < 50 {
                // Game Over logic here
            }
        }

        // Projectiles
        for p in projectiles {
            p.node.position.x += 300 * dt
            for z in zombies where z.row == p.row && !z.isDead {
                if abs(z.node.position.x - p.node.position.x) < 30 {
                    z.hp -= p.damage
                    p.isDead = true
                    if p.isIce { z.frozenTimer = 3.0 }
                    break
                }
            }
        }

        projectiles.removeAll { p in
            if p.isDead || p.node.position.x > size.width {
                p.node.removeFromParent()
                return true
            }
            return false
        }

        zombies.removeAll { z in
            if z.hp <= 0 {
                z.node.removeFromParent()
                return true
            }
            return false
        }
    }

    func shootPea(from plant: PlantEntity) {
        let node = SKSpriteNode(imageNamed: "bullet_pea")
        node.position = CGPoint(x: plant.node.position.x + 20, y: plant.node.position.y)
        node.zPosition = 12
        if node.texture == nil {
            node.color = plant.shootsIce ? .cyan : .green
            node.size = CGSize(width: 15, height: 15)
        }
        addChild(node)
        projectiles.append(Projectile(node: node, row: plant.row, isIce: plant.shootsIce, damage: plant.fusion == .gatlingPea ? 20 : 25))
    }

    func spawnSun(at pos: CGPoint) {
        let node = SKSpriteNode(imageNamed: "sun")
        node.position = pos
        node.zPosition = 20
        if node.texture == nil {
            node.color = .yellow
            node.size = CGSize(width: 40, height: 40)
        } else {
            node.setScale(0.5)
        }
        addChild(node)
        
        let drop = SunDrop(node: node, targetY: pos.y - 20)
        sunDrops.append(drop)
        node.run(SKAction.moveBy(x: CGFloat.random(in: -30...30), y: -30, duration: 0.5))
    }

    func spawnSkySun() {
        let x = CGFloat.random(in: 200...(size.width - 100))
        let node = SKSpriteNode(imageNamed: "sun")
        node.position = CGPoint(x: x, y: size.height + 50)
        node.zPosition = 20
        if node.texture == nil { node.color = .yellow; node.size = CGSize(width: 40, height: 40) } else { node.setScale(0.5) }
        addChild(node)
        
        let targetY = CGFloat.random(in: 100...400)
        let drop = SunDrop(node: node, targetY: targetY)
        sunDrops.append(drop)
        node.run(SKAction.moveTo(y: targetY, duration: 4.0))
    }

    func collectSun(_ drop: SunDrop) {
        drop.collected = true
        sun += 50
        updateSun()
        drop.node.run(SKAction.sequence([
            SKAction.move(to: CGPoint(x: 50, y: size.height - 40), duration: 0.3),
            SKAction.removeFromParent()
        ]))
    }

    func updateSun() {
        sunLabel.text = "\(sun)"
    }
}
