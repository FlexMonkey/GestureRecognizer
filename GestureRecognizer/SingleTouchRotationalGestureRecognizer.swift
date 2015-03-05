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
    private var touchPoints: [CGPoint] = [CGPoint]()
    private var gestureAngle: Float = 0
    
    private var rotatationDirection: RotatationDirection?
    private var currentAngle: Float?
    private var averagePoint: CGPoint?
    private var distanceFromAverage: Float?
    
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
        if let currentAngle = currentAngle
        {
            return currentAngle + 180
        }
        else
        {
            return nil
        }
    }
    
    func getAveragePoint() -> CGPoint?
    {
        return averagePoint
    }
    
    func getDistanceFromAverage() -> Float?
    {
        return distanceFromAverage
    }
    
    
    // MARK: Touch handlers
    
    override public func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
    {
        super.touchesBegan(touches, withEvent: event)
        
        let touch = touches.anyObject() as UITouch
        let currentPoint = touch.locationInView(self.view)
        
        averagePoint = currentPoint
        
        touchPoints = [currentPoint]
        
        state = UIGestureRecognizerState.Began
    }
    
    override public func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
    {
        super.touchesMoved(touches, withEvent: event)
        
        let touch = touches.anyObject() as UITouch
        let currentPoint = touch.locationInView(self.view)
        let previousPoint = touchPoints.last ?? CGPointZero
        
        let distance = currentPoint.distance(previousPoint)
        
        if distance > 2.0
        {
            averagePoint = CGPoint(x: 0, y: 0)
            
            let lastGestureAngle:Float = gestureAngle
            
            touchPoints.append(currentPoint)
            
            for touchPoint in touchPoints
            {
                averagePoint!.x += touchPoint.x
                averagePoint!.y += touchPoint.y
            }
            
            let touchPointsCount = CGFloat(touchPoints.count)
            averagePoint!.x = averagePoint!.x / touchPointsCount
            averagePoint!.y = averagePoint!.y / touchPointsCount
            
            let dx = Float(averagePoint!.x - currentPoint.x)
            let dy = Float(averagePoint!.y - currentPoint.y)
            gestureAngle = atan2(dy, dx).toDegrees()
            
            if(abs(gestureAngle - lastGestureAngle) < 45)
            {
                rotatationDirection = gestureAngle < lastGestureAngle ? RotatationDirection.AntiClockwise : RotatationDirection.Clockwise
                
                currentAngle = gestureAngle
                
                distanceFromAverage = currentPoint.distance(averagePoint!)
                
                state = UIGestureRecognizerState.Changed
            }
        }
    }
    
    public override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
    {
        super.touchesEnded(touches, withEvent: event)
        
        rotatationDirection = nil
        currentAngle = nil
        distanceFromAverage = nil
        touchPoints.removeAll(keepCapacity: false)
        
        state = UIGestureRecognizerState.Ended
    }
    
}

enum RotatationDirection: String
{
    case AntiClockwise = "Anti-Clockwise"
    case Clockwise = "Clockwise"
}

