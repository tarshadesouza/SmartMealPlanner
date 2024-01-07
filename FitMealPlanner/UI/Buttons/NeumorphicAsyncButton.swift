//
//  NeumorphicAsyncButton.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 20/12/2023.
//

import Foundation
import SwiftUI

struct NeumorphicAsyncButton: View {
	var action: (@escaping () -> Void) async throws -> Void

	var text: String
	var icon: String
	
	@State private var isPerformingTask = false
	@State private var isCompleted = false

	@MainActor
	var body: some View {
		Button(
			action: {
				withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
					isPerformingTask = true
				}

				Task {
					do {
						try await action {
							// The task is completed
							withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
								isPerformingTask = false
								isCompleted = true
							}
							// Go back to the inactive state of the button
							DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
								withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
									isCompleted = false
								}
							}
						}
					} catch {
						print("Error in action: \(error)")
					}
				}
			},
			label: {
				buttonLabel
			}
		)
		.buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 20)))
		.disabled(isPerformingTask || isCompleted)
	}

	private var buttonLabel: some View {
		HStack(spacing: 20) {
			// Appear only on inactive state
			if !isPerformingTask && !isCompleted {
				Text(text.uppercased())
					.boldFont()
					.fontWeight(.semibold)
					.foregroundColor(.gray)
			}
			if isCompleted {
				Text("Success".uppercased())
					.boldFont()
					.fontWeight(.semibold)
					.foregroundColor(.pastelMint)
			}
			Text(isCompleted ? "🥗" : icon)
				.frame(width: 20)
			// Appear only on isPerforming state
			if isPerformingTask && !isCompleted {
				DotProgressView()
			}
		}
		.foregroundColor(isCompleted ? Color.pastelMint : Color.gray)
		.opacity(isPerformingTask ? 0.5 : 1)
		.padding(.horizontal, isCompleted && !isPerformingTask ? 0 : 15)
	}
}
