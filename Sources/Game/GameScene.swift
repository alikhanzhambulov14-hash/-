import SpriteKit
import UIKit

// MARK: - PvZ Fusion: Complete Game Engine
// Based on: Plants vs Zombies Fusion mechanics
// Grid: 5 rows × 9 columns (landscape)
// Fusion: place same plant on existing = hybrid
// Sun economy: starts 50, sky drops every 8s, sunflower every 24s
// Zombies: walk left, eat plants, die to bullets
// Mowers: one per row, activated when zombie reaches col -1

// MARK: - Grid Constants
struct Grid {
    static let rows    = 5
    static let cols    = 9
    static let cellW: CGFloat = 86
    static let cellH: CGFloat = 96
    // Grid starts at x=120 (leave room for mowers), y=50 from bottom
    static let originX: CGFloat = 120
    static let originY: CGFloat = 50
    static let seedBarH: CGFloat = 84
    static let hudH: CGFloat     = 50

    static func pos(row: Int, col: Int) -> CGPoint {
        CGPoint(
            x: originX + CGFloat(col) * cellW + cellW / 2,
            y: originY + CGFloat(row) * cellH + cellH / 2
        )
    }
    static func cell(at pt: CGPoint) -> (row: Int, col: Int)? {
        let c = Int((pt.x - originX) / cellW)
        let r = Int((pt.y - originY) / cellH)
        guard r >= 0 && r < rows && c >= 0 && c < cols else { return nil }
        return (r, c)
    }
}

// MARK: - Plant Kind
enum Plant: String, CaseIterable {
    // ─── Shooting ───────────────────────────────────────────────
    case peashooter       // shoots 1 pea/1.5s, 20dmg
    case snowpea          // frozen pea, slows zombie 50%
    case repeater         // shoots 2 peas/1.5s
    case threepeater      // shoots 3 rows
    case splitpea         // shoots front & back
    case torchwood        // turns peas into firepeas (2x dmg)
    case cactus           // shoots spikes, pops balloons
    case cattail          // tracks any zombie anywhere
    case starfruit        // shoots 5 stars in 5 directions
    case spikerock        // ground spikes, 9 dmg each pass
    case cabbagepult      // lobbed cabbage 40dmg
    case kernelpult       // kernels 10dmg, butter 400dmg
    case melonpult        // lobs melon 80dmg splash
    case wintermelon      // lobs icy melon, splash + slow
    case gloombshroom     // 4-directional AOE shroom, 4dmg
    case spikeweed        // ground, 1dmg each pass
    // ─── Defense ────────────────────────────────────────────────
    case wallnut          // 4000hp wall
    case tallnut          // 8000hp, blocks vaulters
    case pumpkin          // shell protects any plant inside
    case magnetshroom     // removes metal gear from zombies
    // ─── Sun Production ─────────────────────────────────────────
    case sunflower        // 25sun every 24s
    case twinsunflower    // 50sun every 24s
    case sunshroom        // 7→25→50 sun growing over time
    case marigold         // coins, useful in zen garden
    // ─── Instant / Boom ─────────────────────────────────────────
    case cherrybomb       // 3×3 AOE, 1800dmg
    case jalapeno         // full row nuke
    case squash           // jumps on nearest zombie 1800dmg
    case potatomine       // underground 1800dmg, arms in 14s
    case doomshroom       // huge AOE 1800dmg, leaves crater
    case iceshroom        // freeze all zombies 5s
    case cherryjalapeno   // FUSION: full screen nuke
    // ─── Utility ────────────────────────────────────────────────
    case lilypad          // platform for pool (row 2,3)
    case flowerpot        // platform for roof
    case fumeshroom       // AOE 20dmg adjacent
    case chomper          // eats zombie (30s cooldown)
    case hypnoshroom      // mind-controls zombie
    case scaredy          // hides when zombie near, then shoots
    case sunbeanshroom    // drops sun when hit
    case imitater         // copy any plant, instant-use

    // ─── Fusions (results of combining two plants) ───────────────
    case peaSnow          // peashooter + snowpea = ice pea
    case peaNut           // peashooter + wallnut = shooting wall
    case sunshooter       // peashooter + sunflower = sun+shoot
    case gatlingpea       // repeater + repeater = 4 peas
    case spikernut        // wallnut + spikeweed = rolling nut
    case iceMelon         // wintermelon + iceshroom = mega freeze
    case superMelon       // melonpult + watermelon = 120dmg
    case firepeater       // threepeater + jalapeno = fire 3rows
    case tallWall         // wallnut + tallnut = mega wall 12000hp
    case hypnoPuff        // fumeshroom + hypnoshroom = mind AOE
    case doomCherry       // cherrybomb + doomshroom = HUGE AOE

    // ────────────────────────────────────────────────────────────
    var displayName: String {
        switch self {
        case .peashooter:   return "Горошина"
        case .snowpea:      return "Снежная горошина"
        case .repeater:     return "Повторитель"
        case .threepeater:  return "Трёхстрелок"
        case .splitpea:     return "Двусторонняя"
        case .torchwood:    return "Факел"
        case .cactus:       return "Кактус"
        case .cattail:      return "Рогоз"
        case .starfruit:    return "Звёздный фрукт"
        case .spikerock:    return "Шипы"
        case .cabbagepult:  return "Катапульта"
        case .kernelpult:   return "Кукуруза"
        case .melonpult:    return "Арбузник"
        case .wintermelon:  return "Ледяной арбуз"
        case .gloombshroom: return "Угрюм-гриб"
        case .spikeweed:    return "Шиповник"
        case .wallnut:      return "Орех"
        case .tallnut:      return "Высокий орех"
        case .pumpkin:      return "Тыква"
        case .magnetshroom: return "Магнит-гриб"
        case .sunflower:    return "Подсолнух"
        case .twinsunflower:return "Двойной подсолнух"
        case .sunshroom:    return "Гриб-солнце"
        case .marigold:     return "Ноготок"
        case .cherrybomb:   return "Черешня"
        case .jalapeno:     return "Халапеньо"
        case .squash:       return "Кабачок"
        case .potatomine:   return "Картофельная мина"
        case .doomshroom:   return "Гриб-апокалипсис"
        case .iceshroom:    return "Ледяной гриб"
        case .cherryjalapeno: return "⚡Черри+Халапеньо"
        case .lilypad:      return "Кувшинка"
        case .flowerpot:    return "Горшок"
        case .fumeshroom:   return "Дымовой гриб"
        case .chomper:      return "Хомяк"
        case .hypnoshroom:  return "Гипно-гриб"
        case .scaredy:      return "Трусишка"
        case .sunbeanshroom:return "Фасоль-солнце"
        case .imitater:     return "Имитатор"
        case .peaSnow:      return "⚡Ледяная горошина"
        case .peaNut:       return "⚡Горох-орех"
        case .sunshooter:   return "⚡Солнечный стрелок"
        case .gatlingpea:   return "⚡Гатлинг-горошина"
        case .spikernut:    return "⚡Шип-орех"
        case .iceMelon:     return "⚡Ледяной арбуз+"
        case .superMelon:   return "⚡Супер-арбуз"
        case .firepeater:   return "⚡Огненный трёхстр."
        case .tallWall:     return "⚡Мега-орех"
        case .hypnoPuff:    return "⚡Гипно-туман"
        case .doomCherry:   return "⚡АПОКАЛИПСИС"
        }
    }

