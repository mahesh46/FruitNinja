//
//  GameScene.swift
//  FruitNinja
//
//  Created by Mahesh Lad on 21/04/2019.
//  Copyright © 2019 mahesh lad. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GamePhase {
    case Ready
    case InPlay
    case GameOver
}

class GameScene: SKScene {
    
    var gamePhase = GamePhase.Ready
    var score = 0
    var best = 0
    var miss = 0
    var missMax = 5
    var xMarks = XMarks()
    
    private var scoreLabel = SKLabelNode()
    private var promptLabel = SKLabelNode()
    private var bestLabel = SKLabelNode()
    
    var fruitThrowTimer = Timer()
    var explodeOverlay = SKShapeNode()
    
    override func didMove(to view: SKView) {
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "\(score)"
        bestLabel = childNode(withName: "bestLabel") as! SKLabelNode
        bestLabel.text =  "Best: \(best)"
        promptLabel = childNode(withName: "promptLabel") as! SKLabelNode
        promptLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        
        xMarks = XMarks(num: missMax)
        xMarks.position = CGPoint(x: size.width - 60, y: size.height - 120)
        addChild(xMarks)
        
        explodeOverlay = SKShapeNode(rect:  CGRect(x: 0, y: 0, width: size.width, height: size.height))
        explodeOverlay.fillColor = .white
        addChild(explodeOverlay)
        explodeOverlay.alpha = 0
        
        //load data
        if UserDefaults.standard.object(forKey: "bestData") != nil {
            best = UserDefaults.standard.object(forKey: "bestData") as! Int
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        if gamePhase == .Ready {
            gamePhase = .InPlay
            startGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for t in touches {
         let location = t.location(in: self)
         let previous = t.previousLocation(in: self)
          //  self.touchMoved(toPoint: t.location(in: self))
            for node in nodes(at: location) {
                if node.name == "fruit" {
                    score += 1
                    scoreLabel.text = "\(score)"
                    
                    node.removeFromParent()
                    
                    particleEffect(position: node.position)
                    playSoundEffect(soundFile: "whoosh")
                }
                
                if node.name == "bomb" {
                    bombExplode()
                    playSoundEffect(soundFile: "explosion")
                    gameOver()
                    particleEffect(position: node.position)
                }
            }
            
           let line = TrailLine(pos: location, lastPos: previous, width: 8, color: .yellow)
            addChild(line)
        }
    }
    
    override func didSimulatePhysics() {
        for fruit in children {
            if fruit.position.y < -100   {
               
                fruit.removeFromParent()
                if  fruit.name == "fruit" {
                   missfruit()
                }
            }
        }
    }
    
    func startGame() {
        miss = 0
        score = 0
        scoreLabel.text  = "\(score)"
        bestLabel.text = "Best: \(best)"
        promptLabel.isHidden = true
        
        xMarks.reset()
        
        fruitThrowTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in
            self.createFruits()
        })
    }
    
    func createFruits() {
       
        let numberOffruits =  1 + Int(arc4random_uniform(UInt32(6)))
        
        for _ in 0..<numberOffruits {
        let fruit = Fruit()
      
        let xpos =  randomCGFloat(0, size.width)
          
        fruit.position.x = xpos
        fruit.position.y =  -100
        addChild(fruit)
        
        if fruit.position.x < size.width/2 {
            fruit.physicsBody?.velocity.dx = randomCGFloat(0, 200)
        }
        if fruit.position.x > size.width/2 {
            fruit.physicsBody?.velocity.dx = randomCGFloat(0, -200)
        }
        
        fruit.physicsBody?.velocity.dy = randomCGFloat(500, 800)
        fruit.physicsBody?.angularVelocity = randomCGFloat(-5,5)
        }
    }
    
    func missfruit() {
        miss += 1
        xMarks.update(num: miss)
        if miss == missMax {
            gameOver()
        }
    }
    
    func bombExplode() {
        
        for case let fruit as Fruit in children {
            fruit.removeFromParent()
            //explosion effect
            particleEffect(position: fruit.position)
        }
        
        explodeOverlay.run(SKAction.sequence([
            SKAction.fadeAlpha(to: 1, duration: 0),
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeAlpha(to: 0, duration: 0),
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeAlpha(to: 1, duration: 0),
            SKAction.wait(forDuration: 0.2),
             SKAction.fadeAlpha(to: 0, duration: 0)
            ]))
        
        //sound effect
    }
    
    func gameOver() {
        if score > best {
            best = score
            
            //save data
            UserDefaults.standard.set(best, forKey: "bestData")
            UserDefaults.standard.synchronize()
        }
        
        promptLabel.isHidden = false
        promptLabel.text = "game over"
        promptLabel.setScale(0)
        promptLabel.run(SKAction.scale(to: 1, duration: 0.3))
        
        gamePhase = .GameOver
        
        fruitThrowTimer.invalidate()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            self.gamePhase = .Ready
        })
        
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func particleEffect(position : CGPoint) {
        if  let emitter = SKEffectNode(fileNamed: "Explode.sks") {
        emitter.position  = position
        addChild(emitter)
       }
    }
    
    func playSoundEffect(soundFile: String){
        let audioNode = SKAudioNode(fileNamed: soundFile)
        audioNode.autoplayLooped = false
        addChild(audioNode)
        audioNode.run(SKAction.play())
        audioNode.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.removeFromParent()
            ]))
    }
}
