//
//  GridLogo.swift
//  GridLogo
//
//  Created by Nicholas Velloff on 6/27/15.
//  Copyright (c) 2015 Rituwall, Inc. All rights reserved.
//

import UIKit

extension CGSize {
    func toInt() -> CGSize {
        return CGSize(width: round(self.width), height: round(self.height))
    }
}

extension CGPoint {
    func toInt() -> CGPoint {
        return CGPoint(x: round(self.x), y: round(self.y))
    }
}

public class GridLogo: UIView {
    
    static let xstep = [1,0,-1,0]
    static let ystep = [0,1,0,-1]
    
    static func shapeLayerWithLogoPath(
        strokeColor: UIColor,
        lineJoin: String,
        lineWidth: CGFloat,
        turns: Int,
        md: CGFloat
        ) -> CAShapeLayer {
            var curr = CGPointZero
            var last = CGPointZero
            var scalestep: CGFloat
            let path = UIBezierPath()
            path.moveToPoint(curr)
        
            for i in 0 ..< turns {
                scalestep = round((CGFloat(i) + 1) / 2.0) * CGFloat(md)
                curr = CGPoint(x: CGFloat(last.x) + (scalestep * CGFloat(xstep[i % 4])), y: CGFloat(last.y) + (scalestep * CGFloat(ystep[i % 4]))).toInt()
                
                if i + 1 == turns {
                    curr = CGPoint(x: CGFloat(curr.x) - (md * CGFloat(xstep[i % 4])), y: CGFloat(curr.y) - (md * CGFloat(ystep[i % 4]))).toInt()
                }
                
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
    
    static func setupAnimation(duration: CFTimeInterval, repeatCount: Float) -> CAAnimationGroup {
        
        let pathAnimationIn = CABasicAnimation(keyPath: "strokeEnd")
        let pathAnimationOut = CABasicAnimation(keyPath: "strokeStart")
        let pathAnimationGroup = CAAnimationGroup()
        let startPos: CGFloat = 0.0
        let endPos: CGFloat = 1.0
        
        pathAnimationIn.fromValue = startPos
        pathAnimationIn.toValue = endPos
        pathAnimationIn.duration = duration / 2
        pathAnimationIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        pathAnimationOut.fromValue = startPos
        pathAnimationOut.toValue = endPos
        pathAnimationOut.duration = duration / 2
        pathAnimationOut.beginTime = duration / 2
        pathAnimationOut.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        pathAnimationGroup.animations = [pathAnimationIn, pathAnimationOut]
        pathAnimationGroup.duration = duration
        pathAnimationGroup.repeatCount = repeatCount
        pathAnimationGroup.removedOnCompletion = false
        pathAnimationGroup.fillMode = kCAFillModeBackwards
        
        return pathAnimationGroup
    }
    
    private var mystic: CGFloat = 4
    private var turns: Int
    private var md: CGFloat
    private var bgLayer: CAShapeLayer
    private var fgLayer: CAShapeLayer
    private let pathAnimationGroup: CAAnimationGroup
    private var duration: CFTimeInterval
    private var reverses = false
    private var lineWidth: CGFloat
    private let fadeDuration = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
    
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
        mystic m: CGFloat,
        duration d: CFTimeInterval,
        lineWidth lw: CGFloat = 1,
        bgColor: UIColor = UIColor(red: 51/255, green: 51/255, blue: 48/255, alpha: 1),
        fgColor: UIColor = UIColor(red: 1, green: 246/255, blue: 153/255, alpha: 1),
        lineJoin: String = kCALineJoinMiter,
        turns t: Int = 9,
        repeatCount: Float = 14
        )
    {
        mystic = m
        duration = d
        lineWidth = lw
        md = m
        turns = t
        bgLayer = GridLogo.shapeLayerWithLogoPath(bgColor, lineJoin: lineJoin, lineWidth: lineWidth, turns: turns, md: md)
        fgLayer = GridLogo.shapeLayerWithLogoPath(fgColor, lineJoin: lineJoin, lineWidth: lineWidth, turns: turns, md: md)
        pathAnimationGroup = GridLogo.setupAnimation(duration, repeatCount: repeatCount)
        
        super.init(frame: CGRectZero)
        
        layer.addSublayer(bgLayer)
        layer.addSublayer(fgLayer)
        userInteractionEnabled = false
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateLineColors(bgColor: UIColor, fgColor: UIColor, lineJoin: String = kCALineJoinMiter) {
        bgLayer = GridLogo.shapeLayerWithLogoPath(bgColor, lineJoin: lineJoin, lineWidth: lineWidth, turns: turns, md: md)
        fgLayer = GridLogo.shapeLayerWithLogoPath(fgColor, lineJoin: lineJoin, lineWidth: lineWidth, turns: turns, md: md)
    }
    
    
    public func show() {
        startAnimation()
        fgLayer.opacity = 1
        bgLayer.opacity = 1
        fgLayer.addAnimation(fadeInAnimation, forKey: "fade")
        bgLayer.addAnimation(fadeInAnimation, forKey: "fade")
    }
    
    public func hide() {
        fgLayer.opacity = 0
        bgLayer.opacity = 0
        fgLayer.addAnimation(fadeOutAnimation, forKey: "fade")
        bgLayer.addAnimation(fadeOutAnimation, forKey: "fade")
    }
    
    func startAnimation() {
        fgLayer.removeAllAnimations()
        fgLayer.addAnimation(pathAnimationGroup, forKey: "group")
    }
    
    func endAnimation() {
        fgLayer.removeAllAnimations()
    }
}