    var cost: Int {
        switch self {
        case .sunflower, .sunshroom, .scaredy, .lilypad, .flowerpot: return 50
        case .potatomine, .spikeweed, .sunbeanshroom: return 25
        case .peashooter, .wallnut, .squash, .fumeshroom, .pumpkin: return 100
        case .snowpea, .chomper, .cherrybomb, .jalapeno, .magnetshroom: return 175
        case .repeater, .cattail, .kernelpult, .cactus: return 200
        case .doomshroom, .iceshroom, .hypnoshroom: return 75
        case .threepeater, .splitpea, .cabbagepult: return 300
        case .melonpult, .torchwood: return 325
        case .tallnut, .twinsunflower, .wintermelon: return 150
        case .starfruit, .spikerock: return 125
        case .marigold: return 50
        // Fusions cost extra
        case .peaSnow, .peaNut, .sunshooter: return 150
        case .gatlingpea, .spikernut: return 225
        case .superMelon, .iceMelon: return 350
        case .firepeater, .hypnoPuff: return 250
        case .tallWall: return 200
        case .doomCherry, .cherryjalapeno: return 200
        }
    }

    var hp: Int {
        switch self {
        case .wallnut:    return 4000
        case .tallnut:    return 8000
        case .tallWall:   return 12000
        case .peaNut:     return 4000
        case .spikernut:  return 4000
        case .pumpkin:    return 4000
        case .torchwood:  return 2000
        default:          return 300
        }
    }

    var recharge: Double { return 7.5 }  // seed packet cooldown seconds

    // shoot interval (seconds between attacks). nil = doesn't shoot
    var shootInterval: Double? {
        switch self {
        case .peashooter, .splitpea, .cactus: return 1.5
        case .snowpea:            return 1.5
        case .repeater:           return 0.75  // 2 peas per cycle
        case .threepeater:        return 1.5
        case .cattail:            return 1.0
        case .starfruit:          return 1.5
        case .cabbagepult:        return 3.0
        case .kernelpult:         return 3.0
        case .melonpult, .wintermelon: return 3.0
        case .gloombshroom:       return 1.5
        case .fumeshroom:         return 1.5
        case .scaredy:            return 1.5
        case .peaSnow:            return 1.5
        case .peaNut:             return 2.0
        case .sunshooter:         return 2.0
        case .gatlingpea:         return 0.35
        case .superMelon:         return 3.0
        case .iceMelon:           return 3.0
        case .firepeater:         return 1.5
        case .hypnoPuff:          return 2.0
        default:                  return nil
        }
    }

    var bulletDamage: Int {
        switch self {
        case .peashooter, .snowpea, .cactus: return 20
        case .repeater:      return 20
        case .threepeater:   return 20
        case .starfruit:     return 20
        case .splitpea:      return 20
        case .cabbagepult:   return 40
        case .kernelpult:    return 10   // butter = 400
        case .melonpult:     return 80
        case .wintermelon:   return 80
        case .gloombshroom:  return 4    // hits all in range per tick
        case .fumeshroom:    return 20
        case .scaredy:       return 20
        case .peaSnow:       return 20
        case .peaNut:        return 20
        case .sunshooter:    return 20
        case .gatlingpea:    return 20
        case .superMelon:    return 120
        case .iceMelon:      return 80
        case .firepeater:    return 40
        case .hypnoPuff:     return 0   // mind control
        case .cattail:       return 20
        default:             return 0
        }
    }

    var isFreezes: Bool {
        switch self { case .snowpea, .wintermelon, .iceMelon, .iceshroom: return true; default: return false }
    }

    var isInstant: Bool {
        switch self {
        case .cherrybomb, .jalapeno, .squash, .potatomine, .doomshroom,
             .iceshroom, .cherryjalapeno, .doomCherry, .hypnoshroom: return true
        default: return false
        }
    }

    var isDefense: Bool {
        switch self { case .wallnut, .tallnut, .pumpkin, .tallWall: return true; default: return false }
    }

    var producesSun: Bool {
        switch self { case .sunflower, .twinsunflower, .sunshroom, .sunshooter: return true; default: return false }
    }

    var sunAmount: Int {
        switch self { case .twinsunflower: return 50; case .sunshroom: return 15; default: return 25 }
    }
    var sunInterval: Double {
        switch self { case .sunflower, .twinsunflower: return 24; case .sunshroom: return 18; default: return 24 }
    }

    // ── FUSION RECIPES ─────────────────────────────────────────────────────────
    // Returns fused plant kind if self + other can fuse
    func fuse(with other: Plant) -> Plant? {
        typealias R = Plant
        let a = self; let b = other
        func match(_ x: R, _ y: R, _ result: R) -> R? {
            (a == x && b == y) || (a == y && b == x) ? result : nil
        }
        return
            match(.peashooter, .snowpea,       .peaSnow)     ??
            match(.peashooter, .wallnut,        .peaNut)      ??
            match(.peashooter, .sunflower,      .sunshooter)  ??
            match(.repeater,   .repeater,       .gatlingpea)  ??
            match(.wallnut,    .spikeweed,      .spikernut)   ??
            match(.wallnut,    .tallnut,        .tallWall)    ??
            match(.melonpult,  .melonpult,      .superMelon)  ??
            match(.wintermelon,.iceshroom,      .iceMelon)    ??
            match(.threepeater,.jalapeno,       .firepeater)  ??
            match(.fumeshroom, .hypnoshroom,    .hypnoPuff)   ??
            match(.cherrybomb, .doomshroom,     .doomCherry)  ??
            match(.cherrybomb, .jalapeno,       .cherryjalapeno) ??
            match(.peaSnow,    .peaSnow,        .gatlingpea)  ??
            nil
    }
}

// MARK: - Zombie Kind
enum Zombie: String {
    case normal       = "zombie"
    case flag         = "flagzombie"
    case cone         = "conezombie"
    case bucket       = "bucketzombie"
    case door         = "doorzombie"
    case pole         = "polevaultzombie"
    case newspaper    = "newspaperzombie"
    case football     = "footballzombie"
    case dancer       = "dancerzombie"
    case ducky        = "duckyzombie"
    case digger       = "diggerzombie"
    case zomboni      = "zomboni"
    case gargantuar   = "gargantuarzombie"
    case boss         = "bosszombie"

