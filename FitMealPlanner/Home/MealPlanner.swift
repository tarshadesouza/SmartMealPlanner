//
//  MealPlanner.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 11/12/2023.
//

import SwiftUI

public enum IngredientCategory: String {
	case Fruit = "Fruit 🍎"
	case Vegetables = "Veggies 🥑"
	case Cereals = "Cereals 🥖"
	case Proteins = "Proteins 🥩"
}

struct Ingredient: Hashable {
	let id = UUID()
	let category: IngredientCategory
	let name: String
}

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
	let ingredients: [IngredientCategory] = [.Fruit, .Vegetables, .Cereals, .Proteins]
	@State private var selectedIngredient: IngredientCategory? = nil

	var body: some View {
		VStack(alignment: .leading) {
			TextField("Name of meal plan", text: $mealPlanName)
				.padding()
				.addBorder()
				.padding()
			
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
			.addBorder()
			.padding()
			// caloric instake
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
			.addBorder()
			.padding()
			
			// ingredients

			RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
				.fill(.white)
				.overlay(
					VStack(alignment: .leading, spacing: 10) {
						Text("Choose your ingredients")
							.padding(.top, 10)
							.padding(.horizontal)
						ScrollView(.horizontal, showsIndicators: false) {
							HStack(spacing: 20) {
								ForEach(ingredients, id: \.self) {
									Text("\($0.self.rawValue)")
										.foregroundStyle(.white)
										.font(.title3)
										.frame(width: 110, height: 100)
										.background(Color.pastelSkyBlue)
										.cornerRadius(10)
								}
							}
							.padding()
						}
						
					}
					.frame(maxHeight: .infinity, alignment: .topLeading)
				)
				.frame(height: 200)
				.addBorder()
				.padding()
		
			Spacer()
			RoundedPrimaryButton(title: "Create Meal Plan") {
					  // Button action
					  print("Button tapped!")
			}
			.padding(.bottom, 10)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
//		.fullScreenCover(item: $selectedIngredient, content: <#T##(Identifiable) -> View#>)
	}
}

#Preview {
    MealPlanner()
}

extension View {
	func addBorder() -> some View {
		self.overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.pastelMint, style: StrokeStyle(lineWidth: 1.0)))
	}
}
// need firstly a list of foods to include
// veggie colum
// cereeals
// proteins
//
// need a list to disclude (allergens or disclude)
// amount of days needed.. (pay models can depends on this)
// amount of calories daily

//feature
// shopping list creation..

import SwiftUI

struct RoundedPrimaryButton: View {
	var title: String
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			Text(title)
				.font(.headline)
				.foregroundColor(.textLight)
				.padding()
				.frame(minWidth: 0, maxWidth: .infinity)
				.background(Color.pastelMint)
				.cornerRadius(10)
				.padding(.horizontal)
		}
	}
}
