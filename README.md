# HorizontalWheelPicker

A customizable, lightweight horizontal scrollable picker for SwiftUI that mimics the feel of a physical ruler or wheel. Perfect for weight, height, or any numerical input.

<div align="center">
  <video src="https://github.com/Taimoor20/WheelPickerGif/blob/main/Gif_file.gif" width="300" />
</div> 

## Features
- ✅ **Smooth Snapping**: Automatically snaps to the nearest value.
- ✅ **Haptic Feedback**: Vibrates and "ticks" as you scroll.
- ✅ **Fully Customizable**: Change colors, fonts, and sizes via modifiers.
- ✅ **Lightweight**: Built with SwiftUI and `UIViewRepresentable` for performance.

---

## Requirements

- iOS 15.0+
- Swift 5.0+
- Xcode 13+

## Installation

### Swift Package Manager (SPM)
1. In Xcode, go to **File** -> **Add Packages...**
2. Paste the repository URL: `https://github.com/Taimoor20/HorizontalWheelPicker`
3. Select **Up to Next Major Version** and set it to `1.0.0`.
4. Click **Add Package**.

---

## Quick Start

```swift
import SwiftUI
import WheelPicker // If you named your library WheelPicker

struct ContentView: View {
    @State private var selectedValue: Int = 0

    var body: some View {
        VStack {
            Text("Selected Value: \(selectedValue)")
                .font(.largeTitle)
            
            WheelPicker(returnValue: $selectedValue, startPoint: 0, endPoint: 100)
        }
    }
}
```

## Customization (Modifiers)

You can customize the appearance of the picker using the built-in modifiers:

```swift
WheelPicker(returnValue: $selectedValue, startPoint: 0, endPoint: 100)
    .majorTickColor(.black)     // Color of the long ticks (at 5, 10, etc.)
    .minorTickColor(.black)     // Color of the short intermediate ticks
    .indicatorColor(.blue)      // Color of the center selection needle
    .textColor(.black)          // Color of the numerical labels
    .textFont(.system(size: 11, weight: .light)) // The font used for the labels
```