    var displayName: String {
        switch self {
        case .normal:    return "Зомби"
        case .flag:      return "Зомби с флагом"
        case .cone:      return "Зомби с конусом"
        case .bucket:    return "Зомби с ведром"
        case .door:      return "Зомби с дверью"
        case .pole:      return "Зомби-прыгун"
        case .newspaper: return "Зомби с газетой"
        case .football:  return "Футбольный зомби"
        case .dancer:    return "Танцор"
        case .ducky:     return "Зомби с уткой"
        case .digger:    return "Землекоп"
        case .zomboni:   return "Зомбони"
        case .gargantuar:return "Гаргантюа"
        case .boss:      return "Босс"
        }
    }

    var maxHP: Int {
        switch self {
        case .normal:     return 270
        case .flag:       return 270
        case .cone:       return 560
        case .bucket:     return 1300
        case .door:       return 1350
        case .pole:       return 270
        case .newspaper:  return 270  // enrages at 0 shield hp
        case .football:   return 1600
        case .dancer:     return 500
        case .ducky:      return 400
        case .digger:     return 600
        case .zomboni:    return 1800
        case .gargantuar: return 3000
        case .boss:       return 8000
        }
    }

    var speed: CGFloat {  // pixels per second
        switch self {
        case .football:   return 52
        case .pole:       return 44  // faster before vault
        case .zomboni:    return 60
        case .digger:     return 30
        case .gargantuar: return 16
        default:          return 22
        }
    }

    var eatDamage: Int { return 100 }   // hp dealt to plant per eat tick
    var eatInterval: Double { return 0.5 }  // eat tick every N seconds
    var score: Int {
        switch self {
        case .gargantuar: return 250
        case .boss:       return 500
        default: return max(10, maxHP / 27)
        }
    }
}

// MARK: - Bullet Node
class BulletNode: SKNode {
    var damage:   Int     = 20
    var frozen:   Bool    = false
    var fire:     Bool    = false
    var isSplash: Bool    = false
    var splashR:  CGFloat = 0
    var row:      Int     = 0
    var targetRow: Int    = -1  // -1 = same as row
    var sprite:   SKSpriteNode

    init(texName: String, row: Int, damage: Int, frozen: Bool = false, fire: Bool = false, splash: Bool = false, splashR: CGFloat = 0) {
        self.row    = row
        self.damage = damage
        self.frozen = frozen
        self.fire   = fire
        self.isSplash = splash
        self.splashR  = splashR
        self.sprite = SKSpriteNode(imageNamed: texName)
        if self.sprite.texture == nil || self.sprite.texture!.size() == .zero {
            self.sprite.color = frozen ? .cyan : fire ? .orange : .green
            self.sprite.colorBlendFactor = 1
            self.sprite.size  = CGSize(width: 18, height: 18)
        } else {
            self.sprite.size = CGSize(width: 20, height: 20)
        }
        super.init()
        name = "bullet"
        addChild(sprite)
        zPosition = 30
    }
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Plant Node
class PlantNode: SKNode {
    var plant: Plant
    var row: Int, col: Int
    var hp: Int, maxHP: Int
    var shootTimer: Double = 0
    var sunTimer:   Double = 0
    var readyTimer: Double = 0     // potato mine / mushroom night-only
    var isArmed:    Bool   = false
    var chomping:   Bool   = false
    var chompTimer: Double = 0
    var isHypno:    Bool   = false  // mind-controlled zombie avoids this
    var sprite: SKSpriteNode
    var hpBarBg: SKShapeNode?
    var hpBar:   SKShapeNode?

    init(plant: Plant, row: Int, col: Int) {
        self.plant  = plant
        self.row    = row
        self.col    = col
        self.hp     = plant.hp
        self.maxHP  = plant.hp
        let spr = SKSpriteNode(imageNamed: plant.rawValue)
        if spr.texture == nil || spr.texture!.size() == .zero {
            spr.color = (plant.producesSun ? .yellow : plant.isDefense ? .brown : .green)
            spr.colorBlendFactor = 1
            spr.size = CGSize(width: Grid.cellW - 8, height: Grid.cellH - 8)
        } else {
            spr.size = CGSize(width: Grid.cellW - 6, height: Grid.cellH - 6)
        }
        self.sprite = spr
        // sun production init
        if plant.producesSun { self.sunTimer = plant.sunInterval * 0.5 }
        if plant == .potatomine { self.readyTimer = 14.0; spr.alpha = 0.5 }
        super.init()
        addChild(spr)
        zPosition = 10

        // HP bar (for defense plants)
        if plant.isDefense || plant.hp > 500 {
            let bg = SKShapeNode(rectOf: CGSize(width: Grid.cellW - 10, height: 5), cornerRadius: 2)
            bg.fillColor = .darkGray; bg.strokeColor = .clear
            bg.position = CGPoint(x: 0, y: Grid.cellH/2 - 6)
            addChild(bg); hpBarBg = bg
            let bar = SKShapeNode(rectOf: CGSize(width: Grid.cellW - 10, height: 5), cornerRadius: 2)
            bar.fillColor = .green; bar.strokeColor = .clear
            bar.position = bg.position
            addChild(bar); hpBar = bar
        }
    }
    required init?(coder: NSCoder) { fatalError() }

    func updateHP() {
        guard let bar = hpBar else { return }
        let pct = CGFloat(hp) / CGFloat(maxHP)
        bar.xScale = max(0, pct)
        bar.fillColor = pct > 0.6 ? .green : pct > 0.3 ? .yellow : .red
    }
}

// MARK: - Zombie Node
class ZombieNode: SKNode {
    var zombie: Zombie
    var row: Int
    var hp: Int, maxHP: Int
    var isDead:    Bool   = false
    var frozen:    Bool   = false
    var frozenT:   Double = 0
    var burning:   Bool   = false
    var burnT:     Double = 0
    var isEating:  Bool   = false
    var eatTimer:  Double = 0
    var eatTarget: PlantNode? = nil
    var speed: CGFloat
    var isHypno:   Bool = false     // converted to player side
    var sprite: SKSpriteNode
    var hpBar:  SKShapeNode?
    var shieldHP: Int = 0          // cone/bucket/door extra HP

    init(zombie: Zombie, row: Int) {
        self.zombie = zombie
        self.row    = row
        self.hp     = zombie.maxHP
        self.maxHP  = zombie.maxHP
        self.speed  = zombie.speed
        switch zombie {
        case .cone:   shieldHP = 370
        case .bucket: shieldHP = 1100
        case .door:   shieldHP = 1100
        default: shieldHP = 0
        }

        let spr = SKSpriteNode(imageNamed: zombie.rawValue)
        if spr.texture == nil || spr.texture!.size() == .zero {
            spr.color = .purple; spr.colorBlendFactor = 1
            spr.size  = CGSize(width: 48, height: 68)
        } else {
            spr.size = CGSize(width: 54, height: 72)
        }
        self.sprite = spr
        super.init()
        addChild(spr)
        zPosition = 20

        let bar = SKShapeNode(rectOf: CGSize(width: 50, height: 5), cornerRadius: 2)
        bar.fillColor = .red; bar.strokeColor = .clear
        bar.position  = CGPoint(x: 0, y: 44)
        addChild(bar); hpBar = bar
    }
    required init?(coder: NSCoder) { fatalError() }

