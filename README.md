# HorizontalWheelPicker

A customizable horizontal wheel picker built with SwiftUI + UIKit snapping.

## Features
- Smooth snapping
- Haptic feedback
- Dynamic width support
- Lightweight

## Installation

### Swift Package Manager

In Xcode:

File → Add Packages → Enter:

https://github.com/your-username/HorizontalWheelPicker

## Usage

```swift
@State private var value = 40

HorizontalWheelPicker(
    returnValue: $value,
    startPoint: 30,
    endPoint: 150
)
.frame(height: 80)
