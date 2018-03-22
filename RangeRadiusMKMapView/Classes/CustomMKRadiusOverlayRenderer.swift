//
//  CustomMKRadiusOverlay.swift
//  TrackUserPosition
//
//  Created by Carlos Correia on 21/03/2018.
//  Copyright © 2018 Carlos Correia. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public protocol MKRadiusDelegate {
    func onRadiusChange(_ radius: Double)
}

public let DEFAULT_RADIUS : Double = 100
public let MINDISTANCE : Double = 50
public let MAXDISTANCE : Double = 2000


public class CustomMKRadiusOverlayRenderer : MKCircleRenderer {
    public var delegate : MKRadiusDelegate?
    public var circlebounds : MKMapRect?
    public var MINDIS : Double!
    public var MAXDIS : Double!
    public var border: CGFloat!
    public var borderColor: UIColor?

    private var mapRadius : Double?

    convenience init(circle: MKCircle, withRadius radius: Double, withMin min: Double, withMax max: Double) {
        self.init(circle: circle)

        if(max > min && min > 0){
            self.MINDIS = min
            self.MAXDIS = max
        }else if(min > 0){
            print("Max distance smaller than Min")
            self.MINDIS = min
            self.MAXDIS = min
        }else{
            print("Trying to set a negative radius--Using Default")
            self.MINDIS = MINDISTANCE
            self.MAXDIS = MAXDISTANCE
        }
        if(radius > 0){
            self.mapRadius = radius;
        }
        self.commonInit()
    }

    convenience init(circle: MKCircle, withRadius radius: Double) {
        self.init(circle: circle)
        self.MINDIS = MINDISTANCE
        self.MAXDIS = MAXDISTANCE
        if radius > 0 {
            self.mapRadius = radius
        }
        self.commonInit()
    }

    override init(circle: MKCircle) {
        super.init(circle: circle)
        self.MINDIS = MINDISTANCE
        self.MAXDIS = MAXDISTANCE
        self.commonInit()
    }

    private func commonInit() {
        self.alpha = DEFAULT_ALPHA
        self.border = DEFAULT_BORDER
    }

    internal func setProperties(_ properties: RangeRadiusProperties) {

        self.alpha = properties.alpha
        self.border = properties.border
        self.borderColor = properties.borderColor

        self.invalidatePath()
    }

    internal func setCircleRadius(_ radius: Double, minRadius: Double? = nil, maxRadius: Double? = nil) {

        if let minRadius = minRadius {
            self.MINDIS = minRadius
        }

        if let maxRadius = maxRadius {
            self.MAXDIS = maxRadius
        }


        if(radius > maxRadius ?? self.MAXDIS){
            mapRadius = MAXDIS
        }else if(radius < minRadius ?? MINDIS){
            mapRadius = MINDIS
        }else{
            mapRadius = radius
        }
        self.invalidatePath()
    }

    internal func getCircleRadius() -> Double {
        return self.mapRadius ?? 1
    }

    override public func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {

        let mpoint = MKMapPointForCoordinate(self.overlay.coordinate)
        let radiusAtLatitude = (mapRadius ?? 1)*MKMapPointsPerMeterAtLatitude(self.overlay.coordinate.latitude)

        let _circleBounds = MKMapRectMake(mpoint.x, mpoint.y, radiusAtLatitude * 2, radiusAtLatitude * 2)
        self.circlebounds = _circleBounds

        let overlayRect = self.rect(for: _circleBounds)

        if let fillColor = self.fillColor {
            context.setStrokeColor(self.borderColor?.cgColor ?? fillColor.cgColor)
            context.setFillColor(fillColor.withAlphaComponent(alpha).cgColor)
        }

        context.setLineWidth(border)
        context.setShouldAntialias(true)

        context.addArc(center: CGPoint(x:overlayRect.origin.x, y: overlayRect.origin.y), radius: CGFloat(radiusAtLatitude), startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        context.drawPath(using: .fillStroke)

        if let radius = self.mapRadius, let delegate = delegate {
            DispatchQueue.main.async {
                delegate.onRadiusChange(radius)
            }
        }

        UIGraphicsPopContext()
    }
}
