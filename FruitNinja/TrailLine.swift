//
//  TrailLine.swift
//  FruitNinja
//
//  Created by Mahesh Ladr on 21/04/2019.
//  Copyright © 2019 mahesh lad. All rights reserved.
//

import SpriteKit

class TrailLine : SKShapeNode {
    
    var shrinkTimer = Timer()
    
    init(pos: CGPoint, lastPos: CGPoint, width: CGFloat, color: UIColor ) {
        super.init()
        let path = CGMutablePath()
        path.move(to: pos)
        path.addLine(to: lastPos)
        self.path = path
        lineWidth = width
        strokeColor = color
      
        shrinkTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { _ in
            self.lineWidth -= 1
            if self.lineWidth == 0 {
                self.shrinkTimer.invalidate()
                self.removeFromParent()
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
