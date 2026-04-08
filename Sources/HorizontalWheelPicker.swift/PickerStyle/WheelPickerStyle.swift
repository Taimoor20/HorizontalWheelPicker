//
//  File.swift
//  HorizontalWheelPicker
//
//  Created by Taimoor Arif on 07/04/2026.
//

import SwiftUI

public struct WheelPickerStyle {
    
    public var majorTickColor: Color = .white
    public var minorTickColor: Color = .white.opacity(0.7)
    public var indicatorColor: Color = .blue
    public var textColor: Color = .white
    public var textFont: Font = .system(size: 11, weight: .light)
    public var majorTickFrame: CGSize = CGSize(width: 1, height: 30)
    public var minorTickFrame: CGSize = CGSize(width: 1, height: 15)
    public var indicatorFrame: CGSize = CGSize(width: 3, height: 50)
    public var spacing: CGFloat = 20
    public var pickerHeight: CGFloat = 70
    
    public init() {}
}
