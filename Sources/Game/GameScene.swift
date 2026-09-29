import SpriteKit

// MARK: - Data Models

enum PlantType: String, CaseIterable {
    case sunflower, peashooter, wallnut, snowpea, cherrybomb
    var emoji: String {
        switch self {
        case .sunflower: return "🌻"
        case .peashooter: return "🌱"
        case .wallnut: return "🥜"
        case .snowpea: return "❄️"
        case .cherrybomb: return "🍒"
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
        case .wallnut: return 400
        default: return 100
        }
    }
    var cooldown: TimeInterval {
        switch self {
        case .sunflower: return 7.5
        case .peashooter: return 7.5
        case .wallnut: return 25
        case .snowpea: return 7.5
        case .cherrybomb: return 35
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

    var emoji: String {
        switch self {
        case .sunPea: return "☀️🔫"
        case .iceShooter: return "🧊"
        case .sunNut: return "☀️🛡"
        case .peaNut: return "🔫🛡"
        case .iceNut: return "🧊🛡"
        case .gatlingPea: return "💥🔫"
        }
    }
    var hp: Int {
        switch self {
        case .sunNut, .peaNut, .iceNut: return 600
        default: return 200
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
    var emoji: String {
        switch self {
        case .basic: return "🧟"
        case .cone: return "🧟‍♂️"
        case .bucket: return "🧟‍♀️"
        }
    }
    var hp: Int {
        switch self {
        case .basic: return 100
        case .cone: return 200
        case .bucket: return 450
        }
    }
    var speed: CGFloat {
        switch self {
        case .basic: return 18
        case .cone: return 22
        case .bucket: return 15
        }
    }
    var damage: Int { 20 }
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
    var isFrozenAura: Bool = false

    var displayEmoji: String {
        fusion?.emoji ?? type?.emoji ?? "?"
    }

    init(type: PlantType, row: Int, col: Int, node: SKNode) {
        self.type = type
        self.fusion = nil
        self.hp = type.hp
        self.row = row
        self.col = col
        self.node = node
    }

    init(fusion: FusionType, row: Int, col: Int, node: SKNode) {
        self.type = nil
        self.fusion = fusion
        self.hp = fusion.hp
        self.row = row
        self.col = col
        self.node = node
    }

    var canShoot: Bool {
        if let f = fusion {
            return [.sunPea, .iceShooter, .peaNut, .gatlingPea].contains(f)
        }
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

    var isWall: Bool {
        if let f = fusion { return [.sunNut, .peaNut, .iceNut].contains(f) }
        return type == .wallnut
    }

    var shootInterval: TimeInterval {
        if fusion == .gatlingPea { return 0.6 }
        return 1.8
    }
}

class ZombieEntity {
    var type: ZombieType
    var hp: Int
    var row: Int
    var x: CGFloat
    var node: SKNode
    var speed: CGFloat
    var eatTimer: TimeInterval = 0
    var frozenTimer: TimeInterval = 0
    var isDead = false

    init(type: ZombieType, row: Int, x: CGFloat, node: SKNode) {
        self.type = type
        self.hp = type.hp
        self.row = row
        self.x = x
        self.node = node
        self.speed = type.speed
    }

    var isFrozen: Bool { frozenTimer > 0 }
}

class Projectile {
    var node: SKNode
    var row: Int
    var x: CGFloat
    var isIce: Bool
    var damage: Int
    var isDead = false

    init(node: SKNode, row: Int, x: CGFloat, isIce: Bool, damage: Int = 25) {
        self.node = node
        self.row = row
        self.x = x
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

    // Grid config
    let rows = 5
    let cols = 9
    let cellW: CGFloat = 90
    let cellH: CGFloat = 110
    let gridOffsetX: CGFloat = 200
    let gridOffsetY: CGFloat = 120

    // State
    var sun = 150
    var plants: [[PlantEntity?]] = []
    var zombies: [ZombieEntity] = []
    var projectiles: [Projectile] = []
    var sunDrops: [SunDrop] = []
    var selectedPlant: PlantType? = nil
    var waveNumber = 1
    var zombiesRemaining = 0
    var totalWaves = 5
    var waveTimer: TimeInterval = 0
    var nextSpawnTime: TimeInterval = 8
    var gameOver = false
    var gameWon = false
    var isGamePaused = false
    var naturalSunTimer: TimeInterval = 0

    // UI nodes
    var sunLabel: SKLabelNode!
    var waveLabel: SKLabelNode!
    var plantButtons: [SKNode] = []
    var gridNodes: [[SKShapeNode]] = []
    var selectionIndicator: SKShapeNode?
    weak var gameVC: GameViewController?

    // MARK: - Setup

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.35, green: 0.65, blue: 0.2, alpha: 1)
        plants = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        setupBackground()
        setupGrid()
        setupHUD()
        setupPlantBar()
        startWave(1)
    }

    func setupBackground() {
        // Sky gradient
        let sky = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height * 0.4))
        sky.fillColor = SKColor(red: 0.4, green: 0.75, blue: 0.95, alpha: 1)
        sky.strokeColor = .clear
        sky.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        sky.zPosition = -10
        addChild(sky)

        // House
        let house = SKLabelNode(text: "🏠")
        house.fontSize = 60
        house.position = CGPoint(x: 100, y: size.height / 2)
        house.zPosition = -5
        addChild(house)

        // Lawn lines
        for r in 0..<rows {
            let y = gridY(row: r)
            let line = SKShapeNode(rectOf: CGSize(width: CGFloat(cols) * cellW, height: 1))
            line.fillColor = SKColor(white: 0, alpha: 0.1)
            line.strokeColor = .clear
            line.position = CGPoint(x: gridOffsetX + CGFloat(cols) * cellW / 2, y: y)
            line.zPosition = -1
            addChild(line)
        }
    }

    func setupGrid() {
        gridNodes = []
        for r in 0..<rows {
            var rowNodes: [SKShapeNode] = []
            for c in 0..<cols {
                let cell = SKShapeNode(rectOf: CGSize(width: cellW - 4, height: cellH - 4), cornerRadius: 8)
                let isEven = (r + c) % 2 == 0
                cell.fillColor = isEven
                    ? SKColor(red: 0.28, green: 0.55, blue: 0.15, alpha: 0.5)
                    : SKColor(red: 0.32, green: 0.60, blue: 0.18, alpha: 0.5)
                cell.strokeColor = SKColor(white: 1, alpha: 0.1)
                cell.lineWidth = 1
                cell.position = gridPos(row: r, col: c)
                cell.zPosition = 0
                cell.name = "cell_\(r)_\(c)"
                addChild(cell)
                rowNodes.append(cell)
            }
            gridNodes.append(rowNodes)
        }
    }

    func setupHUD() {
        // Sun counter
        let sunBg = SKShapeNode(rectOf: CGSize(width: 140, height: 50), cornerRadius: 12)
        sunBg.fillColor = SKColor(red: 0.9, green: 0.7, blue: 0.1, alpha: 0.9)
        sunBg.strokeColor = .clear
        sunBg.position = CGPoint(x: 90, y: size.height - 40)
        sunBg.zPosition = 100
        addChild(sunBg)

        let sunIcon = SKLabelNode(text: "☀️")
        sunIcon.fontSize = 28
        sunIcon.position = CGPoint(x: -40, y: -10)
        sunBg.addChild(sunIcon)

        sunLabel = SKLabelNode(text: "\(sun)")
        sunLabel.fontName = "Helvetica-Bold"
        sunLabel.fontSize = 24
        sunLabel.fontColor = .white
        sunLabel.position = CGPoint(x: 15, y: -9)
        sunBg.addChild(sunLabel)

        // Wave info
        waveLabel = SKLabelNode(text: "Волна 1/\(totalWaves)")
        waveLabel.fontName = "Helvetica-Bold"
        waveLabel.fontSize = 22
        waveLabel.fontColor = .white
        waveLabel.position = CGPoint(x: size.width / 2, y: size.height - 40)
        waveLabel.zPosition = 100
        addChild(waveLabel)

        // Pause button
        let pauseBtn = SKLabelNode(text: "⏸")
        pauseBtn.fontSize = 36
        pauseBtn.position = CGPoint(x: size.width - 50, y: size.height - 45)
        pauseBtn.zPosition = 100
        pauseBtn.name = "pause"
        addChild(pauseBtn)

        // Quit button
        let quitBtn = SKLabelNode(text: "✖️")
        quitBtn.fontSize = 30
        quitBtn.position = CGPoint(x: size.width - 50, y: size.height - 90)
        quitBtn.zPosition = 100
        quitBtn.name = "quit"
        addChild(quitBtn)
    }

    func setupPlantBar() {
        let barY: CGFloat = 50
        let types: [PlantType] = [.sunflower, .peashooter, .wallnut, .snowpea, .cherrybomb]
        let startX: CGFloat = size.width / 2 - CGFloat(types.count) * 55

        for (i, pt) in types.enumerated() {
            let card = SKShapeNode(rectOf: CGSize(width: 95, height: 80), cornerRadius: 12)
            card.fillColor = SKColor(red: 0.2, green: 0.15, blue: 0.1, alpha: 0.85)
            card.strokeColor = SKColor(white: 0.5, alpha: 0.5)
            card.lineWidth = 2
            card.position = CGPoint(x: startX + CGFloat(i) * 110, y: barY)
            card.zPosition = 100
            card.name = "plant_\(pt.rawValue)"

            let emoji = SKLabelNode(text: pt.emoji)
            emoji.fontSize = 36
            emoji.position = CGPoint(x: 0, y: 5)
            card.addChild(emoji)

            let costLabel = SKLabelNode(text: "☀️\(pt.cost)")
            costLabel.fontName = "Helvetica-Bold"
            costLabel.fontSize = 14
            costLabel.fontColor = sun >= pt.cost ? .systemYellow : .systemRed
            costLabel.position = CGPoint(x: 0, y: -28)
            costLabel.name = "cost_\(pt.rawValue)"
            card.addChild(costLabel)

            addChild(card)
            plantButtons.append(card)
        }
    }

    // MARK: - Grid Helpers

    func gridPos(row: Int, col: Int) -> CGPoint {
        let x = gridOffsetX + CGFloat(col) * cellW + cellW / 2
        let y = gridOffsetY + CGFloat(rows - 1 - row) * cellH + cellH / 2
        return CGPoint(x: x, y: y)
    }

    func gridY(row: Int) -> CGFloat {
        return gridOffsetY + CGFloat(rows - 1 - row) * cellH + cellH / 2
    }

    func gridCell(at point: CGPoint) -> (row: Int, col: Int)? {
        let c = Int((point.x - gridOffsetX) / cellW)
        let r = rows - 1 - Int((point.y - gridOffsetY) / cellH)
        if r >= 0 && r < rows && c >= 0 && c < cols { return (r, c) }
        return nil
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        if gameOver || gameWon { return }

        // Check pause/quit
        let tapped = nodes(at: loc)
        for n in tapped {
            if n.name == "pause" {
                isGamePaused.toggle()
                self.scene?.isPaused = isGamePaused
                return
            }
            if n.name == "quit" {
                gameVC?.returnToMenu()
                return
            }
        }

        if isGamePaused { return }

        // Check sun drops
        for sun in sunDrops where !sun.collected {
            if sun.node.frame.contains(loc) || sun.node.position.distance(to: loc) < 40 {
                collectSun(sun)
                return
            }
        }

        // Check plant bar
        for btn in plantButtons {
            if btn.contains(loc) {
                let name = btn.name ?? ""
                let typeName = name.replacingOccurrences(of: "plant_", with: "")
                if let pt = PlantType(rawValue: typeName) {
                    if self.sun >= pt.cost {
                        selectedPlant = pt
                        updateSelectionHighlight()
                    }
                }
                return
            }
        }

        // Check grid cell
        if let (r, c) = gridCell(at: loc), let sp = selectedPlant {
            placePlant(sp, row: r, col: c)
        }
    }

    func updateSelectionHighlight() {
        selectionIndicator?.removeFromParent()
        guard let sp = selectedPlant else { return }
        for btn in plantButtons {
            if btn.name == "plant_\(sp.rawValue)" {
                let highlight = SKShapeNode(rectOf: CGSize(width: 99, height: 84), cornerRadius: 14)
                highlight.strokeColor = .systemYellow
                highlight.lineWidth = 3
                highlight.fillColor = .clear
                highlight.zPosition = 101
                highlight.position = btn.position
                highlight.name = "selection"
                addChild(highlight)
                selectionIndicator = highlight
            }
        }
    }

    // MARK: - Plant Placement & Fusion

    func placePlant(_ type: PlantType, row: Int, col: Int) {
        if let existing = plants[row][col] {
            // Try fusion
            if let existType = existing.type, let fusionResult = FusionType.fuse(existType, type) {
                performFusion(fusionResult, row: row, col: col, existing: existing)
                return
            }
            // Can't place on occupied cell without fusion
            return
        }

        // Cherry bomb special: instant explosion
        if type == .cherrybomb {
            sun -= type.cost
            cherrybombExplode(row: row, col: col)
            selectedPlant = nil
            selectionIndicator?.removeFromParent()
            updateSunDisplay()
            return
        }

        // Normal placement
        sun -= type.cost
        let pos = gridPos(row: row, col: col)
        let node = SKNode()
        node.position = pos
        node.zPosition = 10

        let label = SKLabelNode(text: type.emoji)
        label.fontSize = 44
        label.verticalAlignmentMode = .center
        label.name = "plantEmoji"
        node.addChild(label)

        // HP bar
        let hpBg = SKShapeNode(rectOf: CGSize(width: 50, height: 6), cornerRadius: 3)
        hpBg.fillColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.7)
        hpBg.strokeColor = .clear
        hpBg.position = CGPoint(x: 0, y: -30)
        hpBg.name = "hpBg"
        node.addChild(hpBg)

        let hpBar = SKShapeNode(rectOf: CGSize(width: 48, height: 4), cornerRadius: 2)
        hpBar.fillColor = .systemGreen
        hpBar.strokeColor = .clear
        hpBar.position = CGPoint(x: 0, y: -30)
        hpBar.name = "hpBar"
        node.addChild(hpBar)

        addChild(node)

        // Spawn animation
        node.setScale(0)
        node.run(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.15),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))

