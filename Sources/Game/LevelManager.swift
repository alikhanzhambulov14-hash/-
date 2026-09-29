import Foundation

class LevelManager {
    static let shared = LevelManager()
    
    private let levelKey = "PvZ_CurrentLevel"
    
    var currentLevel: Int {
        get {
            let lvl = UserDefaults.standard.integer(forKey: levelKey)
            return lvl == 0 ? 1 : lvl
        }
        set {
            UserDefaults.standard.set(newValue, forKey: levelKey)
        }
    }
    
    // Ordered list of plant unlocks by level
    let unlockOrder: [PlantType] = [
        .peashooter, // Level 1 (always unlocked)
        .sunflower,  // Unlocked after Level 1 (for Level 2)
        .cherrybomb, // Unlocked after Level 2 (for Level 3)
        .wallnut,    // Unlocked after Level 3
        .potatomine, // Level 5
        .snowpea,    // Level 6
        .chomper,    // Level 7
        .repeater,   // Level 8
        .puffshroom, // Level 9 (Night)
        .sunshroom,
        .fumeshroom,
        .squash,
        .threepeater,
        .jalapeno,
        .tallnut,
        .melonpult,
        .cabbagepult,
        .wintermelon,
        .torchwood
    ]
    
    func getAvailablePlants() -> [PlantType] {
        let maxIndex = min(currentLevel, unlockOrder.count)
        return Array(unlockOrder[0..<maxIndex])
    }
    
    func getZombieCountForCurrentLevel() -> Int {
        // Simple progression
        return currentLevel * 5 + 5
    }
    
    func completeLevel() {
        currentLevel += 1
    }
}
