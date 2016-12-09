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
        logo = GridLogo(size: size, duration: duration, lineWidth: 1, bgColor: UIColor.gray, fgColor: UIColor.white, lineJoin: kCALineJoinMiter)
        
        super.init(coder: aDecoder)
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.logo.updateLineProperties(bgColor: UIColor.green, fgColor: UIColor.purple, lineJoin: kCALineJoinBevel)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        logo.frame.origin.x = screenWidth/2
        logo.frame.origin.y = screenHeight/2
        logo.transform = CGAffineTransform(rotationAngle: CGFloat(-45).degreesToRadians)
        
        view.addSubview(logo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.logo.frame.origin.x = size.width/2
            self.logo.frame.origin.y = size.height/2
            }, completion: .none)
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
