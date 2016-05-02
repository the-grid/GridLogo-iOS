//
//  ViewController.swift
//  GridLogo-Example
//
//  Created by Nicholas Velloff on 4/29/16.
//  Copyright © 2016 The Grid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let logo: GridLogo
    
    required init?(coder aDecoder: NSCoder) {
        let size: CGFloat = 100
        let duration: Double = 10
        logo = GridLogo(size: size, duration: duration, lineWidth: 1, bgColor: UIColor.grayColor(), fgColor: UIColor.whiteColor(), lineJoin: kCALineJoinMiter)
        
        super.init(coder: aDecoder)
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.logo.updateLineProperties(bgColor: UIColor.greenColor(), fgColor: UIColor.purpleColor(), lineJoin: kCALineJoinBevel)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        logo.frame.offsetInPlace(dx: screenWidth/2, dy: screenHeight/2)
        logo.frame.origin.x = screenWidth/2
        logo.frame.origin.y = screenHeight/2
        logo.transform = CGAffineTransformMakeRotation(CGFloat(-45).degreesToRadians)
        
        view.addSubview(logo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ context in
            self.logo.frame.origin.x = size.width/2
            self.logo.frame.origin.y = size.height/2
            }, completion: .None)
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}

extension Double {
    var degreesToRadians: Double { return self * M_PI / 180 }
    var radiansToDegrees: Double { return self * 180 / M_PI }
}

extension CGFloat {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}

extension Float  {
    var doubleValue:      Double { return Double(self) }
    var degreesToRadians: Float  { return Float(doubleValue * M_PI / 180) }
    var radiansToDegrees: Float  { return Float(doubleValue * 180 / M_PI) }
}