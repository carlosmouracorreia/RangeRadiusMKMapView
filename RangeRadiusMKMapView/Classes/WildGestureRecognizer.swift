//
//  WildGestureRecognizer.swift
//  TrackUserPosition
//
//  Created by Carlos Correia on 21/03/2018.
//  Copyright © 2018 Carlos Correia. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

typealias TouchesEventBlock = (Set<UITouch>, UIEvent) -> Void

class WildGestureRecognizer : UIGestureRecognizer {
    var touchesBeganCallback: TouchesEventBlock?
    var touchesMovedCallback: TouchesEventBlock?
    var touchesEndedCallback: TouchesEventBlock?

    init() {
        super.init(target: nil, action: nil)
        self.cancelsTouchesInView = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touchesBeganCallback = self.touchesBeganCallback {
            touchesBeganCallback(touches, event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touchesEndedCallback = self.touchesEndedCallback {
            touchesEndedCallback(touches, event)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touchesMovedCallback = self.touchesMovedCallback {
            touchesMovedCallback(touches, event)
        }
    }

    override func reset() {

    }

    override func ignore(_ touch: UITouch, for event: UIEvent) {

    }

    override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