        let plant = PlantEntity(type: type, row: row, col: col, node: node)
        plants[row][col] = plant

        selectedPlant = nil
        selectionIndicator?.removeFromParent()
        updateSunDisplay()
    }

    func performFusion(_ fusion: FusionType, row: Int, col: Int, existing: PlantEntity) {
        sun -= selectedPlant!.cost

        // Remove old
        existing.node.removeFromParent()

        // Create fusion node
        let pos = gridPos(row: row, col: col)
        let node = SKNode()
        node.position = pos
        node.zPosition = 10

        let label = SKLabelNode(text: fusion.emoji)
        label.fontSize = 38
        label.verticalAlignmentMode = .center
        label.name = "plantEmoji"
        node.addChild(label)

        let hpBg = SKShapeNode(rectOf: CGSize(width: 50, height: 6), cornerRadius: 3)
        hpBg.fillColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.7)
        hpBg.strokeColor = .clear
        hpBg.position = CGPoint(x: 0, y: -30)
        hpBg.name = "hpBg"
        node.addChild(hpBg)

        let hpBar = SKShapeNode(rectOf: CGSize(width: 48, height: 4), cornerRadius: 2)
        hpBar.fillColor = .systemCyan
        hpBar.strokeColor = .clear
        hpBar.position = CGPoint(x: 0, y: -30)
        hpBar.name = "hpBar"
        node.addChild(hpBar)

        addChild(node)

        // Fusion flash effect
        let flash = SKShapeNode(circleOfRadius: 60)
        flash.fillColor = .systemYellow
        flash.strokeColor = .clear
        flash.alpha = 0.8
        flash.zPosition = 50
        flash.position = pos
        addChild(flash)
        flash.run(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 2.0, duration: 0.3),
                SKAction.fadeOut(withDuration: 0.3)
            ]),
            SKAction.removeFromParent()
        ]))

        // Fusion label
        let fusionText = SKLabelNode(text: "⚡ FUSION! ⚡")
        fusionText.fontName = "Helvetica-Bold"
        fusionText.fontSize = 20
        fusionText.fontColor = .systemYellow
        fusionText.position = CGPoint(x: pos.x, y: pos.y + 50)
        fusionText.zPosition = 55
        addChild(fusionText)
        fusionText.run(SKAction.sequence([
            SKAction.group([
                SKAction.moveBy(x: 0, y: 40, duration: 0.8),
                SKAction.fadeOut(withDuration: 0.8)
            ]),
            SKAction.removeFromParent()
        ]))

        // Bounce in
        node.setScale(0)
        node.run(SKAction.sequence([
            SKAction.scale(to: 1.4, duration: 0.2),
            SKAction.scale(to: 1.0, duration: 0.15)
        ]))

        let plant = PlantEntity(fusion: fusion, row: row, col: col, node: node)
        plants[row][col] = plant

        selectedPlant = nil
        selectionIndicator?.removeFromParent()
        updateSunDisplay()
    }

    func cherrybombExplode(row: Int, col: Int) {
        let center = gridPos(row: row, col: col)

        // Explosion effect
        let boom = SKLabelNode(text: "💥")
        boom.fontSize = 120
        boom.position = center
        boom.zPosition = 60
        addChild(boom)
        boom.run(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 2.5, duration: 0.4),
                SKAction.fadeOut(withDuration: 0.5)
            ]),
            SKAction.removeFromParent()
        ]))

        // Damage zombies in 3x3
        for z in zombies {
            let zPos = z.node.position
            if abs(zPos.x - center.x) < cellW * 1.5 && abs(zPos.y - center.y) < cellH * 1.5 {
                z.hp = 0
            }
        }
    }

    // MARK: - Zombie Spawning

    func startWave(_ wave: Int) {
        waveNumber = wave
        waveLabel.text = "Волна \(wave)/\(totalWaves)"

        let baseCount = 3 + wave * 2
        zombiesRemaining = baseCount
        waveTimer = 0
        nextSpawnTime = 6

        // Spawn first zombie quickly
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.spawnZombie()
        }
    }

    func spawnZombie() {
        if zombiesRemaining <= 0 { return }
        zombiesRemaining -= 1

        let row = Int.random(in: 0..<rows)
        let type: ZombieType
        let roll = Int.random(in: 0..<100)
        if waveNumber >= 4 && roll < 20 {
            type = .bucket
        } else if waveNumber >= 2 && roll < 40 {
            type = .cone
        } else {
            type = .basic
        }

        let x = size.width + 40
        let y = gridY(row: row)

        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        node.zPosition = 15

        let emoji = SKLabelNode(text: type.emoji)
        emoji.fontSize = 44
        emoji.verticalAlignmentMode = .center
        node.addChild(emoji)

        // HP bar
        let hpBg = SKShapeNode(rectOf: CGSize(width: 40, height: 5), cornerRadius: 2)
        hpBg.fillColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.7)
        hpBg.strokeColor = .clear
        hpBg.position = CGPoint(x: 0, y: 28)
        hpBg.name = "hpBg"
        node.addChild(hpBg)

        let hpBar = SKShapeNode(rectOf: CGSize(width: 38, height: 3), cornerRadius: 1)
        hpBar.fillColor = .systemRed
        hpBar.strokeColor = .clear
        hpBar.position = CGPoint(x: 0, y: 28)
        hpBar.name = "hpBar"
        node.addChild(hpBar)

        addChild(node)

        let zombie = ZombieEntity(type: type, row: row, x: x, node: node)
        zombies.append(zombie)
    }

    // MARK: - Update Loop

    override func update(_ currentTime: TimeInterval) {
        if gameOver || gameWon || isGamePaused { return }

        let dt: TimeInterval = 1.0 / 60.0

        updatePlants(dt)
        updateZombies(dt)
        updateProjectiles(dt)
        updateSunDrops(dt)
        updateWaveSpawning(dt)
        updateNaturalSun(dt)
        cleanupDead()
        updateCostColors()
        checkWinLose()
    }

    func updatePlants(_ dt: TimeInterval) {
        for r in 0..<rows {
            for c in 0..<cols {
                guard let plant = plants[r][c] else { continue }

                // Shooting
                if plant.canShoot {
                    plant.shootTimer += dt
                    if plant.shootTimer >= plant.shootInterval {
                        plant.shootTimer = 0
                        // Only shoot if there's a zombie in this row ahead
                        let hasTarget = zombies.contains { $0.row == r && $0.node.position.x > plant.node.position.x && !$0.isDead }
                        if hasTarget {
                            shootPea(from: plant)
                        }
                    }
                }

                // Sun production
                if plant.producesSun {
                    plant.sunTimer += dt
                    if plant.sunTimer >= 8.0 {
                        plant.sunTimer = 0
                        produceSun(at: plant.node.position)
                    }
                }

                // Ice nut aura: freeze nearby zombies
                if plant.fusion == .iceNut {
                    for z in zombies where z.row == r && !z.isDead {
                        if abs(z.node.position.x - plant.node.position.x) < cellW * 1.2 {
                            z.frozenTimer = 2.0
                        }
                    }
                }
            }
        }
    }

    func shootPea(from plant: PlantEntity) {
        let pos = plant.node.position
        let node = SKShapeNode(circleOfRadius: plant.fusion == .gatlingPea ? 7 : 8)
        node.fillColor = plant.shootsIce ? .cyan : .systemGreen
        node.strokeColor = plant.shootsIce ? .white : .darkGray
        node.lineWidth = 1
        node.position = CGPoint(x: pos.x + 30, y: pos.y)
        node.zPosition = 12

        // Glow effect for ice
        if plant.shootsIce {
            node.glowWidth = 3
        }

        addChild(node)

        let dmg = plant.fusion == .gatlingPea ? 20 : 25
        let proj = Projectile(node: node, row: plant.row, x: pos.x + 30, isIce: plant.shootsIce, damage: dmg)
        projectiles.append(proj)
    }

    func produceSun(at pos: CGPoint) {
        let sunNode = SKLabelNode(text: "☀️")
        sunNode.fontSize = 30
        let offsetX = CGFloat.random(in: -30...30)
        let offsetY = CGFloat.random(in: 20...60)
        sunNode.position = CGPoint(x: pos.x + offsetX, y: pos.y + offsetY)
        sunNode.zPosition = 50
        addChild(sunNode)

        // Bounce animation
        sunNode.run(SKAction.sequence([
            SKAction.moveBy(x: 0, y: 20, duration: 0.3),
            SKAction.moveBy(x: 0, y: -20, duration: 0.3)
        ]))

        let drop = SunDrop(node: sunNode, targetY: pos.y - 30)
        sunDrops.append(drop)
    }

    func updateNaturalSun(_ dt: TimeInterval) {
        naturalSunTimer += dt
        if naturalSunTimer >= 10.0 {
            naturalSunTimer = 0
            let x = CGFloat.random(in: gridOffsetX...(gridOffsetX + CGFloat(cols) * cellW))
            let y = size.height + 20
            let sunNode = SKLabelNode(text: "☀️")
            sunNode.fontSize = 30
            sunNode.position = CGPoint(x: x, y: y)
            sunNode.zPosition = 50
            addChild(sunNode)

            let targetY = CGFloat.random(in: gridOffsetY...(gridOffsetY + CGFloat(rows) * cellH))
            sunNode.run(SKAction.moveTo(y: targetY, duration: 3.0))

            let drop = SunDrop(node: sunNode, targetY: targetY)
            sunDrops.append(drop)
        }
    }

    func collectSun(_ sunDrop: SunDrop) {
        sunDrop.collected = true
        sun += 25
        updateSunDisplay()

        // Fly to counter animation
        sunDrop.node.run(SKAction.sequence([
            SKAction.group([
                SKAction.move(to: CGPoint(x: 90, y: size.height - 40), duration: 0.3),
                SKAction.scale(to: 0.3, duration: 0.3)
            ]),
            SKAction.removeFromParent()
        ]))
    }

    func updateZombies(_ dt: TimeInterval) {
        for z in zombies where !z.isDead {
            // Frozen slowdown
            if z.isFrozen {
                z.frozenTimer -= dt
                z.node.alpha = 0.7
            } else {
                z.node.alpha = 1.0
            }

            let effectiveSpeed = z.isFrozen ? z.speed * 0.4 : z.speed

            // Check if eating a plant
            let col = Int((z.node.position.x - gridOffsetX) / cellW)
            if col >= 0 && col < cols, let plant = plants[z.row][col] {
                let plantX = gridPos(row: z.row, col: col).x
                if abs(z.node.position.x - plantX) < cellW * 0.5 {
                    // Eating
                    z.eatTimer += dt
                    if z.eatTimer >= 0.5 {
                        z.eatTimer = 0
                        plant.hp -= z.type.damage
                        updatePlantHP(plant)
                        if plant.hp <= 0 {
                            plant.node.removeFromParent()
                            plants[z.row][col] = nil
                        }
                    }
                    continue // Don't move while eating
                }
            }

            // Move
            z.x -= effectiveSpeed * CGFloat(dt)
            z.node.position.x = z.x

            // Update HP bar
            updateZombieHP(z)
        }
    }

    func updateProjectiles(_ dt: TimeInterval) {
        let speed: CGFloat = 350

        for p in projectiles where !p.isDead {
            p.x += speed * CGFloat(dt)
            p.node.position.x = p.x

            // Off screen
            if p.x > size.width + 20 {
                p.isDead = true
                p.node.removeFromParent()
                continue
            }

            // Hit zombie
            for z in zombies where z.row == p.row && !z.isDead {
                if abs(z.node.position.x - p.x) < 25 {
                    z.hp -= p.damage
                    if p.isIce { z.frozenTimer = 3.0 }
                    p.isDead = true
                    p.node.removeFromParent()

                    // Hit effect
                    let hit = SKShapeNode(circleOfRadius: 12)
                    hit.fillColor = p.isIce ? .cyan : .white
                    hit.strokeColor = .clear
                    hit.alpha = 0.8
                    hit.position = z.node.position
                    hit.zPosition = 20
                    addChild(hit)
                    hit.run(SKAction.sequence([
                        SKAction.group([
                            SKAction.scale(to: 2.0, duration: 0.15),
                            SKAction.fadeOut(withDuration: 0.15)
                        ]),
                        SKAction.removeFromParent()
                    ]))

                    updateZombieHP(z)
                    break
                }
            }
        }
    }

    func updateSunDrops(_ dt: TimeInterval) {
        sunDrops.removeAll { drop in
            if drop.collected { return drop.node.parent == nil }
            // Auto-remove after 8 seconds (simple timeout via position check)
            return false
        }
    }

    func updateWaveSpawning(_ dt: TimeInterval) {
        waveTimer += dt
        if waveTimer >= nextSpawnTime && zombiesRemaining > 0 {
            spawnZombie()
            nextSpawnTime = waveTimer + Double.random(in: 3...7)
        }

        // Check wave complete
        if zombiesRemaining <= 0 && zombies.allSatisfy({ $0.isDead }) {
            if waveNumber < totalWaves {
                startWave(waveNumber + 1)
            }
        }
    }

    func cleanupDead() {
        for z in zombies where !z.isDead && z.hp <= 0 {
            z.isDead = true
            z.node.run(SKAction.sequence([
                SKAction.group([
                    SKAction.fadeOut(withDuration: 0.3),
                    SKAction.moveBy(x: 0, y: -20, duration: 0.3)
                ]),
                SKAction.removeFromParent()
            ]))
        }
        projectiles.removeAll { $0.isDead }
    }

    func checkWinLose() {
        // Lose: zombie reached left edge
        for z in zombies where !z.isDead {
            if z.x < gridOffsetX - 40 {
                gameOver = true
                showResult(won: false)
                return
            }
        }

        // Win: all waves done and all zombies dead
        if waveNumber >= totalWaves && zombiesRemaining <= 0 && zombies.allSatisfy({ $0.isDead }) {
            gameWon = true
            showResult(won: true)
        }
    }

    // MARK: - UI Updates

    func updateSunDisplay() {
        sunLabel.text = "\(sun)"
    }

    func updateCostColors() {
        for btn in plantButtons {
            let name = btn.name ?? ""
            let typeName = name.replacingOccurrences(of: "plant_", with: "")
            if let pt = PlantType(rawValue: typeName) {
                if let costLabel = btn.childNode(withName: "cost_\(typeName)") as? SKLabelNode {
                    costLabel.fontColor = sun >= pt.cost ? .systemYellow : .systemRed
                }
            }
        }
    }

    func updatePlantHP(_ plant: PlantEntity) {
        let maxHP: CGFloat = CGFloat(plant.fusion?.hp ?? plant.type?.hp ?? 100)
        let ratio = max(0, CGFloat(plant.hp) / maxHP)
        if let bar = plant.node.childNode(withName: "hpBar") as? SKShapeNode {
            bar.xScale = ratio
            bar.fillColor = ratio > 0.5 ? .systemGreen : (ratio > 0.25 ? .systemOrange : .systemRed)
        }
    }

    func updateZombieHP(_ z: ZombieEntity) {
        let maxHP = CGFloat(z.type.hp)
        let ratio = max(0, CGFloat(z.hp) / maxHP)
        if let bar = z.node.childNode(withName: "hpBar") as? SKShapeNode {
            bar.xScale = ratio
        }
    }

    func showResult(won: Bool) {
        let overlay = SKShapeNode(rectOf: size)
        overlay.fillColor = SKColor(white: 0, alpha: 0.7)
        overlay.strokeColor = .clear
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 200
        addChild(overlay)

        let title = SKLabelNode(text: won ? "🎉 ПОБЕДА! 🎉" : "💀 ПОРАЖЕНИЕ 💀")
        title.fontName = "Helvetica-Bold"
        title.fontSize = 48
        title.fontColor = won ? .systemGreen : .systemRed
        title.position = CGPoint(x: 0, y: 60)
        overlay.addChild(title)

        let sub = SKLabelNode(text: won ? "Зомби повержены!" : "Зомби добрались до дома...")
        sub.fontName = "Helvetica"
        sub.fontSize = 24
        sub.fontColor = .white
        sub.position = CGPoint(x: 0, y: 10)
        overlay.addChild(sub)

        let menuBtn = SKLabelNode(text: "🏠 В Меню")
        menuBtn.fontName = "Helvetica-Bold"
        menuBtn.fontSize = 28
        menuBtn.fontColor = .systemYellow
        menuBtn.position = CGPoint(x: -100, y: -60)
        menuBtn.name = "quit"
        overlay.addChild(menuBtn)

        let retryBtn = SKLabelNode(text: "🔄 Ещё раз")
        retryBtn.fontName = "Helvetica-Bold"
        retryBtn.fontSize = 28
        retryBtn.fontColor = .systemGreen
        retryBtn.position = CGPoint(x: 100, y: -60)
        retryBtn.name = "retry"
        overlay.addChild(retryBtn)

        overlay.setScale(0)
        overlay.run(SKAction.scale(to: 1, duration: 0.3))
    }
}

// MARK: - Helpers

extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        return hypot(x - other.x, y - other.y)
    }
}
