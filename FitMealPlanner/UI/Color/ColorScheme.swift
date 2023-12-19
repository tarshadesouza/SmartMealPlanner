//
//  ColorScheme.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 18/12/2023.
//

import Foundation
import SwiftUI

extension Color {
	// Soft Pastel Colors
	static let pastelMint = Color(hex: 0xA5D6A7)
	static let pastelSkyBlue = Color(hex: 0x81D4FA)
	static let pastelRose = Color(hex: 0xF48FB1)
	static let pastelLavender = Color(hex: 0xCE93D8)
	
	// Text Colors
	static let textDark = Color(hex: 0x333333)
	static let textLight = Color(hex: 0xFFFFFF)
	
	// Background Colors
	static let backgroundLight = Color(hex: 0xF5F5F5)
	static let backgroundDark = Color(hex: 0x212121)
	
	// Accent Colors
	static let accentApricot = Color(hex: 0xFFD180)
	static let accentPeach = Color(hex: 0xFFCCBC)
}

extension Color {
	init(hex: Int, alpha: Double = 1.0) {
		self.init(
			.sRGB,
			red: Double((hex >> 16) & 0xFF) / 255.0,
			green: Double((hex >> 8) & 0xFF) / 255.0,
			blue: Double(hex & 0xFF) / 255.0,
			opacity: alpha
		)
	}
}
