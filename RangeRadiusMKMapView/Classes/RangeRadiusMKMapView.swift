//
//  RangeRadiusMKMapView.swift
//  TrackUserPosition
//
//  Created by Carlos Correia on 21/03/2018.
//  Copyright © 2018 Carlos Correia. All rights reserved.
//

import Foundation
import MapKit

public class RangeRadiusMKMapView : MKMapView {

    internal var panEnabled = true
    internal var droppedAt : CLLocationCoordinate2D?
    internal var oldOffset : Double?
    internal var lastPoint : MKMapPoint?
    internal var radius : Double = DEFAULT_RADIUS
    internal var minRadius : Double = MINDISTANCE
    internal var maxRadius : Double = MAXDISTANCE
    public var rangeIsActive = true

    internal var renderer : CustomMKRadiusOverlayRenderer?
    internal var radiusDelegate: MKRadiusDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    internal func setRadius(_ radius: Double, _ minRadius: Double? = nil, _ maxRadius: Double? = nil) {
        self.radius = radius

        if let minRadius = minRadius {
            self.minRadius = minRadius
        }

        if let maxRadius = maxRadius {
            self.maxRadius = maxRadius
        }

        self.renderer?.setCircleRadius(radius, minRadius: minRadius, maxRadius: maxRadius)
    }

    internal func configureRangeRadiusOverlay() {

        let wildcardGestureRecognizer = WildGestureRecognizer()
        wildcardGestureRecognizer.touchesBeganCallback = { touches, event in

            if !self.rangeIsActive {
                return
            }

            let touch = touches.first
            guard let p = touch?.location(in: self) else {
                return
            }

            let coord = self.convert(p, toCoordinateFrom: self)
            let mapPoint = MKMapPointForCoordinate(coord)


            guard let circle = self.renderer else {
                return
            }

            let mapRect = circle.circlebounds!
            let xPath = mapPoint.x - (mapRect.origin.x - (mapRect.size.width/2))
            let yPath = mapPoint.y - (mapRect.origin.y - (mapRect.size.height/2))


            /* Test if the touch was within the bounds of the circle */
            if(xPath >= 0 && yPath >= 0 && xPath < mapRect.size.width && yPath < mapRect.size.height){
                //"Disable Map Panning"

                /*
                 This block is to ensure scrollEnabled = NO happens before the any move event.
                 */

                DispatchQueue.main.async {
                    self.isScrollEnabled = false
                    self.panEnabled = false
                    self.oldOffset = circle.getCircleRadius()
                }

            }else{
                self.isScrollEnabled = true
            }
            self.lastPoint = mapPoint

        }

        wildcardGestureRecognizer.touchesMovedCallback = { touches, event in

            if !self.rangeIsActive {
                return
            }

            if let touches = event.allTouches, !self.panEnabled && touches.count == 1 {
                guard let p = touches.first?.location(in: self) , let droppedAt = self.droppedAt, let lastPoint = self.lastPoint else {
                    return
                }

                let coord = self.convert(p, toCoordinateFrom: self)
                let mapPoint = MKMapPointForCoordinate(coord)

                let mRect = self.visibleMapRect
                guard let circle = self.renderer,let circleRect = circle.circlebounds else {
                    return
                }


                if circleRect.size.width > mRect.size.width * 0.55 {
                    var region = MKCoordinateRegion()
                    var span = MKCoordinateSpan()
                    region.center = droppedAt

                    span.latitudeDelta=self.region.span.latitudeDelta * 2.0
                    span.longitudeDelta=self.region.span.longitudeDelta * 2.0
                    region.span=span

                    self.setRegion(region, animated: true)
                }

                if circleRect.size.width < mRect.size.width * 0.25 {
                    var region = MKCoordinateRegion()
                    var span = MKCoordinateSpan()
                    region.center = droppedAt

                    span.latitudeDelta=self.region.span.latitudeDelta / 3.0002
                    span.longitudeDelta=self.region.span.longitudeDelta / 3.0002
                    region.span=span

                    self.setRegion(region, animated: true)
                }

                let meterDistance = (mapPoint.x - lastPoint.x)/MKMapPointsPerMeterAtLatitude(self.centerCoordinate.latitude)+Double(self.oldOffset ?? 0)
                if(meterDistance > 0){
                    circle.setCircleRadius(meterDistance)
                }

                let setRadius = circle.getCircleRadius()
                //self.setRangeTitle(setRadius)
                self.radiusDelegate?.onRadiusChange(setRadius)
            }
        }


        wildcardGestureRecognizer.touchesEndedCallback = { _,_ in
            self.isZoomEnabled = true
            self.isScrollEnabled = true
            self.isUserInteractionEnabled = true
            self.panEnabled = true
        }

        self.addGestureRecognizer(wildcardGestureRecognizer)
    }


    internal func setRenderer(from overlay: MKOverlay, properties: RangeRadiusProperties? = nil) {

        let _renderer = MKCircleRenderer(overlay: overlay)
        let renderer = CustomMKRadiusOverlayRenderer(circle: _renderer.circle)
        if let properties = properties {
            renderer.fillColor = properties.fillColor
            renderer.setProperties(properties)
        } else {
            renderer.fillColor = DEFAULT_COLOR
        }

        self.renderer = renderer
        renderer.delegate = self.radiusDelegate
        self.setRadius(self.radius, self.minRadius, self.maxRadius)
    }
}

extension RangeRadiusMKMapView : MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return self.getRenderer(from: overlay)
    }
}

extension RangeRadiusMKMapView {

    public convenience init(frame: CGRect, delegate: MKRadiusDelegate) {
        self.init(frame: frame)
        self.radiusDelegate = delegate
        self.configureRangeRadiusOverlay()
        self.delegate = self
    }

    public func getRenderer(from overlay: MKOverlay, properties: RangeRadiusProperties? = nil) -> CustomMKRadiusOverlayRenderer {
        self.setRenderer(from: overlay, properties: properties)
        return self.renderer!
    }

    public func setRadiusWithRange(centerCoordinate coord: CLLocationCoordinate2D, startRadius: Double, minRadius: Double? = nil, maxRadius: Double? = nil) {

        if self.overlays.count > 0 {
            self.remove(self.overlays[0])
        }

        self.add(MKCircle(center: coord, radius: maxRadius ?? MAXDISTANCE))
        self.droppedAt = coord
        self.setRadius(startRadius, minRadius, maxRadius)
    }
}
