//
//  ViewController.swift
//  GestureRecognizer
//
//  Created by Simon Gladman on 03/03/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//


import UIKit

class ViewController: UIViewController
{
    let touchOverlay = TouchOverlay()
    let rotatingSquare = Square()
    let clockwiseAntiClockwiseLabel = UILabel(frame: CGRectZero)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.layer.addSublayer(rotatingSquare)
        
        clockwiseAntiClockwiseLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(clockwiseAntiClockwiseLabel)
        
        let gestureRecogniser = SingleTouchRotationalGestureRecognizer(target: self, action: "rotateHandler:")
        view.addGestureRecognizer(gestureRecogniser)
    }
    
    func rotateHandler(gestureRecogniser : SingleTouchRotationalGestureRecognizer)
    {
        if gestureRecogniser.state == UIGestureRecognizerState.Began
        {
            view.layer.addSublayer(touchOverlay)
            
            if let centre = gestureRecogniser.getAveragePoint()
            {
                touchOverlay.frame = CGRect(origin: centre , size: CGSizeZero)
                touchOverlay.drawTouchOverlay(0)
            }
        }
        else if gestureRecogniser.state == UIGestureRecognizerState.Changed
        {
            if let angle = gestureRecogniser.getCurrentAngle()?.toRadians()
            {
                if let centre = gestureRecogniser.getAveragePoint()
                {
                    touchOverlay.frame = CGRect(origin: centre , size: CGSizeZero)
                }
                
                let rotateTransform = CATransform3DMakeRotation(CGFloat(angle), 0, 0, 1)
                touchOverlay.transform = rotateTransform
                rotatingSquare.transform = rotateTransform
                
                let distance = Int(gestureRecogniser.getDistanceFromAverage() ?? 0)
                touchOverlay.drawTouchOverlay(distance)
                rotatingSquare.drawSqure(distance)
                
                clockwiseAntiClockwiseLabel.text = gestureRecogniser.getRotatationDirection()?.rawValue
                
                println("angle = \(angle.toDegrees().description)")
            }
        }
        else // Ended, Cacelled or Failed...
        {
            touchOverlay.removeFromSuperlayer()
            clockwiseAntiClockwiseLabel.text = ""
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        rotatingSquare.frame = CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: 0, height: 0)
        
        clockwiseAntiClockwiseLabel.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: 40)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

