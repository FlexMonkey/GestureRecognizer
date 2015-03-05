//
//  Extensions.swift
//  GestureRecognizer
//
//  Created by Simon Gladman on 04/03/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

extension CGPoint
{
    func distance(otherPoint: CGPoint) -> Float
    {
        let xSquare = Float((self.x - otherPoint.x) * (self.x - otherPoint.x))
        let ySquare = Float((self.y - otherPoint.y) * (self.y - otherPoint.y))
        
        return sqrt(xSquare + ySquare)
    }
}

extension Float
{
    func toRadians() -> Float
    {
        return self / Float(180.0 / M_PI)
    }
    
    func toDegrees() -> Float
    {
        return self * Float(180.0 / M_PI)
    }
}
