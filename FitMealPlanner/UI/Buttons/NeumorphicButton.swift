//
//  NeumorphicButton.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 20/12/2023.
//

import Foundation
import SwiftUI


struct NeumorphicButton<S: Shape>: ButtonStyle {
	var shape: S
	
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding(10)
			.background(Background(isPressed: configuration.isPressed, shape: shape))
	}
}

struct Background<S: Shape>: View {
	@Environment(\.colorScheme) var colorScheme
	var isPressed: Bool
	var shape: S
	
	var background: Color {
		colorScheme == .light ? Color.backgroundLight : Color.backgroundDark
	}

	var gradient: LinearGradient {
		colorScheme == .light ? LinearGradient(Color.black, Color.clear) : LinearGradient(Color.clear, Color.clear)
	}

	var body: some View {
		ZStack {
			if isPressed {
				shape
					.fill(background)
					.overlay(
						shape
							.stroke(Color.gray, lineWidth: 3)
							.blur(radius: colorScheme == .light ? 4 : 0)
							.offset(x: 2, y: 2)
							.mask(shape.fill(gradient)
					)
					.overlay(
						shape
							.stroke(Color.white, lineWidth: 3)
							.blur(radius: colorScheme == .light ? 4 : 0)
							.offset(x: -2, y: -2)
							.mask(shape.fill(gradient))
					)
					)
			} else {
				shape
					.fill(background)
					.shadow(color: colorScheme == .light ? Color.pastelLavender.opacity(0.2) : .clear, radius: 10, x: 10, y: 10)
					.shadow(color: colorScheme == .light ? background.opacity(0.7) : .clear, radius: 10, x: -5, y: -5)
			}
		}
	}
}

extension View {
	func NeumorphicStyle(using colorScheme: ColorScheme) -> some View {
			self.padding(0)
				.frame(maxWidth: .infinity)
				.background(colorScheme == .light ? Color.backgroundLight : Color.backgroundDark)
				.cornerRadius(20)
				.shadow(color: colorScheme == .light ? Color.pastelLavender.opacity(0.2) : .clear, radius: 10, x: 10, y: 10)
				.shadow(color: colorScheme == .light ? Color.backgroundLight : .clear, radius: 10, x: -5, y: -5)
	}
}
