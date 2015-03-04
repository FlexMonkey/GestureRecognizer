//
//  SingleTouchRotationalGestureRecognizer.swift
//  GestureRecognizer
//
//  Created by Simon Gladman on 03/03/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//


import Foundation
import UIKit

public class SingleTouchRotationalGestureRecognizer: UIGestureRecognizer
{
    private var touchePoints: [CGPoint] = [CGPoint]()
    private var gestureAngle: Float = 0
    
    private var rotatationDirection: RotatationDirection?
    private var currentAngle: Float?
    private var averagePoint: CGPoint?
    private var distanceFromCentre: Float?
    
    // MARK: Initialise
    
    public override init(target:AnyObject, action:Selector)
    {
        super.init(target: target, action: action)
    }
    
    // MARK: Getters
    
    func getRotatationDirection() -> RotatationDirection?
    {
        return rotatationDirection
    }
    
    func getCurrentAngle() -> Float?
    {
        return currentAngle
    }
    
    func getCentrePoint() -> CGPoint?
    {
        return averagePoint
    }
    
    func getDistanceFromCentre() -> Float?
    {
        return distanceFromCentre
    }
    
    
    // MARK: Touch handlers
    
    override public func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
    {
        super.touchesBegan(touches, withEvent: event)
        
        let touch = touches.anyObject() as UITouch
        let currentPoint = touch.locationInView(self.view)
        
        touchePoints = [currentPoint]
        
        state = UIGestureRecognizerState.Began
    }
    
    override public func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
    {
        super.touchesMoved(touches, withEvent: event)
        
        let touch = touches.anyObject() as UITouch
        let currentPoint = touch.locationInView(self.view)
        let previousPoint = touchePoints.last ?? CGPointZero
        
        let distance = currentPoint.distance(previousPoint)
        
        if distance > 2.0
        {
            averagePoint = CGPoint(x: 0, y: 0)
            
            let lastGestureAngle:Float = gestureAngle
            
            touchePoints.append(currentPoint)
            
            for touchPoint in touchePoints
            {
                averagePoint!.x += touchPoint.x
                averagePoint!.y += touchPoint.y
            }
            
            averagePoint!.x = averagePoint!.x / CGFloat(touchePoints.count)
            averagePoint!.y = averagePoint!.y / CGFloat(touchePoints.count)
            
            let dx = Float(averagePoint!.x - currentPoint.x)
            let dy = Float(averagePoint!.y - currentPoint.y)
            gestureAngle = atan2(dy, dx) * Float(180.0 / M_PI)
            
            if(abs(gestureAngle - lastGestureAngle) < 45)
            {
                rotatationDirection = gestureAngle < lastGestureAngle ? RotatationDirection.AntiClockwise : RotatationDirection.Clockwise
                
                currentAngle = gestureAngle
                
                distanceFromCentre = currentPoint.distance(averagePoint!)
                
                state = UIGestureRecognizerState.Changed
            }
            
        }
    }
    
    public override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
    {
        super.touchesEnded(touches, withEvent: event)
        
        rotatationDirection = nil
        currentAngle = nil
        distanceFromCentre = nil
        
        state = UIGestureRecognizerState.Ended
    }
    
}

enum RotatationDirection: Int
{
    case AntiClockwise = -1
    case Clockwise = 1
}

extension CGPoint
{
    func distance(otherPoint: CGPoint) -> Float
    {
        let xSquare = Float((self.x - otherPoint.x) * (self.x - otherPoint.x))
        let ySquare = Float((self.y - otherPoint.y) * (self.y - otherPoint.y))
        
        return sqrt(xSquare + ySquare)
    }
}