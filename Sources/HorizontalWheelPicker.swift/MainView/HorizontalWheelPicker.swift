// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import UIKit

/// A horizontal wheel picker built using UIScrollView for precise snapping.
/// - Each small tick = +1 unit (20pt)
/// - Each major tick = +5 units
/// - Uses offset tracking to compute selected value
@available(iOS 17.0, *)
public struct HorizontalWheelPicker: View {
    
    /// Current scroll offset from UIScrollView
    @State private var offset: CGFloat = 0
    
    /// Selected value exposed to parent
    @Binding var returnValue: Int
    
    /// Range configuration
    private let startPoint: Int
    private let endPoint: Int
    
    /// Styling configuration
    public var style = WheelPickerStyle()
    
    init(returnValue: Binding<Int>, startPoint: Int, endPoint: Int) {
        self._returnValue = returnValue
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    public var body: some View {
        
        /// GeometryReader replaces UIScreen.main (iOS 26 safe)
        GeometryReader { geo in
            
            VStack {
                
                /// Number of major ticks (+5 each)
                let pickerCount = (endPoint - startPoint) / 5
                
                CustomSlider(
                    offSet: $offset,
                    pickerCount: pickerCount,
                    containerWidth: geo.size.width
                ) {
                    
                    /// Ruler UI
                    HStack(spacing: 0) {
                        
                        ForEach(1...pickerCount, id: \.self) { index in
                            
                            VStack {
                                
                                /// Major tick
                                Rectangle()
                                    .fill(style.majorTickColor)
                                    .frame(width: style.majorTickFrame.width, height: style.majorTickFrame.height)
                                
                                /// Label (every 5 units)
                                let value = (startPoint - 5) + (index * 5)
                                
                                Text("\(value)")
                                    .font(style.textFont)
                                    .foregroundStyle(style.textColor)
                            }
                            .frame(width: style.spacing)
                            
                            /// 4 minor ticks between major ticks
                            ForEach(1...4, id: \.self) { _ in
                                Rectangle()
                                    .fill(style.minorTickColor)
                                    .frame(width: style.minorTickFrame.width, height: style.minorTickFrame.height)
                                    .frame(width: style.spacing)
                            }
                        }
                        
                        /// Final tick
                        VStack(spacing: 10) {
                            Rectangle()
                                .fill(style.majorTickColor)
                                .frame(width: style.majorTickFrame.width, height: style.majorTickFrame.height)
                            
                            Text("\(endPoint)")
                                .font(style.textFont)
                                .foregroundStyle(style.textColor)
                        }
                        .frame(width: style.spacing)
                    }
                    
                    /// Center alignment (important for picker feel)
                    .offset(x: (geo.size.width - 30) / 2)
                    .padding(.trailing, geo.size.width - 60)
                }
                .frame(height: 50)
                
                /// Center indicator
                .overlay {
                    Rectangle()
                        .fill(style.indicatorColor)
                        .frame(width: style.indicatorFrame.width, height: style.indicatorFrame.height)
                        .offset(x: 0.4, y: -9)
                        .padding(.bottom)
                }
            }
        }
        .frame(height: style.pickerHeight) // ✅ constraint GeometryReader
        /// Update value when offset changes
        .onChange(of: offset) {
            updateValue()
        }
    }
    
    /// Converts scroll offset → actual value
    /// - 20pt = 1 unit
    private func updateValue() {
        let progress = offset / 20
        let value = startPoint + Int(progress)
        returnValue = value
    }
}
