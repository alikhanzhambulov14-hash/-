import Foundation

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

    let totalLevels = 50

    func wavesForLevel(_ level: Int) -> Int {
        return min(3 + level, 10)
    }

    func startingSunForLevel(_ level: Int) -> Int {
        return level <= 5 ? 150 : 50
    }

    func availablePlants(forLevel level: Int) -> [Plant] {
        var plants: [Plant] = [.sunflower, .peashooter, .wallnut]
        if level >= 2  { plants += [.cherrybomb] }
        if level >= 3  { plants += [.snowpea] }
        if level >= 4  { plants += [.repeater] }
        if level >= 5  { plants += [.chomper, .potatomine] }
        if level >= 6  { plants += [.squash, .threepeater] }
        if level >= 8  { plants += [.tallnut, .jalapeno] }
        if level >= 10 { plants += [.cactus, .sunshroom] }
        if level >= 12 { plants += [.magnetshroom, .gloombshroom] }
        return plants
    }
}