    func updateHPBar() {
        let pct = CGFloat(hp) / CGFloat(maxHP)
        hpBar?.xScale = max(0, pct)
        hpBar?.fillColor = pct > 0.6 ? .green : pct > 0.3 ? .yellow : .red
    }

    func takeDamage(_ dmg: Int, frozen: Bool = false, fire: Bool = false) {
        var d = dmg
        if shieldHP > 0 {
            let absorbed = min(shieldHP, d)
            shieldHP -= absorbed
            d -= absorbed
        }
        hp -= d
        if frozen { self.frozen = true; frozenT = 3.0 }
        if fire   { self.burning = true; burnT = 3.0 }
        if hp <= 0 { isDead = true }
        // Hit flash
        sprite.run(.sequence([
            .colorize(with: .white, colorBlendFactor: 0.8, duration: 0.05),
            .colorize(withColorBlendFactor: 0, duration: 0.15)
        ]))
        updateHPBar()
    }
}

// MARK: - Sun Node
class SunNode: SKSpriteNode {
    var value: Int = 25
    convenience init(value: Int, at pos: CGPoint) {
        self.init(imageNamed: "sun")
        if texture == nil || texture!.size() == .zero {
            color = .yellow; colorBlendFactor = 1
            size  = CGSize(width: 44, height: 44)
        } else {
            self.size = CGSize(width: 50, height: 50)
        }
        self.value = value
        position   = pos
        zPosition  = 50
        name       = "sun"
        run(.sequence([.wait(forDuration: 9.5), .fadeOut(withDuration: 0.5), .removeFromParent()]))
    }
}

// MARK: - Explosion
func makeExplosion(at pos: CGPoint, radius: CGFloat, color: UIColor = .orange) -> SKNode {
    let ring = SKShapeNode(circleOfRadius: 4)
    ring.fillColor = color.withAlphaComponent(0.85)
    ring.strokeColor = .clear
    ring.position  = pos
    ring.zPosition = 60
    ring.run(.sequence([
        .group([
            .scale(to: radius / 4, duration: 0.25),
            .fadeOut(withDuration: 0.25)
        ]),
        .removeFromParent()
    ]))
    return ring
}

// MARK: - GameScene
class GameScene: SKScene {

    // ── State ──────────────────────────────────────────────────────────────────
    var selectedSeedsDeck: [Plant] = []
    var sun: Int = 50 { didSet { sunLabel?.text = "☀️ \(sun)" } }
    var score: Int = 0
    var currentLevel: Int  = 1
    var totalWaves:   Int  = 5
    var currentWave:  Int  = 0
    var waveCooldown: Double = 8   // seconds until first wave
    var waveBetween:  Double = 35  // seconds between waves
    var gameOver:     Bool   = false
    var paused_:      Bool   = false

    var plants:  [[PlantNode?]] = Array(repeating: Array(repeating: nil, count: Grid.cols), count: Grid.rows)
    var zombies: [ZombieNode]   = []
    var mowers:  [SKSpriteNode?]  = Array(repeating: nil, count: Grid.rows)
    var mowerAlive: [Bool]         = Array(repeating: true, count: Grid.rows)

    var selected: Plant? = nil
    var selIndicator: SKNode?
    var skyDropTimer: Double = 8.0

    // ── HUD ────────────────────────────────────────────────────────────────────
    var sunLabel:  SKLabelNode?
    var waveLabel: SKLabelNode?
    var seedBar:   SKNode?

    // ── Lifecycle ──────────────────────────────────────────────────────────────
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        buildBackground()
        buildGrid()
        buildMowers()
        buildHUD()
        buildSeedBar()
        addTapRecognizer()
    }

