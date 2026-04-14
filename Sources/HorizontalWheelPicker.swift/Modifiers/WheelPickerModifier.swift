//
//  File.swift
//  HorizontalWheelPicker
//
//  Created by Taimoor Arif on 07/04/2026.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
// MARK: - Modifiers
extension HorizontalWheelPicker {
    
    /// Sets the color of the major ticks.
    /// - Parameter color: The color to apply.
    public func majorTickColor(_ color: Color) -> Self {
        var copy = self
        copy.style.majorTickColor = color
        return copy
    }
    
    /// Sets the color of the minor ticks.
    /// - Parameter color: The color to apply.
    public func minorTickColor(_ color: Color) -> Self {
        var copy = self
        copy.style.minorTickColor = color
        return copy
    }
    
    /// Sets the color of the center indicator needle.
    /// - Parameter color: The color to apply.
    public func indicatorColor(_ color: Color) -> Self {
        var copy = self
        copy.style.indicatorColor = color
        return copy
    }
    
    /// Sets the text color for the picker labels.
    /// - Parameter color: The color to apply.
    public func textColor(_ color: Color) -> Self {
        var copy = self
        copy.style.textColor = color
        return copy
    }
    
    /// Sets the font for the picker labels.
    /// - Parameter font: The font to apply.
    public func textFont(_ font: Font) -> Self {
        var copy = self
        copy.style.textFont = font
        return copy
    }
}
