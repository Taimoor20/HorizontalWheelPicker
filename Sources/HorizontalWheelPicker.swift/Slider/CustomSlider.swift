//
//  SwiftUIView.swift
//  RulerWheelPicker
//
//  Created by Taimoor Arif on 03/04/2026.
//

import SwiftUI
import UIKit

/// UIKit-backed scroll container
/// Handles:
/// - Hosting SwiftUI content
/// - Scroll offset tracking
/// - Snapping to nearest tick
/// - Correct initial centering
struct CustomSlider<Content: View>: UIViewRepresentable {
    
    private let content: Content
    private let pickerCount: Int
    private let visibleWidth: CGFloat
    
    /// Binding to send adjusted offset back to SwiftUI
    @Binding private var offSet: CGFloat
    
    /// Cached inset (used for alignment + offset correction)
    private let inset: CGFloat
    
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
        
        /// Calculate inset so center indicator aligns with ticks
        self.inset = (visibleWidth - 30) / 2
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let scrollView = UIScrollView()
        
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        
        /// Apply horizontal inset to center content
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: inset,
            bottom: 0,
            right: inset
        )
        
        /// 🔥 Critical Fix:
        /// Start contentOffset at -inset so first value is centered
        scrollView.contentOffset = CGPoint(x: -inset, y: 0)
        
        /// Host SwiftUI content inside UIKit
        let hostedView = UIHostingController(rootView: content).view!
        hostedView.backgroundColor = .clear
        hostedView.tag = 999
        
        scrollView.addSubview(hostedView)
        
        return scrollView
    }
    
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        
        guard let hostedView = scrollView.viewWithTag(999) else { return }
        
        /// Total width:
        /// (major ticks + subticks) * spacing
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
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            /// Adjust offset so:
            /// 0 = startPoint centered
            parent.offSet = scrollView.contentOffset.x
        }
        
        /// Snap to nearest tick (20pt grid)
        private func snap(_ scrollView: UIScrollView) {
            
            let step: CGFloat = 20
            
            /// Adjusted offset for snapping
            
            let value = round(scrollView.contentOffset.x / step)
            
            /// Convert back to raw offset
            let newOffset = value * step
            
            scrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
            
            /// Light haptic feedback
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            snap(scrollView)
        }
        
        func scrollViewDidEndDragging(
            _ scrollView: UIScrollView,
            willDecelerate decelerate: Bool
        ) {
            if !decelerate {
                snap(scrollView)
            }
        }
    }
}
