//
//  Fruits.swift
//  FruitNinja
//
//  Created by Mahesh Lad on 21/04/2019.
//  Copyright © 2019 mahesh lad. All rights reserved.
//

import SpriteKit

class Fruit: SKNode {
    let fruitEmojis = ["🍒","🍓","🍇","🍎","🍉","🍑","🍊","🍋","🍍","🍌","🥑","🍏","🍈","🍐","🥝","🥭","🍅","🫐"]
   // let animalEmojis = ["🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐮","🐷","🐸","🐵","🐔","🐧","🐤","🦄","🐴"]
    let bombEmoji = "💣"
    override init() {
        super.init()
        var emoji = ""
        if randomCGFloat(0, 1) < 0.9 {
             name = "fruit"
            let n = Int(arc4random_uniform(UInt32(fruitEmojis.count)))
            emoji = fruitEmojis[n]
        } else {
             name = "bomb"
             emoji = bombEmoji
        }
        
        
        let label = SKLabelNode(text: emoji)
        label.fontSize = 120
        label.verticalAlignmentMode = .center
        addChild(label)
        
        physicsBody = SKPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
