// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import UIKit

/// A horizontal scrollable picker that mimics a physical wheel/ruler.
///
/// Use this component to let users select integer values within a range.
@available(iOS 15.0, *)
public struct HorizontalWheelPicker: View {
    
    @State private var offset: CGFloat = 0
    public var style = WheelPickerStyle()
    
    /// The binding value that updates as the user scrolls.
    @Binding var returnValue: Int
    
    private var startPoint: Int
    private var endPoint: Int
    private var addHapticFeedback: Bool = true
    
    /// Initializes a new WheelPicker.
    /// - Parameters:
    ///   - returnValue: Binding to the selected integer value.
    ///   - startPoint: The minimum value of the picker.
    ///   - endPoint: The maximum value of the picker.
    ///   - hapticFeedback: Little vibration at the end.
    public init(returnValue: Binding<Int>,
                startPoint: Int,
                endPoint: Int,
                addHapticFeedback: Bool = true) {
        
        self._returnValue = returnValue
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.addHapticFeedback = addHapticFeedback
    }
    
    public var body: some View {
        
        VStack {
            // Logic: 1 major tick group represents 5 units
            let pickerCount = (endPoint - startPoint) / 5
            
            CustomSlider(offSet: $offset, pickerCount: pickerCount, addHapticFeedback: addHapticFeedback) {
                
                HStack(spacing: 0) {
                    
                    ForEach(1...pickerCount, id: \.self) { index in
                        
                        VStack {
                            
                            Rectangle()
                                .fill(style.majorTickColor)
                                .frame(width: 2, height: 30)
                            
                            let value = (startPoint - 5) + (index * 5)
                            
                            Text("\(value)")
                                .font(style.textFont)
                                .foregroundStyle(style.textColor)
                        }
                        .frame(width: 20) // spacing unit
                        
                        // Sub-ticks between major ticks
                        ForEach(1...4, id: \.self) { _ in
                            
                            Rectangle()
                                .fill(style.minorTickColor)
                                .frame(width: 1, height: 15)
                                .frame(width: 20)
                        }
                    }
                    
                    // Final tick (endpoint)
                    VStack(spacing: 10) {
                        
                        Rectangle()
                            .fill(style.majorTickColor)
                            .frame(width: 2, height: 30)
                        
                        Text("\(endPoint)")
                            .font(style.textFont)
                            .foregroundStyle(style.textColor)
                    }
                    .frame(width: 20)
                }
                // Center the first tick on the indicator
                .offset(x: (getScreenWidth()) / 2)
                .padding(.trailing, getScreenWidth())
            }
            .frame(height: 50)
            .overlay(content: {
                // Static center indicator
                Rectangle()
                    .fill(style.indicatorColor)
                    .frame(width: 3, height: 50)
                    .offset(y: -9)
                    .padding(.bottom)
            })
        }
        .onChange(of: offset) { _ in
            getFinalValue()
        }
    }
    
    /// Calculates the current integer value based on scroll offset.
    private func getFinalValue() {
        let progress = offset / 20
        let totalWeight = startPoint + Int(round(progress))
        self.returnValue = totalWeight
    }
}
