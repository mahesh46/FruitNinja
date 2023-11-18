//
//  XMarks.swift
//  FruitNinja
//
//  Created by Mahesh Lad on 21/04/2019.
//  Copyright © 2019 mahesh lad. All rights reserved.
//

import SpriteKit


class XMarks: SKNode {
    
    var xArray = [SKSpriteNode]()
    var numXs = Int()
    
    let blackXPic = SKTexture(imageNamed: "blackX")
    let redXPic = SKTexture(imageNamed: "redX")
    
     init(num: Int = 0) {
        super.init()
        numXs = num
        
        for i in 0..<num {
            let xMark = SKSpriteNode(imageNamed: "blackX")
            xMark.size = CGSize(width: 60, height: 60)
            xMark.position.x = -CGFloat(i)*70
            addChild(xMark)
            xArray.append(xMark)
        }
    }
    
    func update(num: Int) {
        if num <= numXs {
        xArray[xArray.count - num].texture = redXPic
        }
    }
    
    func reset() {
        for xMark in xArray {
            xMark.texture = blackXPic
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
