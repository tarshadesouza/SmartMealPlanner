//
//  MealPlanner.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 11/12/2023.
//

import SwiftUI
import SwiftData

struct CaloricIntakeRange: Hashable {
	let name: String
	let range: ClosedRange<Int>

	// Example: Low, Medium, High
	static let low = CaloricIntakeRange(name: "Low", range: 1200...1500)
	static let medium = CaloricIntakeRange(name: "Medium", range: 1501...2000)
	static let high = CaloricIntakeRange(name: "High", range: 2001...2500)

	static let allRanges = [low, medium, high] // Use this array to iterate or display options
}

struct MealPlanner: View {
	@State private var mealPlanName: String = ""
	@State private var numberOfDays: Int = 0
	@State private var caloricIntakeRange: CaloricIntakeRange = CaloricIntakeRange.low
	let ingredientCategories: [IngredientCategory] = [.Fruit, .Vegetables, .Cereals, .Proteins]
	
	@State private var selectedCategory: IngredientCategory? = nil
	@State private var showIngredientSheet = false

	private var mealPlanField: some View {
		TextField("Name of meal plan", text: $mealPlanName)
			.padding()
			.frame(height: 60)
			.NeumorphicStyle()
			.padding()
	}
	
	private var numberOfDaysFields: some View {
		HStack {
			Text("Number of days")
				.padding()
			Spacer()
			Picker("Number of days", selection: $numberOfDays) {
				ForEach(1...24, id: \.self) {
					Text("\($0) days")
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.frame(height: 60)
		.NeumorphicStyle()
		.padding()
	}

	private var caloricIntakeField: some View {
		HStack {
			Text("Caloric Intake")
				.padding()
			Spacer()
			Picker("Caloric Intake", selection: $caloricIntakeRange) {
				ForEach(CaloricIntakeRange.allRanges, id: \.self) { caloricRange in
					Text("\(caloricRange.range.lowerBound) to \(caloricRange.range.upperBound)")
						.padding()
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.frame(height: 60)
		.NeumorphicStyle()
		.padding()
	}

	private var ingredientsField: some View {
		RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
			.fill(.white)
			.overlay(
				VStack(alignment: .leading, spacing: 10) {
					Text("Choose your ingredients")
						.padding(.top, 10)
						.padding(.horizontal)
					let _ = selectedCategory?.rawValue
//						A fix for the sheet bug. Hacky but still relevant https://developer.apple.com/forums/thread/652080?page=2
					ScrollView(.horizontal, showsIndicators: false) {
						HStack(spacing: 20) {
							ForEach(ingredientCategories, id: \.self) { category in
								Button {
									Task {
										selectedCategory = category
										showIngredientSheet.toggle()
									}
								} label: {
									Text("\(category.rawValue)")
										.foregroundStyle(Color.backgroundDark)
										.font(.title3)
										.frame(width: 110, height: 120)
										.background(Color.pastelLavender.opacity(0.3))
										.cornerRadius(10)
								}
								.NeumorphicStyle()
							}
						}
						.padding()
					}
				}
				.frame(maxHeight: .infinity, alignment: .topLeading)
			)
			.frame(height: 200)
			.NeumorphicStyle()
			.padding()
	}

	private var createMealPlanButton: some View {
		NeumorphicAsyncButton(
			action: { completion in
				// Your asynchronous operation goes here
				Task {
					do {
						let result = try await someAsyncOperation()
					} catch {
						print("Error: \(error)")
					}
					// Call the completion closure when the operation is finished
					completion()
				}
			},
			text: "Create Meal Plan",
			icon: "🍽️"
		)
		.frame(maxWidth: .infinity)
	}
	
	var body: some View {
		NavigationView {
			VStack(alignment: .leading, spacing: 0) {
				mealPlanField
				numberOfDaysFields
				caloricIntakeField
				ingredientsField
				Spacer()
				createMealPlanButton
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.sheet(isPresented: $showIngredientSheet, content: {
				IngredientList(category: $selectedCategory)
			})
			.toolbar() {
				Button(
					action: {
						print("go to plans.")
					},
					label: {
						Text("My meal plans 🥦")
							.frame(minWidth: 80)
					}
				)
				.buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 20)))
			}
			
		}
	}

	private func someAsyncOperation() async throws -> String {
		// Simulate an asynchronous operation
		try await Task.sleep(nanoseconds: 3 * 1_000_000_000)  // Three seconds
		return "done"
	}
}

#Preview {
    MealPlanner()
}

//feature
// shopping list creation..
