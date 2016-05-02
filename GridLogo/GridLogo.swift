//
//  GridLogo.swift
//  GridLogo
//
//  Created by Nicholas Velloff on 6/27/15.
//  Copyright (c) 2015 Rituwall, Inc. All rights reserved.
//

import UIKit

public class GridLogo: UIView {
    
    static let xstep = [1,0,-1,0]
    static let ystep = [0,1,0,-1]
    
    static func shapeLayerWithLogoPath(
        strokeColor: UIColor,
        lineJoin: String,
        lineWidth: CGFloat,
        turns: Int,
        size: CGFloat
        ) -> CAShapeLayer {
            var curr = CGPointZero
            var last = CGPointZero
            var scalestep: CGFloat
            let path = UIBezierPath()
            path.moveToPoint(curr)
            for i in 0 ..< turns {
                scalestep = round((CGFloat(i) + 1) / 2.0) * CGFloat(size)
                curr = CGPoint(x: CGFloat(last.x) + (scalestep * CGFloat(xstep[i % 4])), y: CGFloat(last.y) + (scalestep * CGFloat(ystep[i % 4])))
                
                
                if i + 1 == turns {
                    curr = CGPoint(x: CGFloat(curr.x) - (size * CGFloat(xstep[i % 4])), y: CGFloat(curr.y) - (size * CGFloat(ystep[i % 4])))
                }
                print("curr: \(curr)")
                path.addLineToPoint(curr)
                last  = curr
            }
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.CGPath
            shapeLayer.strokeColor = strokeColor.CGColor
            shapeLayer.fillColor = nil
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineJoin = lineJoin
            return shapeLayer
    }
    
    static func getCAAnimationGroup(duration: CFTimeInterval, repeatCount: Float) -> CAAnimationGroup {
        
        let pathAnimationIn = CABasicAnimation(keyPath: "strokeEnd")
        let pathAnimationOut = CABasicAnimation(keyPath: "strokeStart")
        let pathAnimationGroup = CAAnimationGroup()
        let startPos: CGFloat = 0.0
        let endPos: CGFloat = 1.0
        
        pathAnimationIn.fromValue = startPos
        pathAnimationIn.toValue = endPos
        pathAnimationIn.duration = duration / 2
        pathAnimationIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        pathAnimationOut.fromValue = startPos
        pathAnimationOut.toValue = endPos
        pathAnimationOut.duration = duration / 2
        pathAnimationOut.beginTime = duration / 2
        pathAnimationOut.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        pathAnimationGroup.animations = [pathAnimationIn, pathAnimationOut]
        pathAnimationGroup.duration = duration
        pathAnimationGroup.repeatCount = repeatCount
        pathAnimationGroup.removedOnCompletion = false
        pathAnimationGroup.fillMode = kCAFillModeBackwards
        
        return pathAnimationGroup
    }
    
    private var turns: Int = 9
    private var size: CGFloat
    private var reverses: Bool
    private var lineWidth: CGFloat
    private var bgLayer: CAShapeLayer? = .None
    private let fgLayer: CAShapeLayer
    
    let fadeInAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.5
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = 0
        return animation
    }()
    
    let fadeOutAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.5
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = 1
        return animation
    }()
    
    public init(
        size s: CGFloat,
        duration: CFTimeInterval,
        lineWidth lw: CGFloat = 1,
        bgColor: UIColor = UIColor(red: 51/255, green: 51/255, blue: 48/255, alpha: 1),
        fgColor: UIColor = UIColor(red: 1, green: 246/255, blue: 153/255, alpha: 1),
        lineJoin: String = kCALineJoinMiter,
        repeatCount: Float = 14.5,
        showBackground: Bool = true
        )
    {
        lineWidth = lw
        size = s/4
        reverses = false
        fgLayer = GridLogo.shapeLayerWithLogoPath(fgColor, lineJoin: lineJoin, lineWidth: lineWidth, turns: turns, size: size)
        let pathAnimationGroup = GridLogo.getCAAnimationGroup(duration, repeatCount: repeatCount)
        fgLayer.addAnimation(pathAnimationGroup, forKey: "group")
        super.init(frame: CGRectZero)
        
        userInteractionEnabled = false
        layer.addSublayer(fgLayer)
        
        if showBackground {
            bgLayer = GridLogo.shapeLayerWithLogoPath(bgColor, lineJoin: lineJoin, lineWidth: lineWidth, turns: turns, size: size)
        }
        guard let bgLayer = bgLayer else { return }
        layer.insertSublayer(bgLayer, atIndex: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateLineProperties(bgColor bgColor: UIColor, fgColor: UIColor, lineJoin: String = kCALineJoinMiter) {
        bgLayer?.strokeColor = bgColor.CGColor
        bgLayer?.lineJoin = lineJoin
        fgLayer.strokeColor = fgColor.CGColor
        fgLayer.lineJoin = lineJoin
    }
}