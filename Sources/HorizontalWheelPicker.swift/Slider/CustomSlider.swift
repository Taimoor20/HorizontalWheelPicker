//
//  SwiftUIView.swift
//  RulerWheelPicker
//
//  Created by Taimoor Arif on 03/04/2026.
//

import SwiftUI
import UIKit

/// A wrapper for UIScrollView to handle precise horizontal scrolling and snapping.
struct CustomSlider<Content: View>: UIViewRepresentable {
    
    private var content: Content
    private var pickerCount: Int
    @Binding private var offSet: CGFloat
    
    init(offSet: Binding<CGFloat>,
         pickerCount: Int,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._offSet = offSet
        self.pickerCount = pickerCount
    }
    
    func makeCoordinator() -> Coordinator {
        return CustomSlider.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        let swiftUIView = UIHostingController(rootView: content).view!
        
        // Total width calculation: (Major Ticks + Subticks) * width per tick + screen padding
        let width = CGFloat((pickerCount * 5) * 20) + (getScreenWidth())
        
        swiftUIView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        swiftUIView.backgroundColor = .clear
        
        scrollView.contentSize = swiftUIView.frame.size
        scrollView.addSubview(swiftUIView)
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        private var parent: CustomSlider
        
        init(parent: CustomSlider) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offSet = scrollView.contentOffset.x
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            snapToTick(scrollView)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                snapToTick(scrollView)
            }
        }
        
        /// Helper to ensure the picker stops exactly on a tick.
        private func snapToTick(_ scrollView: UIScrollView) {
            let offSet = scrollView.contentOffset.x
            let value = (offSet / 20).rounded(.toNearestOrAwayFromZero)
            
            scrollView.setContentOffset(CGPoint(x: value * 20, y: 0), animated: true)
        }
    }
}

/// Helper to fetch screen width for alignment and calculations.
/// In a production SDK, consider using GeometryReader for better responsiveness to split-screen/iPad modes.
@MainActor func getScreenWidth() -> CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        return windowScene.screen.bounds.width
    }
    return 375 // Default fallback
}
