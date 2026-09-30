import SpriteKit

// MARK: - Data Models

enum PlantType: String, CaseIterable {
    case sunflower, peashooter, wallnut, snowpea, cherrybomb
    case potatomine, chomper, puffshroom, torchwood, tallnut, squash, repeater
    case sunshroom, fumeshroom, threepeater, jalapeno, melonpult, cabbagepult

    var textureName: String {
        return self.rawValue
    }
    var cost: Int {
        switch self {
        case .sunflower: return 50
        case .peashooter: return 100
        case .wallnut: return 50
        case .snowpea: return 175
        case .cherrybomb: return 150
        case .potatomine: return 25
        case .chomper: return 150
        case .puffshroom: return 0
        case .torchwood: return 175
        case .tallnut: return 125
        case .squash: return 50
        case .repeater: return 200
        case .sunshroom: return 25
        case .fumeshroom: return 75
        case .threepeater: return 325
        case .jalapeno: return 125
        case .melonpult: return 300
        case .cabbagepult: return 100
        }
    }
    var hp: Int {
        switch self {
        case .wallnut: return 4000
        case .tallnut: return 8000
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
    case bigChomper   // chomper + chomper (or wallnut)
    case allPeater    // repeater + snowpea + peashooter
    case winterMelon  // melon + snowpea
    case fumePea      // fumeshroom + peashooter
    case firePea      // torchwood + peashooter
    case chomperPea   // chomper + peashooter
    case squashBomb   // squash + cherrybomb

    var textureName: String {
        switch self {
        case .sunPea: return "sunpea"
        case .iceShooter: return "snowpea"
        case .sunNut: return "sunnut"
        case .peaNut: return "peanut"
        case .iceNut: return "icenut"
        case .gatlingPea: return "gatlingpea"
        case .bigChomper: return "bigchomper"
        case .allPeater: return "allpeater"
        case .winterMelon: return "wintermelon"
        case .fumePea: return "fumepea"
        case .firePea: return "firepea"
        case .chomperPea: return "chomperpea"
        case .squashBomb: return "squashbomb"
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
        if pair == [.chomper, .wallnut] { return .bigChomper }
        if pair == [.repeater, .snowpea] { return .allPeater }
        if pair == [.melonpult, .snowpea] { return .winterMelon }
        if pair == [.fumeshroom, .peashooter] { return .fumePea }
        if pair == [.torchwood, .peashooter] { return .firePea }
        if pair == [.chomper, .peashooter] { return .chomperPea }
        if pair == [.squash, .cherrybomb] { return .squashBomb }
        return nil
    }
}

enum ZombieType {
    case basic, cone, bucket, flag, football
    var textureName: String {
        switch self {
        case .basic: return "zombie"
        case .cone: return "conezombie"
        case .bucket: return "bucketzombie"
        case .flag: return "flagzombie"
        case .football: return "footballzombie"
        }
    }
    var hp: Int {
        switch self {
        case .basic: return 200
        case .cone: return 560
        case .bucket: return 1300
        case .flag: return 200
        case .football: return 1600
        }
    }
    var speed: CGFloat {
        switch self {
        case .basic: return 15
        case .cone: return 16
        case .bucket: return 14
        case .flag: return 22
        case .football: return 28
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
        if let f = fusion { return [.sunPea, .iceShooter, .peaNut, .gatlingPea, .allPeater, .winterMelon, .fumePea, .firePea, .chomperPea].contains(f) }
        return type == .peashooter || type == .snowpea || type == .repeater || type == .threepeater || type == .fumeshroom || type == .melonpult || type == .cabbagepult || type == .puffshroom
    }
    var shootsIce: Bool {
        if let f = fusion { return f == .iceShooter || f == .iceNut || f == .winterMelon }
        return type == .snowpea
    }
    var producesSun: Bool {
        if let f = fusion { return f == .sunPea || f == .sunNut }
        return type == .sunflower || type == .sunshroom
    }
    var shootInterval: TimeInterval {
        if fusion == .gatlingPea { return 0.4 }
        if type == .repeater || fusion == .allPeater { return 0.8 }
        return 1.4
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

class MowerEntity {
    var row: Int
    var node: SKNode
    var isActive = false
    var isDead = false

    init(row: Int, node: SKNode) {
        self.row = row
        self.node = node
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
    var mowers: [MowerEntity] = []
    var selectedPlant: PlantType? = nil
    var isShovelSelected = false
    var shovelIcon: SKSpriteNode?
    var shovelBank: SKSpriteNode?
    
    var selectedSeeds: [PlantType] = PlantType.allCases
    
    var sunLabel: SKLabelNode!
    var plantButtons: [SKNode] = []
    var selectionIndicator: SKShapeNode?
    weak var gameVC: GameViewController?
    var isGamePaused = false
    
    var totalZombiesToSpawn = 0
    var zombiesSpawned = 0
    var isLevelComplete = false
    
    override func didMove(to view: SKView) {
        totalZombiesToSpawn = LevelManager.shared.getZombieCountForCurrentLevel()
        
        plants = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        setupBackground()
        setupHUD()
        setupPlantBar()
        setupMowers()
        startSpawning()
    }
    
    func setupMowers() {
        for row in 0..<rows {
            let mower = SKSpriteNode(imageNamed: "mower")
            mower.setScale(0.7)
            let my = gridOffsetY + CGFloat(row) * cellH + cellH / 2
            let mx = gridOffsetX - 80
            mower.position = CGPoint(x: mx, y: my)
            mower.zPosition = 50
            addChild(mower)
            mowers.append(MowerEntity(row: row, node: mower))
        }
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
        let seedBankBg = SKSpriteNode(imageNamed: "seedbank")
        seedBankBg.anchorPoint = CGPoint(x: 0, y: 1)
        seedBankBg.position = CGPoint(x: 0, y: size.height)
        seedBankBg.zPosition = 80
        seedBankBg.setScale(0.8)
        addChild(seedBankBg)

        // Sun counter
        let sunIcon = SKSpriteNode(imageNamed: "sun")
        sunIcon.position = CGPoint(x: 50, y: size.height - 45)
        sunIcon.setScale(0.7)
        sunIcon.zPosition = 100
        addChild(sunIcon)

        sunLabel = SKLabelNode(text: "\(sun)")
        sunLabel.fontName = "Helvetica-Bold"
        sunLabel.fontSize = 24
        sunLabel.fontColor = .black
        sunLabel.position = CGPoint(x: 50, y: size.height - 85)
        sunLabel.zPosition = 100
        addChild(sunLabel)

        let quitBtn = SKLabelNode(text: "Menu")
        quitBtn.fontName = "Helvetica-Bold"
        quitBtn.fontSize = 24
        quitBtn.fontColor = .white
        quitBtn.position = CGPoint(x: size.width - 60, y: size.height - 40)
        quitBtn.zPosition = 100
        quitBtn.name = "quit"
        addChild(quitBtn)
        
        let sbank = SKSpriteNode(imageNamed: "shovelbank")
        sbank.position = CGPoint(x: size.width - 150, y: size.height - 50)
        sbank.zPosition = 100
        sbank.setScale(0.8)
        addChild(sbank)
        shovelBank = sbank
        
        let shovel = SKSpriteNode(imageNamed: "shovel")
        shovel.position = sbank.position
        shovel.zPosition = 101
        shovel.setScale(0.8)
        shovel.name = "shovel"
        addChild(shovel)
        shovelIcon = shovel
    }

    func setupPlantBar() {
        let types = selectedSeeds
        let startX: CGFloat = 130
        
        for (i, pt) in types.enumerated() {
            let row = i / 7
            let col = i % 7
            let bx = startX + CGFloat(col) * 70
            let by = size.height - 40 - CGFloat(row) * 90
            
            let card = SKSpriteNode(imageNamed: "seedpacket")
            if card.texture == nil {
                card.color = .brown
                card.size = CGSize(width: 60, height: 80)
            } else {
                card.setScale(0.7)
            }
            card.position = CGPoint(x: bx, y: by)
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
            let dist = hypot(sun.node.position.x - loc.x, sun.node.position.y - loc.y)
            if sun.node.frame.contains(loc) || dist < 50 {
                collectSun(sun)
                return
            }
        }

        // Shovel Tool
        if tapped.contains(where: { $0.name == "shovel" }) {
            isShovelSelected = true
            selectedPlant = nil
            shovelIcon?.position = loc
            selectionIndicator?.removeFromParent()
            return
        }
        
        if isShovelSelected {
            if let (r, c) = gridCell(at: loc), let existing = plants[r][c] {
                existing.node.removeFromParent()
                plants[r][c] = nil
            }
            isShovelSelected = false
            shovelIcon?.position = shovelBank?.position ?? .zero
            return
        }

        // Select Plant
        for node in tapped {
            if let name = node.name, name.hasPrefix("plant_") {
                let typeName = name.replacingOccurrences(of: "plant_", with: "")
                if let pt = PlantType(rawValue: typeName), self.sun >= pt.cost {
                    selectedPlant = pt
                    isShovelSelected = false
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)
        if isShovelSelected {
            shovelIcon?.position = loc
        }
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

        if type == .jalapeno {
            sun -= type.cost
            jalapenoBurn(row: row)
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

    func jalapenoBurn(row: Int) {
        let y = gridPos(row: row, col: 0).y
        let fire = SKShapeNode(rectOf: CGSize(width: size.width, height: cellH))
        fire.fillColor = SKColor.orange.withAlphaComponent(0.8)
        fire.strokeColor = .red
        fire.position = CGPoint(x: size.width / 2, y: y)
        fire.zPosition = 60
        addChild(fire)
        fire.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.6),
            SKAction.removeFromParent()
        ]))

        for z in zombies where z.row == row {
            z.hp = 0
            z.isDead = true
        }
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
        var waveActions: [SKAction] = []
        var remaining = totalZombiesToSpawn
        var waveDelay = 15.0
        
        while remaining > 0 {
            let toSpawn = min(remaining, Int.random(in: 2...5))
            remaining -= toSpawn
            waveActions.append(SKAction.wait(forDuration: waveDelay))
            waveActions.append(SKAction.run { [weak self] in self?.spawnWave(count: toSpawn) })
            waveDelay = 20.0
        }
        
        run(SKAction.sequence(waveActions))
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 6.0),
            SKAction.run { [weak self] in self?.spawnSkySun() }
        ])))
    }

    func spawnWave(count: Int) {
        for _ in 0..<count {
            if zombiesSpawned >= totalZombiesToSpawn { break }
            zombiesSpawned += 1
            
            let delay = Double.random(in: 0...5)
            run(SKAction.sequence([
                SKAction.wait(forDuration: delay),
                SKAction.run { [weak self] in self?.spawnZombie() }
            ]))
        }
    }

    func spawnZombie() {
        let row = Int.random(in: 0..<rows)
        let roll = Double.random(in: 0...1)
        let type: ZombieType
        if roll < 0.40 {
            type = .basic
        } else if roll < 0.68 {
            type = .cone
        } else if roll < 0.85 {
            type = .bucket
        } else if roll < 0.94 {
            type = .football
        } else {
            type = .flag
        }

        let sprite = SKSpriteNode(imageNamed: type.textureName)
        sprite.position = CGPoint(x: size.width + 50, y: gridPos(row: row, col: 0).y)
        sprite.zPosition = 15
        if sprite.texture == nil {
            sprite.color = .gray
            sprite.size = CGSize(width: 40, height: 80)
        } else {
            sprite.setScale(0.6)
        }
        addChild(sprite)
        zombies.append(ZombieEntity(type: type, row: row, node: sprite))
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
        for z in Array(zombies) where !z.isDead {
            // Mower collision
            if let mower = mowers.first(where: { $0.row == z.row && !$0.isDead }) {
                if !mower.isActive && z.node.position.x < mower.node.position.x + 30 {
                    mower.isActive = true
                }
                
                if mower.isActive && abs(mower.node.position.x - z.node.position.x) < 40 {
                    z.isDead = true
                    z.node.run(SKAction.sequence([
                        SKAction.fadeOut(withDuration: 0.5),
                        SKAction.removeFromParent()
                    ]))
                }
            }

            var collided = false
            let cx = Int((z.node.position.x - gridOffsetX) / cellW)
            if cx >= 0 && cx < cols {
                if let plant = plants[z.row][cx] {
                    collided = true
                    plant.hp -= 1 // Simplified eating, assuming 60 ticks per sec
                    if plant.hp <= 0 {
                        plant.node.removeFromParent()
                        plants[z.row][cx] = nil
                    }
                }
            }
            
            if !collided {
                z.node.position.x -= z.speed * dt
            }

            if z.node.position.x < 50 {
                gameOver()
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
            if z.hp <= 0 || z.isDead {
                z.node.removeFromParent()
                return true
            }
            return false
        }
        
        // Mower Movement
        for m in mowers where m.isActive && !m.isDead {
            m.node.position.x += dt * 300
            if m.node.position.x > size.width + 100 {
                m.isDead = true
                m.node.removeFromParent()
            }
        }
        
        mowers.removeAll { $0.isDead }
        
        if zombiesSpawned >= totalZombiesToSpawn && zombies.isEmpty && !isLevelComplete {
            isLevelComplete = true
            levelComplete()
        }
    }
    
    func gameOver() {
        if isGamePaused { return }
        isGamePaused = true
        
        let label = SKLabelNode(text: "THE ZOMBIES ATE YOUR BRAINS!")
        label.fontName = "Helvetica-Bold"
        label.fontSize = 40
        label.fontColor = .red
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        label.zPosition = 1000
        addChild(label)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run { [weak self] in self?.gameVC?.returnToMenu() }
        ]))
    }
    
