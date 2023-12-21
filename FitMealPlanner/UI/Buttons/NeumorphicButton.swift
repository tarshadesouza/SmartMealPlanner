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
	var isPressed: Bool
	var shape: S
	
	var body: some View {
		ZStack {
			if isPressed {
				shape
					.fill(Color.backgroundLight)
					.overlay(
						shape
							.stroke(Color.gray, lineWidth: 3)
							.blur(radius: 4)
							.offset(x: 2, y: 2)
							.mask(shape.fill(LinearGradient(Color.black, Color.clear)))
					)
					.overlay(
						shape
							.stroke(Color.white, lineWidth: 3)
							.blur(radius: 4)
							.offset(x: -2, y: -2)
							.mask(shape.fill(LinearGradient(Color.clear, Color.black)))
					)
			} else {
				shape
					.fill(Color.backgroundLight)
					.shadow(color: Color.pastelLavender.opacity(0.2), radius: 10, x: 10, y: 10)
					.shadow(color: Color.backgroundLight.opacity(0.7), radius: 10, x: -5, y: -5)
			}
		}
	}
}

extension View {
	func NeumorphicStyle() -> some View {
			self.padding(0)
				.frame(maxWidth: .infinity)
				.background(Color.backgroundLight)
				.cornerRadius(20)
				.shadow(color: Color.pastelLavender.opacity(0.2), radius: 10, x: 10, y: 10)
				.shadow(color: Color.backgroundLight, radius: 10, x: -5, y: -5)
		
	}
}
