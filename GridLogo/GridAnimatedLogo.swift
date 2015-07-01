//
//  GridAnimatedLogo.swift
//  GridLogo
//
//  Created by Nicholas Velloff on 6/27/15.
//  Copyright (c) 2015 Rituwall, Inc. All rights reserved.
//

import UIKit

public class AnimatedGridLogo: UIView {
    
    var mystic: CGFloat = 4
    var turns = 9
    var xstep = [1,0,-1,0]
    var ystep = [0,1,0,-1]
    
    var md: CGFloat!
    var strokeRatio: CGFloat!
    var last: CGPoint!
    var curr: CGPoint!
    var scalestep: CGFloat!
    
    weak var bgLayer: CAShapeLayer?
    weak var fgLayer: CAShapeLayer?
    var pathAnimation: CABasicAnimation!
    
    private var duration: CFTimeInterval = 3.0
    private var startPos: CGFloat = 0.0
    private var endPos: CGFloat = 1.0
    private var reverses = true
    private var repeatCount: CGFloat = 5.0
    private var lineWidth: CGFloat?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    public convenience init(mystic: CGFloat, duration: CFTimeInterval, lineWidth: CGFloat?) {
        self.init(frame: CGRectZero)
        self.mystic = mystic
        self.duration = duration
        self.repeatCount = 1
        self.reverses = false
        setup()
    }
    
    public convenience init(mystic: CGFloat, lineWidth: CGFloat?) {
        self.init(frame: CGRectZero)
        self.mystic = mystic
        setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    func setup() {
        self.alpha = 0
        self.md = CGFloat(mystic * mystic)
        self.strokeRatio = CGFloat(md) / CGFloat(mystic)
        self.userInteractionEnabled = false
        addBackground()
        setupAnimation()
    }
    
    var logoPath: UIBezierPath {
        get{
            self.curr = CGPoint.zeroPoint
            self.last = CGPoint.zeroPoint
            var path = UIBezierPath()
            path.moveToPoint(curr)
            
            for var i=0; i < turns; i++ {
                scalestep = round((CGFloat(i) + 1) / 2.0) * CGFloat(md)
                curr = CGPoint(x: CGFloat(last.x) + (scalestep * CGFloat(xstep[i % 4])), y: CGFloat(last.y) + (scalestep * CGFloat(ystep[i % 4]))).toInt()
                
                if i + 1 == turns {
                    curr = CGPoint(x: CGFloat(curr.x) - (md * CGFloat(xstep[i % 4])), y: CGFloat(curr.y) - (md * CGFloat(ystep[i % 4]))).toInt()
                }
                
                path.addLineToPoint(curr)
                last  = curr
            }
            return path
        }
    }
    
    func setupAnimation() {
        if fgLayer == nil {
            
            fgLayer = shapeLayerWithLogoPath(UIColor(red: 1, green: 246/255, blue: 153/255, alpha: 1), lineJoin: kCALineJoinMiter)
            self.layer.addSublayer(fgLayer)
        }
        pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 3.0
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        pathAnimation.autoreverses = true
        pathAnimation.repeatCount = 5
    }
    
    public func show() {
        UIView.animateWithDuration(0.5, animations: {
            self.alpha = 1
            }, completion: { complete in
                self.startAnimation()
        })
    }
    public func hide() {
        UIView.animateWithDuration(0.5, animations: {
            self.alpha = 0
            }, completion: { complete in
                self.endAnimation()
        })
    }
    
    func startAnimation() {
        self.fgLayer?.removeAllAnimations()
        self.fgLayer?.addAnimation(pathAnimation, forKey: "strokeEnd")
    }
    
    func endAnimation() {
        self.fgLayer?.removeAllAnimations()
    }
    
    func shapeLayerWithLogoPath(strokeColor: UIColor, lineJoin: String) -> CAShapeLayer {
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = logoPath.CGPath
        shapeLayer.strokeColor = strokeColor.CGColor
        shapeLayer.fillColor = nil
        if lineWidth == nil {
            shapeLayer.lineWidth = self.strokeRatio
        } else {
            shapeLayer.lineWidth = self.lineWidth!
        }
        shapeLayer.lineJoin = lineJoin
        return shapeLayer
    }
    
    func addBackground() {
        if bgLayer == nil {
            bgLayer = shapeLayerWithLogoPath(UIColor(red: 51/255, green: 51/255, blue: 48/255, alpha: 1), lineJoin: kCALineJoinMiter)
            self.layer.addSublayer(bgLayer)
        }
    }
    
    override public func needsUpdateConstraints() -> Bool {
        return true
    }
    
}