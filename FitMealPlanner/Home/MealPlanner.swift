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
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.modelContext) private var modelContext
	@State private var mealPlanName: String = ""
	@State private var numberOfDays: Int = 0
	@State private var caloricIntakeRange: CaloricIntakeRange = CaloricIntakeRange.low
	let ingredientCategories: [IngredientCategory] = [.Fruit, .Vegetables, .Cereals, .Proteins]
	
	@State private var selectedCategory: IngredientCategory? = nil
	@State private var showIngredientSheet = false
	@State var isShowingMealPlans = false
	@State private var ingredients: [IngredientCategory: [Ingredient]] = [:]
	
	private var allSelectedIngredients: [Ingredient] {
		let filteredSelectedIngredients = ingredients.mapValues { ingredients in
			ingredients.filter { $0.isSelected }
		}
		let allSelectedIngredients: [Ingredient] = Array(filteredSelectedIngredients.values.flatMap { $0 })
		return allSelectedIngredients
	}

	private var backgroundColor: Color {
		colorScheme == .light ? Color.backgroundLight : Color.backgroundDark
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
				IngredientList(category: $selectedCategory, ingredients: $ingredients)
			})
			.fullScreenCover(isPresented: $isShowingMealPlans, content: {
				MyMealPlans()
			})
			.toolbar() {
				Button(
					action: {
						isShowingMealPlans.toggle()
					},
					label: {
						Text("My meal plans 🥦")
							.regularFont()
							.frame(minWidth: 80)
					}
				)
				.buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 20)))
			}
			.onFirstAppear {
				// Initial sample ingredients data.
				ingredientCategories.forEach { category in
					ingredients[category] = category.sampleIngredients
					print("- Category: \(category.rawValue)")
					print("- ingredients: \(ingredients[category])")
				}
			}
		}
	}
	
	private var mealPlanField: some View {
		TextField("Name of meal plan", text: $mealPlanName)
			.regularFont()
			.padding()
			.frame(height: 60)
			.NeumorphicStyle(using: colorScheme)
			.padding()
	}
	
	private var numberOfDaysFields: some View {
		HStack {
			Text("Number of days")
				.padding()
				.regularFont()
			Spacer()
			Picker("Number of days", selection: $numberOfDays) {
				ForEach(1...24, id: \.self) {
					Text("\($0) days")
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.frame(height: 60)
		.NeumorphicStyle(using: colorScheme)
		.padding()
	}
	
	private var caloricIntakeField: some View {
		HStack {
			Text("Caloric Intake")
				.regularFont()
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
		.NeumorphicStyle(using: colorScheme)
		.padding()
	}
	
	private var ingredientsField: some View {
		RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
			.fill(backgroundColor)
			.overlay(
				VStack(alignment: .leading, spacing: 10) {
					Text("Choose your ingredients")
						.regularFont()
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.horizontal)
						.padding(.top, 10)
					let _ = selectedCategory?.rawValue
					//						A fix for the sheet bug. Hacky but still relevant https://developer.apple.com/forums/thread/652080?page=2
					ScrollView(.horizontal, showsIndicators: false) {
						HStack(spacing: 20) {
							ForEach(ingredientCategories, id: \.self) { category in
								ingredientButton(category)
							}
						}
						.padding()
					}
				}
				.frame(maxHeight: .infinity, alignment: .topLeading)
			)
			.frame(height: 200)
			.NeumorphicStyle(using: colorScheme)
			.padding()
	}
	
	private func ingredientButton(_ category: IngredientCategory) -> some View {
		ZStack(alignment: .topTrailing) {
			Button {
				Task {
					selectedCategory = category
					showIngredientSheet.toggle()
				}
			} label: {
				Text("\(category.rawValue)")
					.foregroundStyle(Color.backgroundDark)
					.regularFont()
					.frame(width: 110, height: 120)
					.background(Color.pastelLavender.opacity(0.3))
					.cornerRadius(10)
			}
			.NeumorphicStyle(using: colorScheme)
			Circle()
				.fill(Color.pastelLavender.opacity(0.7))
				.overlay {
					Text("\(selectedIngredientCategoryCount(for: category))")
						.regularFont()
				}
				.frame(width: 30, height: 30, alignment: .topTrailing)
				.padding([.trailing, .top], 5)
				.opacity(selectedIngredientCategoryCount(for: category) >= 1 ? 1 : 0)
		}
	}
	
	private func selectedIngredientCategoryCount(for category: IngredientCategory) -> Int {
		ingredients[category]?.filter { $0.isSelected }.count ?? 0
	}
	
	private var createMealPlanButton: some View {
		NeumorphicAsyncButton(
			action: { completion in
				// Your asynchronous operation goes here
				Task {
					do {
						_ = try await generateMealPlan()
						// success show meal plan and clear form
						isShowingMealPlans.toggle()
						
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
	
	private func resetForm() {
		mealPlanName = ""
		numberOfDays = 0
		caloricIntakeRange = CaloricIntakeRange.low
	}
	
	private func generateMealPlan() async throws -> String {
		// Your meal plan creation logic
				let day = MealPlan.Day(day: 1, meals: [MealPlan.Meal(name: "", food: [""])], calories: 0)
				let sampleMealPlan = ExampleData.sampleMealPlan ?? MealPlan(days: [day])
				 sampleMealPlan.mealPlanName = mealPlanName // set the name
		
		// Insert the meal plan into your data model or service and await its completion
				 modelContext.insert(sampleMealPlan)
		
		try await Task.sleep(nanoseconds: 3 * 1_000_000_000)  // Three seconds
		// Check if the meal plan is in your data model or service using FetchDescriptor
		print(allSelectedIngredients.count)
		return "done"
	}
	
	
}

#Preview {
	MealPlanner()
}

// future feature
// shopping list creation..
