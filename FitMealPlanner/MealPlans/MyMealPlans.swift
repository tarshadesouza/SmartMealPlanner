//
//  MyMealPlans.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 20/12/2023.
//

import SwiftUI
import SwiftData

@Model class MealPlan: Codable, Hashable {
	@Attribute(.unique) let id = UUID()
	@Attribute var days: [Day]
	var mealPlanName: String = ""

	init(days: [Day]) {
		self.days = days
	}
	private enum CodingKeys: String, CodingKey {
		 case days
	 }
	
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		days = try values.decode([Day].self, forKey: .days)
	}

	func encode(to encoder: Encoder) throws {
		  var container = encoder.container(keyedBy: CodingKeys.self)
		  try container.encode(days, forKey: .days)
	  }
	
	@Model class Meal: Codable, Identifiable, Equatable {
		@Attribute(.unique) let id = UUID()
		@Attribute let name: String
		@Attribute let food: [String]

		init(name: String, food: [String]) {
			self.name = name
			self.food = food
		}
		private enum CodingKeys: String, CodingKey {
			 case name, food
		 }
		
		static func == (lhs: Meal, rhs: Meal) -> Bool {
			return lhs.id == rhs.id
		}
		
		required init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			name = try values.decode(String.self, forKey: .name)
			food = try values.decode([String].self, forKey: .food)
		}
		func encode(to encoder: Encoder) throws {
			  var container = encoder.container(keyedBy: CodingKeys.self)
			  try container.encode(name, forKey: .name)
			  try container.encode(food, forKey: .food)
		  }
	}

	@Model class Day: Codable, Identifiable {
		@Attribute(.unique) let id = UUID()
		@Attribute let day: Int
		@Attribute let meals: [Meal]
		@Attribute let calories: Int
		var isExpanded = true

		init(day: Int, meals: [Meal], calories: Int) {
			self.day = day
			self.meals = meals
			self.calories = calories
		}
		
		private enum CodingKeys: String, CodingKey {
			 case day, meals, calories
		 }
		
		required init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			day = try values.decode(Int.self, forKey: .day)
			meals = try values.decode([Meal].self, forKey: .meals)
			calories = try values.decode(Int.self, forKey: .calories)
		}
		
		func encode(to encoder: Encoder) throws {
			  var container = encoder.container(keyedBy: CodingKeys.self)
			  try container.encode(day, forKey: .day)
			  try container.encode(meals, forKey: .meals)
			  try container.encode(calories, forKey: .calories)
		  }
	}
}


class MealPlanViewModel: ObservableObject {
	@Published var mealPlans: [MealPlan]

	init(_ mealPlans: [MealPlan]) {
		self.mealPlans = mealPlans
	}
}

struct MyMealPlans: View {
	@StateObject private var viewModel: MealPlanViewModel = MealPlanViewModel([])
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) var dismiss
	@Query var mealPlans: [MealPlan]
	@State var selectedMealPlan: MealPlan?
	@State var isInEditMode = false

	init() {
//		let day = MealPlan.Day(day: 1, meals: [MealPlan.Meal(name: "default", food: ["default"])], calories: 0)
//		let sampleMealPlan = ExampleData.sampleMealPlan ?? MealPlan(days: [day])
//		let mealPlanViewModel = MealPlanViewModel([sampleMealPlan])
//
//		_viewModel = StateObject(wrappedValue: mealPlanViewModel)
		
		// Removes nav bar bottom border.
		let appearance = UINavigationBarAppearance()
		 appearance.shadowColor = .clear
		 UINavigationBar.appearance().standardAppearance = appearance
		 UINavigationBar.appearance().scrollEdgeAppearance = appearance
	}

		var body: some View {
			NavigationView {
				ScrollView {
						ForEach(viewModel.mealPlans.indices, id: \.self) { index in
							NavigationLink(
								destination: MealPlanDetailView(mealPlan: $viewModel.mealPlans[index])
							) {
								HStack {
									Text("\(viewModel.mealPlans[index].mealPlanName)")
										.frame(height: 50)
										.frame(maxWidth: .infinity)
										.foregroundColor(.primary)
									if isInEditMode {
										Image(systemName: "trash.circle.fill")
											.resizable()
											.foregroundColor(.pastelLavender)
											.frame(width: 24, height: 24)
											.onTapGesture {
												deleteMealPlan(at: index)
											}
											.sequentialFadeIn(index: index)
									}
								}
								
							}
							.frame(maxWidth: .infinity)
							.padding()
							.buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 20)))
						}
				}
				.onAppear() {
					viewModel.mealPlans = self.mealPlans
				}
				.navigationTitle("My Meal Plans 🥦")
				.toolbar() {
					Button(action: {
						withAnimation {
							isInEditMode.toggle()
						}
					}) {
						Image(systemName: "pencil.circle.fill")
							.resizable()
							.renderingMode(.template)
							.frame(width: 24, height: 24)
							.foregroundColor(.pastelLavender)
					}
					.buttonStyle(NeumorphicButton(shape: Circle()))
					
					Button(action: {
						dismiss()
					}) {
						Image(systemName: "xmark.circle.fill")
							.resizable()
							.renderingMode(.template)
							.frame(width: 24, height: 24)
							.foregroundColor(.pastelLavender)
					}
					.buttonStyle(NeumorphicButton(shape: Circle()))
				}
			}
			.background(Color.backgroundLight)
		}

	private func deleteMealPlan(at index: Int) {
		print("delete pressed")
		viewModel.mealPlans.remove(at: index)
		modelContext.delete(viewModel.mealPlans[index])
	}
}

// meals are loaded from swift data upon view showing
// no need for them to passed in, they will get saved upon generation and u can access them via swift data

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: MealPlan.self, configurations: config)
	let day = MealPlan.Day(day: 1, meals: [MealPlan.Meal(name: "default", food: ["default"])], calories: 0)
	let sampleMealPlan = ExampleData.sampleMealPlan ?? MealPlan(days: [day])
	container.mainContext.insert(sampleMealPlan)
	return MyMealPlans()
		.modelContainer(container)
}


struct ExampleData {
	static let json = """
		{
		  "days": [
			{
			  "day": 1,
			  "meals": [
				{"name": "Breakfast", "food": ["Apples", "Bananas"]},
				{"name": "Lunch", "food": ["Broccoli", "Chicken"]},
				{"name": "Dinner", "food": ["Broccoli", "Chicken"]}
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

