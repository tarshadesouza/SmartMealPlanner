//
//  SequentialAnimationModifier.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 24/12/2023.
//

import Foundation
import SwiftUI

struct SequentialFadeInModifier: ViewModifier {
	@State private var fadeIn = false
	let index: Int

	func body(content: Content) -> some View {
		content
			.opacity(fadeIn ? 1 : 0)
			.onAppear {
				withAnimation(.easeInOut(duration: 0.3).delay(Double(index) * 0.2)) {
					fadeIn.toggle()
				}
			}
	}
}

extension View {
	func sequentialFadeIn(index: Int) -> some View {
		self.modifier(SequentialFadeInModifier(index: index))
	}
}
