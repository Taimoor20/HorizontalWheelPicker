//
//  File.swift
//  HorizontalWheelPicker
//
//  Created by Taimoor Arif on 07/04/2026.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
public extension HorizontalWheelPicker {
    
    /// Change color of major ticks
    func majorTickColor(_ color: Color) -> Self {
        var copy = self
        copy.style.majorTickColor = color
        return copy
    }
    
    /// Change color of minor ticks
    func minorTickColor(_ color: Color) -> Self {
        var copy = self
        copy.style.minorTickColor = color
        return copy
    }
    
    /// Change center indicator color
    func indicatorColor(_ color: Color) -> Self {
        var copy = self
        copy.style.indicatorColor = color
        return copy
    }
    
    /// Change label text color
    func textColor(_ color: Color) -> Self {
        var copy = self
        copy.style.textColor = color
        return copy
    }
    
    func majorTickFrame(width: Double, height: Double) -> Self {
        var copy = self
        copy.style.majorTickFrame = CGSize(width: width, height: height)
        return copy
    }
    
    func minorTickFrame(width: Double, height: Double) -> Self {
        var copy = self
        copy.style.minorTickFrame = CGSize(width: width, height: height)
        return copy
    }
    
    func spacing(_ value: CGFloat) -> Self {
        var copy = self
        copy.style.spacing = value
        return copy
    }
}
