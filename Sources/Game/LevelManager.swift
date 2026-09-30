import Foundation

enum LevelEnvironment {
    case day, night, pool, fog, roof
}

struct Wave {
    let zombies: [ZombieType]
    let delayBefore: TimeInterval
    let isHugeWave: Bool
}

struct LevelData {
    let id: Int
    let environment: LevelEnvironment
    let startingSun: Int
    let waves: [Wave]
}

class LevelManager {
    static let shared = LevelManager()
    
    private let levelKey = "PvZ_CurrentLevel"
    
    var currentLevelIndex: Int {
        get {
            let lvl = UserDefaults.standard.integer(forKey: levelKey)
            return lvl == 0 ? 1 : lvl
        }
        set {
            UserDefaults.standard.set(newValue, forKey: levelKey)
        }
    }
    
    var levels: [Int: LevelData] = [:]
    
    init() {
        generateAllLevels()
    }
    
    func generateAllLevels() {
        // Adventure Mode: 50 Levels
        for i in 1...50 {
            let env: LevelEnvironment
            if i <= 10 { env = .day }
            else if i <= 20 { env = .night }
            else if i <= 30 { env = .pool }
            else if i <= 40 { env = .fog }
            else { env = .roof }
            
            var waves: [Wave] = []
            let totalWaves = 10 + (i % 10) * 2
            for w in 1...totalWaves {
                let isHuge = (w == totalWaves / 2 || w == totalWaves)
                
                var zTypes: [ZombieType] = [.zombie]
                if i > 2 { zTypes.append(.conezombie) }
                if i > 4 { zTypes.append(.bucketzombie) }
                if env == .pool { zTypes.append(.zombieduck) }
                if isHuge && i > 15 { zTypes.append(.footballzombie) }
                if isHuge && i > 30 { zTypes.append(.gargantuar) }
                
                // Add random zombies from the available pool
                var waveZombies: [ZombieType] = []
                let zombieCount = 1 + (w / 3) + (isHuge ? 5 : 0)
                for _ in 0..<zombieCount {
                    waveZombies.append(zTypes.randomElement()!)
                }
                
                waves.append(Wave(zombies: waveZombies, delayBefore: isHuge ? 20.0 : 10.0, isHugeWave: isHuge))
            }
            
            let data = LevelData(id: i, environment: env, startingSun: env == .night || env == .fog ? 50 : 50, waves: waves)
            levels[i] = data
        }
    }
    
    func getCurrentLevelData() -> LevelData {
        return levels[currentLevelIndex] ?? levels[1]!
    }
    
    func completeLevel() {
        currentLevelIndex += 1
    }
}
