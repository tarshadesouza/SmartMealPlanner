//
//  MyMealPlans.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 20/12/2023.
//

import SwiftUI

// a list of meal plans that already exist in the users database.
// do the UI first
// then mimic backend format.
class MealPlan: Codable {
	class Meal: Codable, Identifiable {
		let id = UUID()
		let name: String
		let food: [String]

		init(name: String, food: [String]) {
			self.name = name
			self.food = food
		}
	}

	class Day: Codable, Identifiable {
		let id = UUID()
		let day: Int
		let meals: [Meal]
		let calories: Int
		var isExpanded: Bool? = false

		init(day: Int, meals: [Meal], calories: Int) {
			self.day = day
			self.meals = meals
			self.calories = calories
		}
	}
	init(days: [Day]) {
		self.days = days
	}
	var days: [Day]
}


class MealPlanViewModel: ObservableObject {
	@Published var mealPlan: MealPlan

	init(mealPlan: MealPlan) {
		self.mealPlan = mealPlan
	}

	// Add any other methods or properties you need for managing the meal plan

	func toggleDayExpansion(day: MealPlan.Day) {
		if let index = mealPlan.days.firstIndex(where: { $0.id == day.id }) {
			mealPlan.days[index].isExpanded?.toggle()
		}
	}
}

struct MyMealPlans: View {
	@StateObject private var viewModel: MealPlanViewModel
	init(mealPlan: MealPlan) {
		 _viewModel = StateObject(wrappedValue: MealPlanViewModel(mealPlan: mealPlan))
	 }

		var body: some View {
			ScrollView {
				VStack(alignment: .leading, spacing: 20) {
					ForEach($viewModel.mealPlan.days) { $day in
						DisclosureGroup("Day \(day.day)", isExpanded: Binding(get: { day.isExpanded ?? false }, set: { $day.isExpanded = $0 })) {
								VStack(alignment: .leading) {
									ForEach(day.meals) { meal in
										VStack(alignment: .leading) {
											Text(meal.name)
												.font(.headline)
												.fontWeight(.bold)
											
											ForEach(meal.food, id: \.self) { food in
												Text("- \(food)")
													.font(.body)
													.padding(.leading, 20)
											}
										}
										.padding(.bottom, 10)
									}
									
									Text("Calories: \(day.calories)")
										.font(.subheadline)
										.foregroundColor(.secondary)
										.padding(.top, 5)
								}
								.padding(.bottom, 20)
							}
						
					}
				}
				.padding()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
}


#Preview {
	let day = MealPlan.Day(day: 1, meals: [MealPlan.Meal(name: "", food: [""])], calories: 0)
	let sampleMealPlan = ExampleData.sampleMealPlan ?? MealPlan(days: [day])
	return MyMealPlans(mealPlan: sampleMealPlan)
}

// will have to ask gpt for the data in a certain way... so that it gives me back this structure.

struct ExampleData {
	static let json = """
		{
		  "days": [
			{
			  "day": 1,
			  "meals": [
				{"name": "Breakfast", "food": ["Apples", "Bananas"]},
				{"name": "Lunch", "food": ["Broccoli", "Chicken"]}
			  ],
			  "calories": 1300
			},
			{
			  "day": 2,
			  "meals": [
				{"name": "Breakfast", "food": ["Oranges", "Yogurt"]},
				{"name": "Lunch", "food": ["Spinach Salad", "Salmon"]}
			  ],
			  "calories": 1300
			},
	{
	  "day": 2,
	  "meals": [
		{"name": "Breakfast", "food": ["Oranges", "Yogurt"]},
		{"name": "Lunch", "food": ["Spinach Salad", "Salmon"]}
	  ],
	  "calories": 1300
	}
		  ]
		}
	"""

	static var sampleMealPlan: MealPlan? {
		if let jsonData = json.data(using: .utf8),
		   let mealPlan = try? JSONDecoder().decode(MealPlan.self, from: jsonData) {
			return mealPlan
		}
		return nil
	}
}

