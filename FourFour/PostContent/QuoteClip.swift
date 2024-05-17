//
//  QuoteClip.swift
//  FourFour
//
//  Created by Charles Thomas on 2024/5/16.
//
import SwiftUI
struct CustomClipShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(CGRect(x: rect.origin.x + 10, y: rect.origin.y + 10, width: rect.size.width - 20, height: rect.size.height - 30))
        return path
    }
}
