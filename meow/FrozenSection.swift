import SpriteKit

class FrozenSection: SKScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Set up background
        let background = SKSpriteNode(imageNamed: "Shelf")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(background)
        background.zPosition = -1  // Ensure the background is behind other elements
        
        // Create a "Back" button using SKLabelNode
        let backButton = SKLabelNode(text: "Back to Game")
        backButton.fontName = "Arial"
        backButton.fontSize = 36
        backButton.fontColor = .white
        backButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 4)
        backButton.name = "backButton"
        self.addChild(backButton)
        
        // Add frozen food items
        addFrozenItems()
    }
    
    func addFrozenItems() {
        let chickenTexture = SKTexture(imageNamed: "chicken")
        let fishTexture = SKTexture(imageNamed: "fish")
        
        let middleX = self.size.width / 2
        let middleY = self.size.height / 2
        let spacing: CGFloat = 200 // Distance between items

        func createFoodItem(named name: String, texture: SKTexture, position: CGPoint) {
            if GameData.shared.removedItems.contains(name) { return } // Skip if removed
            
            let sprite = SKSpriteNode(texture: texture)
            sprite.size = CGSize(width: 150, height: 150)
            sprite.position = position
            sprite.name = name
            self.addChild(sprite)
        }
        
        // Create the items only if they haven’t been removed
        createFoodItem(named: "chicken1", texture: chickenTexture, position: CGPoint(x: middleX - spacing, y: middleY + 50))
        createFoodItem(named: "fish", texture: fishTexture, position: CGPoint(x: middleX, y: middleY + 50))
        createFoodItem(named: "chicken2", texture: chickenTexture, position: CGPoint(x: middleX + spacing, y: middleY + 50))
    }
    
    // Detect touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            let node = atPoint(touchLocation)
            
            // Check if the back button was tapped
            if let labelNode = node as? SKLabelNode, labelNode.name == "backButton" {
                transitionBackToGameScene()
                return
            }
            
            // Check if a food item was tapped and remove it
            if let spriteNode = node as? SKSpriteNode, let itemName = spriteNode.name {
                GameData.shared.removedItems.insert(itemName) // Store in the shared manager
                print(GameData.shared.removedItems)
                spriteNode.removeFromParent()  // Remove from scene
            }
        }
    }

    // Function to transition back to GameScene
    func transitionBackToGameScene() {
        if let gameScene = GameScene(fileNamed: "GameScene") {
            gameScene.scaleMode = .aspectFill
            self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.5))
        }
    }
}
