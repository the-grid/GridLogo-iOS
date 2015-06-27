//
//  Logo.swift
//  The Grid iOS
//
//  Created by Nicholas Velloff on 6/10/15.
//  Copyright (c) 2015 Rituwall, Inc. All rights reserved.
//



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


public func getGridLogo(mystic: CGFloat) -> AnimatedGridLogo {
    return AnimatedGridLogo()
}