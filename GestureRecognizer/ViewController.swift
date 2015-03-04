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
    let uiview = UIView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        uiview.backgroundColor = UIColor.blackColor()
        view.addSubview(uiview)
        
        let gestureRecogniser = SingleTouchRotationalGestureRecognizer(target: self, action: "rotateHandler:")
        
        view.addGestureRecognizer(gestureRecogniser)
    }
    
    func rotateHandler(gestureRecogniser : SingleTouchRotationalGestureRecognizer)
    {
        println("\(gestureRecogniser.getRotatationDirection()?.rawValue)")
        println("\(gestureRecogniser.getDistanceFromCentre())")
        println("\(gestureRecogniser.getCurrentAngle())")
        println("--------")
        
        uiview.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        
        if let angle = gestureRecogniser.getCurrentAngle()
        {
            let transform = CGAffineTransformMakeRotation(CGFloat(angle / Float(180.0 / M_PI)))

            uiview.transform = transform
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



