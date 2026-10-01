import Foundation

// LevelManager — simple level progression tracker
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

    // Total number of adventure levels
    let totalLevels = 50

    // Waves count increases with level
    func wavesForLevel(_ level: Int) -> Int {
        return min(3 + level, 10)
    }

    // Starting sun
    func startingSunForLevel(_ level: Int) -> Int {
        return level <= 5 ? 150 : 50
    }

    // Available plants for seed chooser (unlocks more as level increases)
    func availablePlants(forLevel level: Int) -> [PlantKind] {
        var plants: [PlantKind] = [.sunflower, .peashooter, .wallnut]
        if level >= 2  { plants += [.cherrybomb] }
        if level >= 3  { plants += [.snowpea] }
        if level >= 4  { plants += [.repeater] }
        if level >= 5  { plants += [.chomper, .potatomine] }
        if level >= 6  { plants += [.squash, .threepeater] }
        if level >= 8  { plants += [.tallnut, .jalapeno] }
        if level >= 10 { plants += [.cactus, .sunshroom] }
        if level >= 12 { plants += [.magnetshroom, .gloomshroom] }
        return plants
    }
}