    // ── BACKGROUND ─────────────────────────────────────────────────────────────
    func buildBackground() {
        let bg = SKSpriteNode(imageNamed: "lawn")
        if bg.texture == nil || bg.texture!.size() == .zero {
            backgroundColor = SKColor(red: 0.15, green: 0.55, blue: 0.15, alpha: 1)
        } else {
            bg.size     = size
            bg.position = CGPoint(x: size.width/2, y: size.height/2)
            bg.zPosition = -20
            addChild(bg)
        }
        // Sky gradient overlay at top
        let sky = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: 80))
        sky.position  = CGPoint(x: size.width/2, y: size.height - 40)
        sky.zPosition = -15
        addChild(sky)
    }

    func buildGrid() {
        for r in 0..<Grid.rows {
            let alpha: CGFloat = r % 2 == 0 ? 0.06 : 0.0
            for c in 0..<Grid.cols {
                let cell = SKShapeNode(rectOf: CGSize(width: Grid.cellW - 2, height: Grid.cellH - 2))
                cell.fillColor   = SKColor(white: r % 2 == 0 ? 1 : 0, alpha: alpha)
                cell.strokeColor = SKColor(white: 1, alpha: 0.08)
                cell.position    = Grid.pos(row: r, col: c)
                cell.zPosition   = -10
                addChild(cell)
            }
        }
    }

    func buildMowers() {
        for r in 0..<Grid.rows {
            let m = SKSpriteNode(imageNamed: "mower")
            if m.texture == nil || m.texture!.size() == .zero {
                m.color = .yellow; m.colorBlendFactor = 1; m.size = CGSize(width: 44, height: 44)
            } else {
                m.size = CGSize(width: 52, height: 52)
            }
            let p = Grid.pos(row: r, col: 0)
            m.position  = CGPoint(x: p.x - Grid.cellW, y: p.y)
            m.zPosition = 15
            addChild(m)
            mowers[r] = m
        }
    }

    func buildHUD() {
        // Sun panel
        let sunPanel = SKShapeNode(rectOf: CGSize(width: 140, height: 44), cornerRadius: 10)
        sunPanel.fillColor   = SKColor(white: 0, alpha: 0.55)
        sunPanel.strokeColor = SKColor(white: 1, alpha: 0.2)
        sunPanel.position    = CGPoint(x: 80, y: size.height - 30)
        sunPanel.zPosition   = 100
        addChild(sunPanel)

        let sl = SKLabelNode(fontNamed: "AvenirNext-Bold")
        sl.fontSize  = 20; sl.fontColor = .white
        sl.text      = "☀️ \(sun)"
        sl.position  = CGPoint(x: 0, y: -7)
        sunPanel.addChild(sl)
        sunLabel = sl

        // Wave label
        let wl = SKLabelNode(fontNamed: "AvenirNext-Bold")
        wl.fontSize  = 16; wl.fontColor = .white
        wl.text      = "Волна \(currentWave)/\(totalWaves)"
        wl.position  = CGPoint(x: size.width/2, y: size.height - 34)
        wl.zPosition = 100
        addChild(wl)
        waveLabel = wl
    }

    func buildSeedBar() {
        let deckToUse = selectedSeedsDeck.isEmpty ? [
            .sunflower, .peashooter, .wallnut, .cherrybomb, .snowpea,
            .repeater, .chomper, .potatomine, .squash, .threepeater,
            .tallnut, .jalapeno, .fumeshroom, .magnetshroom
        ] : selectedSeedsDeck

        let cardW: CGFloat = 64, cardH: CGFloat = Grid.seedBarH - 8
        let totalW = CGFloat(deckToUse.count) * (cardW + 4) + 8
        let bar = SKShapeNode(rectOf: CGSize(width: totalW, height: Grid.seedBarH), cornerRadius: 10)
        bar.fillColor   = SKColor(red: 0.08, green: 0.28, blue: 0.08, alpha: 0.88)
        bar.strokeColor = SKColor(white: 1, alpha: 0.12)
        bar.position    = CGPoint(x: size.width/2, y: Grid.seedBarH/2)
        bar.zPosition   = 100
        bar.name        = "seedBar"
        addChild(bar)
        seedBar = bar

        for (i, p) in deckToUse.enumerated() {
            let x = -totalW/2 + cardW/2 + 4 + CGFloat(i) * (cardW + 4)
            let card = SKShapeNode(rectOf: CGSize(width: cardW, height: cardH), cornerRadius: 6)
            card.fillColor   = SKColor(white: 0.05, alpha: 0.8)
            card.strokeColor = SKColor(white: 0.5, alpha: 0.3)
            card.position    = CGPoint(x: x, y: 0)
            card.name        = "card_\(p.rawValue)"
            bar.addChild(card)

            let icon = SKSpriteNode(imageNamed: p.rawValue)
            if icon.texture == nil || icon.texture!.size() == .zero {
                icon.color = p.producesSun ? .yellow : p.isDefense ? .brown : .green
                icon.colorBlendFactor = 1
            }
            icon.size = CGSize(width: 44, height: 44)
            icon.position = CGPoint(x: 0, y: 6)
            icon.name = "icon_\(p.rawValue)"
            card.addChild(icon)

            let lbl = SKLabelNode(fontNamed: "AvenirNext-Bold")
            lbl.fontSize = 11; lbl.fontColor = .yellow
            lbl.text     = "☀\(p.cost)"
            lbl.position = CGPoint(x: 0, y: -cardH/2 + 8)
            card.addChild(lbl)
        }
    }

    func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        view?.addGestureRecognizer(tap)
    }

    // ── COORDINATE HELPERS ─────────────────────────────────────────────────────
    func gridPos(row: Int, col: Int) -> CGPoint { Grid.pos(row: row, col: col) }

    // ── HUD UPDATE ─────────────────────────────────────────────────────────────
    func refreshSeedBar() {
        guard let bar = seedBar else { return }
        bar.children.forEach { node in
            guard let card = node as? SKShapeNode,
                  let name = card.name, name.hasPrefix("card_"),
                  let rawVal = name.components(separatedBy: "_").dropFirst().first,
                  let p = Plant(rawValue: rawVal) else { return }
            let canAfford = sun >= p.cost
            card.alpha = canAfford ? 1.0 : 0.5
            if p == selected {
                card.strokeColor = .yellow
                card.lineWidth   = 2
            } else {
                card.strokeColor = SKColor(white: 0.5, alpha: 0.3)
                card.lineWidth   = 1
            }
        }
    }

    // ── TAP HANDLER ───────────────────────────────────────────────────────────
    @objc func onTap(_ gr: UITapGestureRecognizer) {
        guard !gameOver, !paused_ else { return }
        let vp   = gr.location(in: view)
        let sp   = convertPoint(fromView: vp)

        // 1. Tap on sun?
        let tapped = nodes(at: sp)
        for n in tapped {
            if n.name == "sun", let sn = n as? SunNode {
                sun += sn.value
                sn.run(.sequence([.scale(to: 1.5, duration: 0.08), .removeFromParent()]))
                return
            }
        }

        // 2. Tap on seed bar?
        if let bar = seedBar {
            let bp = bar.convert(sp, from: self)
            for child in bar.children {
                guard let card = child as? SKShapeNode,
                      let name = card.name, name.hasPrefix("card_"),
                      card.contains(bp) else { continue }
                let raw = String(name.dropFirst(5))
                if let p = Plant(rawValue: raw) {
                    selected = (selected == p) ? nil : p
                    refreshSeedBar()
                    return
                }
            }
        }

        // 3. Tap on grid?
        guard let p = selected, let (row, col) = Grid.cell(at: sp) else { return }
        tryPlace(p, row: row, col: col)
    }

    // ── PLACEMENT ─────────────────────────────────────────────────────────────
    func tryPlace(_ p: Plant, row: Int, col: Int) {
        guard sun >= p.cost else { flashNoSun(); return }
        let existing = plants[row][col]

        if let ex = existing {
            // Fusion attempt
            if let fused = ex.plant.fuse(with: p) {
                sun -= p.cost
                ex.removeFromParent(); plants[row][col] = nil
                let fn = place(fused, row: row, col: col)
                fuseEffect(at: fn.position)
                selected = nil; refreshSeedBar()
                return
            }
            // Can't stack
            return
        }
        sun -= p.cost
        place(p, row: row, col: col)
        selected = nil; refreshSeedBar()
    }

    @discardableResult
    func place(_ p: Plant, row: Int, col: Int) -> PlantNode {
        let node = PlantNode(plant: p, row: row, col: col)
        node.position = gridPos(row: row, col: col)
        addChild(node)
        plants[row][col] = node
        triggerInstant(p, node: node, row: row, col: col)
        return node
    }

    // ── INSTANT PLANTS ────────────────────────────────────────────────────────
    func triggerInstant(_ p: Plant, node: PlantNode, row: Int, col: Int) {
        let pos = node.position
        switch p {
        case .cherrybomb:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let s = self else { return }
                s.addChild(makeExplosion(at: pos, radius: Grid.cellW * 3.5))
                s.damageZombies(center: pos, radius: Grid.cellW * 1.6, dmg: 1800)
                node.removeFromParent(); s.plants[row][col] = nil
            }

        case .doomshroom:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let s = self else { return }
                s.addChild(makeExplosion(at: pos, radius: s.size.width * 0.4, color: .purple))
                s.damageZombies(center: pos, radius: s.size.width * 0.4, dmg: 1800)
                node.removeFromParent(); s.plants[row][col] = nil
            }

        case .cherryjalapeno, .doomCherry:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let s = self else { return }
                s.addChild(makeExplosion(at: pos, radius: s.size.width * 0.5, color: .red))
                s.zombies.filter { !$0.isDead }.forEach { $0.takeDamage(1800, fire: true) }
                node.removeFromParent(); s.plants[row][col] = nil
            }

        case .jalapeno:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                guard let s = self else { return }
                let fire = SKShapeNode(rectOf: CGSize(width: s.size.width + 100, height: Grid.cellH - 4))
                fire.fillColor = UIColor.orange.withAlphaComponent(0.85)
                fire.strokeColor = .red; fire.lineWidth = 2
                fire.position  = CGPoint(x: s.size.width / 2, y: pos.y)
                fire.zPosition = 55
                s.addChild(fire)
                fire.run(.sequence([.fadeOut(withDuration: 0.7), .removeFromParent()]))
                s.zombies.filter { !$0.isDead && $0.row == row }.forEach { $0.takeDamage(1800, fire: true) }
                node.removeFromParent(); s.plants[row][col] = nil
            }

        case .iceshroom:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                guard let s = self else { return }
                let freeze = SKShapeNode(circleOfRadius: s.size.width)
                freeze.fillColor = UIColor.cyan.withAlphaComponent(0.3)
                freeze.strokeColor = .cyan; freeze.position = pos; freeze.zPosition = 55
                s.addChild(freeze)
                freeze.run(.sequence([.fadeOut(withDuration: 1), .removeFromParent()]))
                s.zombies.filter { !$0.isDead }.forEach { $0.takeDamage(0, frozen: true) }
                s.zombies.filter { !$0.isDead }.forEach { $0.frozenT = 5.0; $0.frozen = true }
                node.removeFromParent(); s.plants[row][col] = nil
            }

        case .squash:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let s = self else { return }
                let nearest = s.zombies.filter { !$0.isDead && ($0.row == row || abs($0.row - row) <= 1) }
                    .min { abs($0.position.x - pos.x) < abs($1.position.x - pos.x) }
                guard let z = nearest else {
                    node.removeFromParent(); s.plants[row][col] = nil; return
                }
                let jump = SKAction.sequence([
                    .move(to: CGPoint(x: pos.x, y: pos.y + 70), duration: 0.15),
                    .move(to: z.position, duration: 0.18)
                ])
                node.sprite.run(.sequence([jump, .run {
                    s.addChild(makeExplosion(at: z.position, radius: 60))
                    z.takeDamage(1800)
                    node.removeFromParent(); s.plants[row][col] = nil
                }]))
            }

        case .potatomine:
            node.readyTimer = 14.0
            node.isArmed    = false
            node.sprite.alpha = 0.5

        default: break
        }
    }

    // ── WAVE SYSTEM ───────────────────────────────────────────────────────────
    func launchWave(_ waveIdx: Int) {
        currentWave = waveIdx
        waveLabel?.text = "Волна \(currentWave)/\(totalWaves)"
        let defs = buildWave(waveIdx)
        var delay = 0.0
        for def in defs {
            let row = def.row
            let kind = def.kind
            run(.wait(forDuration: delay)) { [weak self] in
                guard let s = self, !s.gameOver else { return }
                s.spawnZombie(kind, row: row)
            }
            delay += Double.random(in: 0.3...1.0)
        }
    }

    struct ZombieDef { var kind: Zombie; var row: Int }

    func buildWave(_ wave: Int) -> [ZombieDef] {
        var defs: [ZombieDef] = []
        let baseCount = 4 + wave * 3
        // Pool of zombie types scaling with wave
        var pool: [Zombie] = [.normal]
        if wave >= 2  { pool += [.flag, .cone] }
        if wave >= 3  { pool += [.cone, .bucket] }
        if wave >= 4  { pool += [.bucket, .pole] }
        if wave >= 5  { pool += [.newspaper, .football] }
        if wave >= 7  { pool += [.dancer, .digger] }
        if wave >= 9  { pool += [.zomboni] }
        if wave >= 10 { pool += [.gargantuar] }

        // Flag zombie always starts each wave
        defs.append(ZombieDef(kind: .flag, row: Int.random(in: 0..<Grid.rows)))

        for _ in 0..<baseCount {
            let row  = Int.random(in: 0..<Grid.rows)
            let kind = pool.randomElement()!
            defs.append(ZombieDef(kind: kind, row: row))
        }
        // Big wave: extra zombies
        if wave == totalWaves {
            for _ in 0..<5 {
                defs.append(ZombieDef(kind: .gargantuar, row: Int.random(in: 0..<Grid.rows)))
            }
        }
        return defs
    }

    func spawnZombie(_ kind: Zombie, row: Int) {
        let z = ZombieNode(zombie: kind, row: row)
        let yPos = gridPos(row: row, col: 0).y
        z.position  = CGPoint(x: size.width + 70, y: yPos)
        addChild(z)
        zombies.append(z)
    }

    // ── SKY SUN ───────────────────────────────────────────────────────────────
    func dropSkySun() {
        let x = CGFloat.random(in: Grid.originX + 40 ... size.width - 60)
        let startY = size.height + 30
        let endY   = CGFloat.random(in: Grid.originY + Grid.seedBarH + 20 ... size.height - 100)
        let sn = SunNode(value: 25, at: CGPoint(x: x, y: startY))
        addChild(sn)
        sn.run(.move(to: CGPoint(x: x, y: endY), duration: 1.4))
    }

    func dropSunAt(_ pos: CGPoint, value: Int) {
        let sn = SunNode(value: value, at: pos)
        addChild(sn)
        sn.run(.sequence([
            .moveBy(x: 0, y: 40, duration: 0.5),
            .wait(forDuration: 5),
            .fadeOut(withDuration: 0.5),
            .removeFromParent()
        ]))
    }

    // ── MAIN UPDATE ───────────────────────────────────────────────────────────
    override func update(_ currentTime: TimeInterval) {
        guard !gameOver, !paused_ else { return }
        let dt = 1.0 / 60.0

        // Wave timer
        waveCooldown -= dt
        if waveCooldown <= 0 && currentWave < totalWaves {
            let next = currentWave + 1
            launchWave(next)
            waveCooldown = waveBetween
        }

        // Sky sun
        skyDropTimer -= dt
        if skyDropTimer <= 0 {
            skyDropTimer = Double.random(in: 7...11)
            dropSkySun()
        }

        updateAllPlants(dt: dt)
        updateAllZombies(dt: dt)
        updateAllBullets(dt: dt)
        checkWin()
    }

    // ── PLANT UPDATE ──────────────────────────────────────────────────────────
    func updateAllPlants(dt: Double) {
        for r in 0..<Grid.rows {
            for c in 0..<Grid.cols {
                guard let pn = plants[r][c] else { continue }
                let p = pn.plant

                // Sun production
                if p.producesSun {
                    pn.sunTimer -= dt
                    if pn.sunTimer <= 0 {
                        pn.sunTimer = p.sunInterval
                        dropSunAt(pn.position, value: p.sunAmount)
                    }
                }

                // Potato mine arming
                if p == .potatomine && !pn.isArmed {
                    pn.readyTimer -= dt
                    if pn.readyTimer <= 0 {
                        pn.isArmed = true; pn.sprite.alpha = 1.0
                    } else { continue }
                }

                // Potato mine trigger: zombie touches
                if p == .potatomine && pn.isArmed {
                    if let z = zombies.first(where: { !$0.isDead && $0.row == r && abs($0.position.x - pn.position.x) < Grid.cellW * 0.6 }) {
                        addChild(makeExplosion(at: pn.position, radius: 80))
                        z.takeDamage(1800)
                        pn.removeFromParent(); plants[r][c] = nil
                    }
                    continue
                }

                // Shooting plants
                guard let interval = p.shootInterval else { continue }
                pn.shootTimer -= dt
                if pn.shootTimer > 0 { continue }

                // Does plant have target?
                let shootRows: [Int]
                switch p {
                case .threepeater, .firepeater: shootRows = [r-1, r, r+1].filter { $0 >= 0 && $0 < Grid.rows }
                case .starfruit:               shootRows = Array(0..<Grid.rows)
                case .gloombshroom:            shootRows = [r-1, r, r+1].filter { $0 >= 0 && $0 < Grid.rows }
                default:                       shootRows = [r]
                }

                let hasTarget = shootRows.contains { tRow in
                    zombies.contains { !$0.isDead && $0.row == tRow && $0.position.x > pn.position.x - 20 }
                }
                let alwaysShoot = [Plant.fumeshroom, .gloombshroom, .starfruit].contains(p)
                if !hasTarget && !alwaysShoot { continue }

                pn.shootTimer = interval
                fire(from: pn, rows: shootRows)
            }
        }
    }

    func fire(from pn: PlantNode, rows: [Int]) {
        let p   = pn.plant
        let dmg = p.bulletDamage
        let frz = p.isFreezes
        let fir = [Plant.firepeater].contains(p)

        for tRow in rows {
            guard tRow >= 0 && tRow < Grid.rows else { continue }

            // Special: Gloom-shroom does instant AOE without bullet
            if p == .gloombshroom {
                let range = Grid.cellW * 1.8
                zombies.filter { !$0.isDead && $0.row == tRow && abs($0.position.x - pn.position.x) < range }
                    .forEach { $0.takeDamage(dmg, frozen: frz, fire: fir) }
                continue
            }

            // Fume-shroom: instant AOE forward
            if p == .fumeshroom {
                let frontX = pn.position.x + Grid.cellW * 0.5
                zombies.filter { !$0.isDead && $0.row == tRow && $0.position.x > pn.position.x && $0.position.x < frontX + Grid.cellW * 2.5 }
                    .forEach { $0.takeDamage(dmg) }
                continue
            }

            let texName = frz ? "projectilesnowpea" : fir ? "bullet_fire" : "bullet_pea"
            let b = BulletNode(texName: texName, row: tRow, damage: dmg, frozen: frz, fire: fir,
                               splash: [Plant.melonpult, .wintermelon, .superMelon, .iceMelon].contains(p),
                               splashR: 80)
            b.position = CGPoint(x: pn.position.x + 22, y: pn.position.y)
            addChild(b)

            // Repeater fires double
            if p == .repeater || p == .gatlingpea {
                let b2 = BulletNode(texName: texName, row: tRow, damage: dmg, frozen: frz, fire: fir)
                b2.position = CGPoint(x: pn.position.x + 10, y: pn.position.y)
                addChild(b2)
                if p == .gatlingpea {
                    let b3 = BulletNode(texName: texName, row: tRow, damage: dmg)
                    b3.position = CGPoint(x: pn.position.x + 5, y: pn.position.y)
                    addChild(b3)
                }
            }

            // Split-pea fires backward too
            if p == .splitpea {
                let bb = BulletNode(texName: "bullet_pea", row: tRow, damage: dmg)
                bb.position = CGPoint(x: pn.position.x - 22, y: pn.position.y)
                bb.xScale   = -1  // flip
                addChild(bb)
                bb.run(.repeatForever(.moveBy(x: -8, y: 0, duration: 1.0/60.0)))
            }

            // Cattail targets any zombie anywhere
            if p == .cattail {
                if let target = zombies.filter({ !$0.isDead }).randomElement() {
                    b.run(.sequence([
                        .move(to: target.position, duration: 0.8),
                        .run { [weak self] in
                            target.takeDamage(dmg, frozen: frz)
                            self?.addChild(makeExplosion(at: target.position, radius: 30, color: .cyan))
                            b.removeFromParent()
                        }
                    ]))
                    continue
                }
            }

            // Star fruit: fire in 5 directions
            if p == .starfruit {
                let angles: [CGFloat] = [0, 45, 90, 135, 225]
                for angle in angles {
                    let rad = angle * .pi / 180
                    let dx = cos(rad) * 300
                    let dy = sin(rad) * 300
                    let bs = BulletNode(texName: "bullet_pea", row: tRow, damage: dmg)
                    bs.position = pn.position
                    addChild(bs)
                    bs.run(.sequence([
                        .moveBy(x: dx, y: dy, duration: 1.5),
                        .removeFromParent()
                    ]))
                }
                b.removeFromParent()
                continue
            }
        }
    }

    // ── ZOMBIE UPDATE ─────────────────────────────────────────────────────────
    func updateAllZombies(dt: Double) {
        for z in zombies {
            if z.isDead {
                z.run(.sequence([.fadeOut(withDuration: 0.25), .removeFromParent()]))
                score += z.zombie.score
                continue
            }

            // Frozen countdown
            if z.frozen {
                z.frozenT -= dt
                if z.frozenT <= 0 { z.frozen = false }
            }
            // Burning (fire damage over time)
            if z.burning {
                z.burnT -= dt
                if z.burnT <= 0 { z.burning = false }
                // Deal 5 fire dmg per tick
                z.hp -= 1
                if z.hp <= 0 { z.isDead = true; continue }
                z.updateHPBar()
            }

            let spd: CGFloat = z.frozen ? z.speed * 0.5 : z.speed

            // Find plant to eat (right edge of zombie ~26px from center)
            let eatX = z.position.x - 26
            let eatP = plants[z.row].compactMap { $0 }
                .filter { abs($0.position.x - eatX) < Grid.cellW * 0.8 }
                .max { $0.position.x < $1.position.x }

            if let ep = eatP, !z.isHypno {
                z.isEating = true
                z.eatTimer += dt
                if z.eatTimer >= z.zombie.eatInterval {
                    z.eatTimer = 0
                    ep.hp -= z.zombie.eatDamage
                    ep.updateHP()
                    if ep.hp <= 0 {
                        ep.removeFromParent()
                        plants[ep.row][ep.col] = nil
                    }
                }
            } else {
                z.isEating = false
                z.eatTimer = 0
                z.position.x -= spd * CGFloat(dt)
            }

            z.updateHPBar()

            // Digger goes underground to emerge at front
            if z.zombie == .digger && z.position.x < Grid.originX {
                z.position.x = size.width + 50
                z.row = Int.random(in: 0..<Grid.rows)
                let yPos = gridPos(row: z.row, col: 0).y
                z.position.y = yPos
            }

            // Pole vaulter: jump over first plant
            if z.zombie == .pole, let ep = eatP {
                z.position.x = ep.position.x - Grid.cellW * 2.5
                z.speed = 22  // slow down after vault
            }

            // Mower trigger
            let mowerX = gridPos(row: z.row, col: 0).x - Grid.cellW
            if z.position.x <= mowerX + 15 && mowerAlive[z.row] {
                activateMower(row: z.row)
            }

            // Game over
            if z.position.x <= 0 {
                onGameOver()
                return
            }
        }
        zombies.removeAll { $0.isDead && $0.parent == nil }
    }

    func activateMower(row: Int) {
        guard mowerAlive[row], let m = mowers[row] else { return }
        mowerAlive[row] = false
        mowers[row]     = nil
        let sweep = SKAction.moveBy(x: size.width + 150, y: 0, duration: (size.width + 150) / 650)
        m.run(.sequence([sweep, .removeFromParent()]))
        zombies.filter { !$0.isDead && $0.row == row }.forEach { $0.takeDamage(9999) }
    }

    // ── BULLET UPDATE ─────────────────────────────────────────────────────────
    func updateAllBullets(dt: Double) {
        children.compactMap { $0 as? BulletNode }.forEach { b in
            b.position.x += 280 * CGFloat(dt)

            if b.position.x > size.width + 60 {
                b.removeFromParent()
                return
            }

            for z in zombies {
                guard !z.isDead, z.row == b.row else { continue }
                guard abs(z.position.x - b.position.x) < 28 else { continue }

                if b.isSplash {
                    damageZombies(center: b.position, radius: b.splashR, dmg: b.damage, frozen: b.frozen)
                    addChild(makeExplosion(at: b.position, radius: b.splashR * 0.8, color: b.frozen ? .cyan : .orange))
                } else {
                    z.takeDamage(b.damage, frozen: b.frozen, fire: b.fire)
                }
                b.removeFromParent()
                return
            }
        }
    }

    // ── DAMAGE HELPERS ─────────────────────────────────────────────────────────
    func damageZombies(center: CGPoint, radius: CGFloat, dmg: Int, frozen: Bool = false) {
        zombies.filter { !$0.isDead && distance(from: center, to: $0.position) < radius }
            .forEach { $0.takeDamage(dmg, frozen: frozen) }
    }

    func distance(from a: CGPoint, to b: CGPoint) -> CGFloat {
        return sqrt((a.x - b.x)*(a.x - b.x) + (a.y - b.y)*(a.y - b.y))
    }

    // ── EFFECTS ───────────────────────────────────────────────────────────────
    func fuseEffect(at pos: CGPoint) {
        let flash = SKShapeNode(circleOfRadius: 60)
        flash.fillColor = UIColor.yellow.withAlphaComponent(0.8)
        flash.strokeColor = .clear
        flash.position  = pos
        flash.zPosition = 65
        addChild(flash)

        let lbl = SKLabelNode(fontNamed: "AvenirNext-Black")
        lbl.text      = "⚡ FUSION!"
        lbl.fontSize  = 26
        lbl.fontColor = .yellow
        lbl.position  = CGPoint(x: pos.x, y: pos.y + 50)
        lbl.zPosition = 66
        addChild(lbl)

        flash.run(.sequence([.group([.scale(to: 2, duration: 0.25), .fadeOut(withDuration: 0.25)]), .removeFromParent()]))
        lbl.run(.sequence([.moveBy(x: 0, y: 40, duration: 0.5), .fadeOut(withDuration: 0.3), .removeFromParent()]))
    }

    func flashNoSun() {
        let lbl = SKLabelNode(fontNamed: "AvenirNext-Bold")
        lbl.text      = "Недостаточно солнца ☀️"
        lbl.fontSize  = 18
        lbl.fontColor = .yellow
        lbl.position  = CGPoint(x: size.width/2, y: size.height/2 + 80)
        lbl.zPosition = 150
        addChild(lbl)
        lbl.run(.sequence([.moveBy(x: 0, y: 35, duration: 0.7), .fadeOut(withDuration: 0.3), .removeFromParent()]))
    }

    // ── WIN / LOSE ─────────────────────────────────────────────────────────────
    func checkWin() {
        guard currentWave >= totalWaves else { return }
        guard zombies.filter({ !$0.isDead }).isEmpty else { return }
        guard waveCooldown <= 0 else { return }
        run(.wait(forDuration: 2.5)) { [weak self] in self?.showResult(win: true) }
    }

    func onGameOver() {
        guard !gameOver else { return }
        gameOver = true
        showResult(win: false)
    }

    func showResult(win: Bool) {
        gameOver = true
        isPaused = true
        let overlay = SKShapeNode(rectOf: size)
        overlay.fillColor   = win ? SKColor(red: 0, green: 0.45, blue: 0, alpha: 0.82) : SKColor(red: 0.55, green: 0, blue: 0, alpha: 0.82)
        overlay.strokeColor = .clear
        overlay.position    = CGPoint(x: size.width/2, y: size.height/2)
        overlay.zPosition   = 200
        addChild(overlay)

        let emoji = SKLabelNode(fontNamed: "AvenirNext-Black")
        emoji.text     = win ? "🏆" : "💀"
        emoji.fontSize = 80
        emoji.position = CGPoint(x: 0, y: 60)
        overlay.addChild(emoji)

        let title = SKLabelNode(fontNamed: "AvenirNext-Black")
        title.text     = win ? "ПОБЕДА!" : "ПОРАЖЕНИЕ"
        title.fontSize = 50
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: -10)
        overlay.addChild(title)

        let sub = SKLabelNode(fontNamed: "AvenirNext-Medium")
        sub.text     = win ? "Уровень \(currentLevel) пройден!\nОчки: \(score)" : "Зомби добрались до дома...\nОчки: \(score)"
        sub.fontSize = 20; sub.fontColor = .white
        sub.numberOfLines = 2
        sub.position = CGPoint(x: 0, y: -60)
        overlay.addChild(sub)

        // Retry
        let btn = SKShapeNode(rectOf: CGSize(width: 220, height: 52), cornerRadius: 14)
        btn.fillColor   = .white; btn.strokeColor = .clear
        btn.position    = CGPoint(x: 0, y: -120); btn.name = "btnRetry"
        overlay.addChild(btn)
        let bl = SKLabelNode(fontNamed: "AvenirNext-Bold")
        bl.text = win ? "▶ Следующий уровень" : "🔄 Заново"
        bl.fontSize = 18; bl.fontColor = .black
        bl.verticalAlignmentMode = .center
        btn.addChild(bl)
    }

    // ── TOUCH FOR OVERLAY BUTTONS ─────────────────────────────────────────────
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let loc = t.location(in: self)
        for n in nodes(at: loc) {
            if n.name == "btnRetry" {
                if let v = view {
                    let next = GameScene(size: size)
                    next.scaleMode    = scaleMode
                    next.currentLevel = win ? currentLevel + 1 : currentLevel
                    next.totalWaves   = LevelManager.shared.wavesForLevel(next.currentLevel)
                    next.sun          = LevelManager.shared.startingSunForLevel(next.currentLevel)
                    v.presentScene(next, transition: .fade(withDuration: 0.4))
                }
                return
            }
        }
    }

    var win: Bool { return currentWave >= totalWaves && zombies.filter({ !$0.isDead }).isEmpty }
}
