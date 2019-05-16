//
//  HelpingFunctions.swift
//  FruitNinja
//
//  Created by Administrator on 21/04/2019.
//  Copyright © 2019 mahesh lad. All rights reserved.
//

import Foundation
import UIKit

func randomCGFloat(_ lowerLimit: CGFloat, _ upperLimit: CGFloat) -> CGFloat{
    return  lowerLimit + CGFloat(arc4random()) / CGFloat(UInt32.max) * (upperLimit - lowerLimit)
    //lowerLimit + CGFloat(arc4random_uniform(UInt32(upperLimit - lowerLimit + 1)))
}

