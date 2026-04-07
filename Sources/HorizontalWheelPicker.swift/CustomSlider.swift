//
//  SwiftUIView.swift
//  RulerWheelPicker
//
//  Created by Taimoor Arif on 03/04/2026.
//

import SwiftUI
import UIKit
import AudioToolbox

/// A UIKit-backed horizontal scroll container with snapping behavior.
/// Wraps SwiftUI content inside UIScrollView.
struct CustomSlider<Content: View>: UIViewRepresentable {
    
    /// SwiftUI content rendered inside UIScrollView
    private let content: Content
    
    /// Number of major ticks
    private let pickerCount: Int
    
    /// Visible width (injected from GeometryReader)
    private let visibleWidth: CGFloat
    
    /// Binding to propagate scroll offset back to SwiftUI
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
        
        /// Hide default indicator
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = context.coordinator
        
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
        
        /// Total content width:
        /// (major ticks + subticks) * spacing + trailing padding
        let contentWidth = CGFloat(pickerCount * 5) * 20 + (visibleWidth - 30)
        
        hostedView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: 50)
        scrollView.contentSize = hostedView.frame.size
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        private let parent: CustomSlider
        
        init(parent: CustomSlider) {
            self.parent = parent
        }
        
        /// Continuously updates offset while scrolling
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offSet = scrollView.contentOffset.x
        }
        
        /// Snaps scroll position to nearest tick (20pt spacing)
        private func snap(_ scrollView: UIScrollView) {
            
            let step: CGFloat = 20
            
            /// Round to nearest tick
            let value = round(scrollView.contentOffset.x / step)
            let newOffset = value * step
            
            scrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
            
            /// Haptic + tick sound feedback
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(1157)
        }
        
        /// Called when scrolling naturally stops
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            snap(scrollView)
        }
        
        /// Called when user lifts finger
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            
            /// If no deceleration, manually snap
            if !decelerate {
                snap(scrollView)
            }
        }
    }
}
