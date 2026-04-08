//
//  SwiftUIView.swift
//  RulerWheelPicker
//
//  Created by Taimoor Arif on 03/04/2026.
//

import SwiftUI
import UIKit

/// UIKit-backed horizontal scroll container
/// Responsible for:
/// - Hosting SwiftUI content
/// - Tracking scroll offset
/// - Snapping to nearest tick
/// - Providing native-like wheel feedback
struct CustomSlider<Content: View>: UIViewRepresentable {
    
    private let content: Content
    private let pickerCount: Int
    private let containerWidth: CGFloat
    
    /// Binding to propagate scroll offset
    @Binding private var offSet: CGFloat
    
    init(
        offSet: Binding<CGFloat>,
        pickerCount: Int,
        containerWidth: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content()
        self._offSet = offSet
        self.pickerCount = pickerCount
        self.containerWidth = containerWidth
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let scrollView = UIScrollView()
        
        /// Embed SwiftUI view
        let hostedView = UIHostingController(rootView: content).view!
        
        /// Total width:
        /// (total ticks * spacing) + extra width for centering last item
        let width = CGFloat((pickerCount * 5) * 20) + (containerWidth - 30)
        
        hostedView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        hostedView.backgroundColor = .clear
        
        scrollView.contentSize = hostedView.frame.size
        scrollView.addSubview(hostedView)
        
        /// Disable bounce for picker feel
        scrollView.bounces = false
        
        /// Faster deceleration for native feel
        scrollView.decelerationRate = .fast
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        private let parent: CustomSlider
        
        /// Native wheel feedback generator
        private let feedbackGenerator = UISelectionFeedbackGenerator()
        
        /// Track last step to avoid duplicate triggers
        private var lastStep: CGFloat = .zero
        
        init(parent: CustomSlider) {
            self.parent = parent
            feedbackGenerator.prepare()
        }
        
        /// Track scrolling + trigger haptics
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            let offset = scrollView.contentOffset.x
            parent.offSet = offset
            
            let step: CGFloat = 20
            
            /// Current step index
            let currentStep = (offset / step).rounded()
            
            /// Trigger feedback only when step changes
            if currentStep != lastStep {
                lastStep = currentStep
                
                feedbackGenerator.selectionChanged()
                feedbackGenerator.prepare()
            }
        }
        
        /// Snap after deceleration
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            snap(scrollView)
        }
        
        /// Snap when dragging stops
        func scrollViewDidEndDragging(
            _ scrollView: UIScrollView,
            willDecelerate decelerate: Bool
        ) {
            if !decelerate {
                snap(scrollView)
            }
        }
        
        /// Snap to nearest tick (20pt)
        private func snap(_ scrollView: UIScrollView) {
            
            let step: CGFloat = 20
            
            let value = (scrollView.contentOffset.x / step)
                .rounded(.toNearestOrAwayFromZero)
            
            let targetOffset = value * step
            
            scrollView.setContentOffset(
                CGPoint(x: targetOffset, y: 0),
                animated: false
            )
        }
    }
}
