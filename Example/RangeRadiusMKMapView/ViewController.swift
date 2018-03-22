//
//  ViewController.swift
//  RangeRadiusMKMapView
//
//  Created by carlosmouracorreia on 03/22/2018.
//  Copyright (c) 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import RangeRadiusMKMapView
import MapKit
import CoreLocation

public var DEFAULT_COORDINATE = CLLocationCoordinate2D(latitude: 38.725410, longitude: -9.149904)

class ViewController: UIViewController {

    var mapView : RangeRadiusMKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView = RangeRadiusMKMapView(frame: .zero, delegate: self)
        self.mapView.delegate = self
        self.view.addSubview(mapView)

        self.mapView.setRadiusWithRange(centerCoordinate: DEFAULT_COORDINATE, startRadius: 200, minRadius: 100, maxRadius: 4000)
        self.mapView.rangeIsActive = true

        let coordRegion = MKCoordinateRegionMakeWithDistance(DEFAULT_COORDINATE, 1000, 1000)
        self.mapView.setRegion(coordRegion, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.mapView != nil {
            self.mapView.frame = self.view.bounds
        }
    }

    internal func setRangeTitle(_ range: Double) {

        var distance = String()
        if range > 1000 {
            distance = String(format: "%.02f km", range / 1000)
        } else {
            distance = String(format: "%.f m", range)
        }

        self.title = "Range radius: \(distance)"
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let properties = RangeRadiusProperties(fillColor: UIColor.red, alpha: 0.5, border: 50, borderColor: UIColor.black)
        return self.mapView.getRenderer(from: overlay, properties: properties)
    }
}

extension ViewController : MKRadiusDelegate {
    func onRadiusChange(_ radius: Double) {
        self.setRangeTitle(radius)
    }
}