    func levelComplete() {
        if isGamePaused { return }
        isGamePaused = true
        
        let label = SKLabelNode(text: "LEVEL COMPLETE!")
        label.fontName = "Helvetica-Bold"
        label.fontSize = 50
        label.fontColor = .yellow
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        label.zPosition = 1000
        addChild(label)
        
        LevelManager.shared.completeLevel()
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run { [weak self] in self?.gameVC?.returnToMenu() }
        ]))
    }

    func shootPea(from plant: PlantEntity) {
        if plant.type == .threepeater {
            for r in [plant.row - 1, plant.row, plant.row + 1] where r >= 0 && r < rows {
                spawnProjectile(row: r, startPos: plant.node.position, isIce: plant.shootsIce, damage: 25)
            }
            return
        }
        
        let count = (plant.fusion == .gatlingPea) ? 4 : ((plant.type == .repeater || plant.fusion == .allPeater) ? 2 : 1)
        for i in 0..<count {
            run(SKAction.sequence([
                SKAction.wait(forDuration: Double(i) * 0.15),
                SKAction.run { [weak self] in
                    self?.spawnProjectile(row: plant.row, startPos: plant.node.position, isIce: plant.shootsIce, damage: (plant.fusion == .gatlingPea ? 30 : 25))
                }
            ]))
        }
    }

    func spawnProjectile(row: Int, startPos: CGPoint, isIce: Bool, damage: Int) {
        let node = SKSpriteNode(imageNamed: "bullet_pea")
        node.position = CGPoint(x: startPos.x + 20, y: gridPos(row: row, col: 0).y)
        node.zPosition = 12
        if node.texture == nil {
            node.color = isIce ? .cyan : .green
            node.size = CGSize(width: 15, height: 15)
        }
        addChild(node)
        projectiles.append(Projectile(node: node, row: row, isIce: isIce, damage: damage))
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
