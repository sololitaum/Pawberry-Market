import SpriteKit
import GameplayKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sprite: SKSpriteNode!
    var frozenSectionOpened = false
    
    override func didMove(to view: SKView) {
        
        // Set up background
        let Storebackground = SKSpriteNode(imageNamed: "Store")
        Storebackground.size = self.size
        Storebackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(Storebackground)
        
        Storebackground.zPosition = -1  // Ensure the background is behind other elements
        
        // Set the scene as the contact delegate
        self.physicsWorld.contactDelegate = self
        
        let penguinTexture = SKTexture(imageNamed: "Penguin")
        sprite = SKSpriteNode(texture: penguinTexture)
        sprite.size = CGSize(width: 100, height: 130)
                              
        
        if let savedPosition = UserDefaults.standard.array(forKey: "PlayerPosition") as? [CGFloat] {
              var xPosition = savedPosition[0]
              var yPosition = savedPosition[1]
              
        
                  xPosition += 50  // Apply an offset to move away from the box
                  yPosition += 50  // Apply an offset to move away from the box
              

              sprite.position = CGPoint(x: xPosition, y: yPosition)
          } else {
              // Set sprite position (bottom-right corner of the screen)
              let bottomRightX = self.frame.maxX - sprite.size.width / 2
              let bottomRightY = self.frame.minY + sprite.size.height / 2
              sprite.position = CGPoint(x: bottomRightX, y: bottomRightY)
          }
        
        // Add sprite to the scene
        self.addChild(sprite)
        
        // Add boundaries around the screen
        createBoundaries()
        
        // Create and add 3 larger gray boxes at specified positions
        createGrayBoxes()
        
        // Set the blue sprite's physics body (for collision detection)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.isDynamic = true // Dynamic (can move)
        sprite.physicsBody?.affectedByGravity = false // No gravity effect
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Player
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle
    }
    
    // Create boundaries for the scene to prevent falling out of bounds
    func createBoundaries() {
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 1.0
        self.physicsBody = borderBody
    }
    
    func createGrayBoxes() {
        // Create a larger gray box for the top right corner
        let produce = SKTexture(imageNamed: "Produce")
        let topRightBox = SKSpriteNode(texture: produce, size: CGSize(width: 250, height: 200))
        topRightBox.position = CGPoint(x: self.frame.maxX - 170, y: self.frame.maxY - 300) // Top right
        topRightBox.name = "topRight" // Assign a name for touch detection
        topRightBox.physicsBody = SKPhysicsBody(rectangleOf: topRightBox.size) // Make the box solid
        topRightBox.physicsBody?.isDynamic = false // Static (doesn't move)
        topRightBox.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        topRightBox.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        topRightBox.physicsBody?.collisionBitMask = PhysicsCategory.Player
        self.addChild(topRightBox)
        
        let fridge = SKTexture(imageNamed: "Fridge")
        let middleLeftBox = SKSpriteNode(texture: fridge, size: CGSize(width: 200, height: 275))
        middleLeftBox.position = CGPoint(x: self.frame.minX + 160, y: self.frame.midY ) // Middle left
        middleLeftBox.name = "middleLeft" // Assign a name for touch detection
        middleLeftBox.physicsBody = SKPhysicsBody(rectangleOf: middleLeftBox.size) // Make the box solid
        middleLeftBox.physicsBody?.isDynamic = false // Static (doesn't move)
        middleLeftBox.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        middleLeftBox.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        middleLeftBox.physicsBody?.collisionBitMask = PhysicsCategory.Player
        self.addChild(middleLeftBox)
        
        let MeatSection = SKTexture(imageNamed: "MeatSection")
        let topLeftBox = SKSpriteNode(texture: MeatSection, size: CGSize(width: 200, height: 250))
        topLeftBox.position = CGPoint(x: self.frame.minX + 150, y: self.frame.maxY - 300) // Top left
        topLeftBox.name = "topLeft" // Assign a name for touch detection
        topLeftBox.physicsBody = SKPhysicsBody(rectangleOf: topLeftBox.size) // Make the box solid
        topLeftBox.physicsBody?.isDynamic = false // Static (doesn't move)
        topLeftBox.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        topLeftBox.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        topLeftBox.physicsBody?.collisionBitMask = PhysicsCategory.Player
        self.addChild(topLeftBox)
        
        let boxedFood = SKTexture(imageNamed: "boxedFood")
        let bottomLeftBox = SKSpriteNode(texture: boxedFood, size: CGSize(width: 200, height: 200))
        bottomLeftBox.position = CGPoint(x: self.frame.minX + 150, y: self.frame.minY + 150) // Bottom left
        bottomLeftBox.name = "bottomLeft" // Assign a name for touch detection
        bottomLeftBox.physicsBody = SKPhysicsBody(rectangleOf: bottomLeftBox.size) // Make the box solid
        bottomLeftBox.physicsBody?.isDynamic = false // Static (doesn't move)
        bottomLeftBox.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        bottomLeftBox.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        bottomLeftBox.physicsBody?.collisionBitMask = PhysicsCategory.Player
        self.addChild(bottomLeftBox)
        
        let register = SKTexture(imageNamed: "Register")
        let middleRightBox = SKSpriteNode(texture: register, size: CGSize(width: 250, height: 250))
        middleRightBox.position = CGPoint(x: self.frame.midX + 200, y: self.frame.midY)
        middleRightBox.name = "middleRight"
        middleRightBox.physicsBody = SKPhysicsBody(rectangleOf: middleRightBox.size)
        middleRightBox.physicsBody?.isDynamic = false
        middleRightBox.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        middleRightBox.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        middleRightBox.physicsBody?.collisionBitMask = PhysicsCategory.Player
        self.addChild(middleRightBox)
        
        
    }
    
    // Detect touches and move the blue sprite to the tapped box
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            // Check if the touch is on any of the gray boxes
            if let node = atPoint(touchLocation) as? SKSpriteNode {
                if node.name == "topRight" || node.name == "middleLeft" || node.name == "bottomLeft" || node.name == "topLeft" || node.name == "middleRight"{
                    moveBlueSpriteTo(node: node)
                }
            }
        }
    }
    
    // Move the blue sprite to specific coordinates near the tapped gray box
    func moveBlueSpriteTo(node: SKSpriteNode) {
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        
        if node.name == "topRight" {
            offsetX = -node.size.width / 2 - sprite.size.width / 2
        } else if node.name == "middleLeft" || node.name == "topLeft" || node.name == "bottomLeft" || node.name == "middleRight" {
            offsetX = node.size.width / 2 + sprite.size.width / 2
        }
        
        let targetPosition = CGPoint(x: node.position.x + offsetX, y: node.position.y + offsetY)
        let action = SKAction.move(to: targetPosition, duration: 3.0)
        //Set constant velocity
        sprite.run(action)
    }
    
    // Example of defining the PhysicsCategory struct
    struct PhysicsCategory {
        static let Player: UInt32 = 0x1 << 0
        static let Obstacle: UInt32 = 0x1 << 1
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var collidedNode: SKNode?

        if contact.bodyA.categoryBitMask == PhysicsCategory.Obstacle {
            collidedNode = contact.bodyA.node
        } else if contact.bodyB.categoryBitMask == PhysicsCategory.Obstacle {
            collidedNode = contact.bodyB.node
        }

        if let nodeName = collidedNode?.name, nodeName == "topLeft" {
            print("Opened frozen section")
            openFrozenSection()

        }
    }

    //Move the sprite a little bit back so its not in an
    func openFrozenSection() {
        // Ensure the FrozenSection scene is properly initialized
        //UserDefaults.standard.set([sprite.position.x, sprite.position.y ], forKey: "playerPosition")
        UserDefaults.standard.set([sprite.position.x, sprite.position.y], forKey: "PlayerPosition")
        let frozenScene = FrozenSection(size: self.size)  // Initialize with the correct size
        
        //Save the players current position
       
        frozenScene.scaleMode = .aspectFill

        // Check if self.view is available
        guard let view = self.view else {
            print("Error: self.view is nil")
            return
        }

        // Present the FrozenSection scene with a transition
        let transition = SKTransition.fade(withDuration: 0.5)
        view.presentScene(frozenScene, transition: transition)
        
       
    }


}

//When you close and reopen the app you want to start at the starting poisition
//When you collide with the frozen section you open the shelf
//When you close the shelf you will be offset a bit outside of the shelf so it doeesn't create an inf loop
// Do this to the rest of the sections

