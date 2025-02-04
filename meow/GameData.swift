import Foundation

class GameData {
    static let shared = GameData()
    
    // Track removed items across scene transitions
    var removedItems: Set<String> = []
    
    
    private init() {} // Prevents external instantiation
}
