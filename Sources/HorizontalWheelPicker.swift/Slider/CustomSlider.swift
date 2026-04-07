//
//  SwiftUIView.swift
//  RulerWheelPicker
//
//  Created by Taimoor Arif on 03/04/2026.
//

import SwiftUI
import UIKit

/// A UIKit-backed horizontal scroll container.
/// Responsible for:
/// - Hosting SwiftUI content
/// - Managing scroll offset
/// - Snapping to nearest tick
struct CustomSlider<Content: View>: UIViewRepresentable {
    
    /// SwiftUI content rendered inside UIScrollView
    private let content: Content
    
    /// Number of major ticks
    private let pickerCount: Int
    
    /// Visible width (provided by GeometryReader)
    private let visibleWidth: CGFloat
    
    /// Binding to propagate scroll offset to SwiftUI
    @Binding private var offSet: CGFloat
    
    init(
        offSet: Binding<CGFloat>,
        pickerCount: Int,
        visibleWidth: CGFloat,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self._offSet = offSet
        self.pickerCount = pickerCount
        self.visibleWidth = visibleWidth
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let scrollView = UIScrollView()
        
        /// Disable bounce for picker-like feel
        scrollView.bounces = false
        
        /// Hide default scroll indicator
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = context.coordinator
        
        /// Use contentInset to center first and last items
        /// This avoids fake offsets in SwiftUI
        let inset = (visibleWidth - 30) / 2
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: inset,
            bottom: 0,
            right: inset
        )
        
        /// Host SwiftUI content inside UIKit
        let hostedView = UIHostingController(rootView: content).view!
        hostedView.backgroundColor = .clear
        hostedView.tag = 999
        
        scrollView.addSubview(hostedView)
        
        return scrollView
    }
    
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        
        /// Retrieve hosted SwiftUI view
        guard let hostedView = scrollView.viewWithTag(999) else { return }
        
        /// Calculate total content width
        /// Each unit = 20pt
        /// Each major tick = 5 units
        let contentWidth = CGFloat(pickerCount * 5) * 20
        
        hostedView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: 50)
        scrollView.contentSize = hostedView.frame.size
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        private let parent: CustomSlider
        
        init(parent: CustomSlider) {
            self.parent = parent
        }
        
        /// Called continuously while scrolling
        /// Updates SwiftUI state
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offSet = scrollView.contentOffset.x
        }
        
        /// Snap to nearest tick (20pt grid)
        private func snap(_ scrollView: UIScrollView) {
            
            let step: CGFloat = 20
            
            /// Calculate nearest tick index
            let value = round(scrollView.contentOffset.x / step)
            let newOffset = value * step
            
            scrollView.setContentOffset(
                CGPoint(x: newOffset, y: 0),
                animated: false
            )
            
            /// Provide light haptic feedback
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        /// Called when deceleration ends
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            snap(scrollView)
        }
        
        /// Called when dragging ends
        func scrollViewDidEndDragging(
            _ scrollView: UIScrollView,
            willDecelerate decelerate: Bool
        ) {
            /// If no deceleration, snap manually
            if !decelerate {
                snap(scrollView)
            }
        }
    }
}
