//
//  RangeRadiusProperties.swift
//  TrackUserPosition
//
//  Created by Carlos Correia on 22/03/2018.
//  Copyright © 2018 Carlos Correia. All rights reserved.
//

import UIKit

public let DEFAULT_ALPHA : CGFloat = 0.3
public let DEFAULT_BORDER : CGFloat = 50
public let DEFAULT_COLOR : UIColor = .red

public class RangeRadiusProperties {
    internal let fillColor : UIColor
    internal let alpha, border: CGFloat
    internal let borderColor : UIColor

    public init(fillColor: UIColor, alpha: CGFloat = DEFAULT_ALPHA, border: CGFloat = DEFAULT_BORDER, borderColor: UIColor? = nil) {
        self.fillColor = fillColor
        self.alpha = alpha
        self.border = border
        self.borderColor = borderColor ?? fillColor
    }
}
