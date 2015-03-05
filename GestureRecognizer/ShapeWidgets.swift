//
//  ShapeWidgets.swift
//  GestureRecognizer
//
//  Created by Simon Gladman on 04/03/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//


class Square: CAShapeLayer
{
    func drawSqure(size : Int)
    {
        self.fillColor = UIColor.lightGrayColor().CGColor
        
        masksToBounds = false
        
        let squareRect = CGRect(x: 0 - size / 2, y: 0 - size / 2, width: size, height: size)
        let squarePath = UIBezierPath(roundedRect: squareRect, cornerRadius: 10)
        
        path = squarePath.CGPath
    }
}

class TouchOverlay: CAShapeLayer
{
    func drawTouchOverlay(length: Int)
    {
        lineWidth = 1
        masksToBounds = false
        
        drawsAsynchronously = false
        
        var touchOverlayPath = UIBezierPath()
        
        let originRect = CGRect(x: -5, y: -5, width: 10, height: 10)
        let originCircle = UIBezierPath(ovalInRect: originRect)
        touchOverlayPath.appendPath(originCircle)
        
        let connectingLineRect = CGRect(x: 0, y: 0, width: length, height: 1)
        let connectingLine = UIBezierPath(rect: connectingLineRect)
        touchOverlayPath.appendPath(connectingLine)
        
        let currentPointRect = CGRect(x: length, y: -10, width: 20, height: 20)
        let currentPointCircle = UIBezierPath(ovalInRect: currentPointRect)
        touchOverlayPath.appendPath(currentPointCircle)
        
        path = touchOverlayPath.CGPath
    }    
}

