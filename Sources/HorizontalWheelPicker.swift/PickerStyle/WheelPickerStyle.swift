//
//  File.swift
//  HorizontalWheelPicker
//
//  Created by Taimoor Arif on 07/04/2026.
//

import SwiftUI

/// A configuration object to customize the visual appearance of the WheelPicker.
public struct WheelPickerStyle {
    /// Color for the primary/long ticks (multiples of 5).
    public var majorTickColor: Color = .black
    /// Color for the secondary/short ticks.
    public var minorTickColor: Color = .black
    /// Color for the static center selection needle.
    public var indicatorColor: Color = .accentColor
    /// Color for the numerical labels.
    public var textColor: Color = .black
    /// Font style for the numerical labels.
    public var textFont: Font = .system(size: 11, weight: .light)
    
    public init() {}
}
