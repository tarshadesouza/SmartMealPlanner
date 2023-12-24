//
//  MealPlanDetailView.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 21/12/2023.
//

import SwiftUI
import SwiftData

struct MealPlanDetailView: View {
	@Environment(\.presentationMode) var presentationMode
	@Binding var mealPlan: MealPlan

    var body: some View {
			ScrollView {
				VStack(alignment: .leading, spacing: 20) {
					ForEach($mealPlan.days) { $day in
						DisclosureGroup("Day \(day.day)", isExpanded: $day.isExpanded ) {
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
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding()
							.NeumorphicStyle()
							.padding()
						}
						.tint(Color.pastelRose)
						.font(.headline)
						.fontWeight(.bold)
						.background(Color.backgroundLight)
						
					}
				}
				.padding()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			.navigationBarBackButtonHidden(true)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(action: {
							presentationMode.wrappedValue.dismiss()
						}) {
							Image(systemName: "arrow.left.circle.fill")
								.resizable()
								.renderingMode(.template)
								.frame(width: 24, height: 24)
								.foregroundColor(.pastelRose)
						}
					}
				}
			.navigationTitle("My NY Resolution 🥗")
			.background(Color.backgroundLight)
    }
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: MealPlan.self, configurations: config)
	let day = MealPlan.Day(day: 1, meals: [MealPlan.Meal(name: "default", food: ["default"])], calories: 0)
	let sampleMealPlan = ExampleData.sampleMealPlan ?? MealPlan(days: [day])
	return MealPlanDetailView(mealPlan: .constant(sampleMealPlan))
		.modelContainer(container)
}


//NavigationView {
//	ScrollView {
//		VStack(alignment: .leading, spacing: 20) {
//			ForEach($viewModel.mealPlan.days) { $day in
//				DisclosureGroup("Day \(day.day)", isExpanded: $day.isExpanded ) {
//					VStack(alignment: .leading) {
//						ForEach(day.meals) { meal in
//							VStack(alignment: .leading) {
//								Text(meal.name)
//									.font(.headline)
//									.fontWeight(.bold)
//
//								ForEach(meal.food, id: \.self) { food in
//									Text("- \(food)")
//										.font(.body)
//										.padding(.leading, 20)
//								}
//							}
//							.padding(.bottom, 10)
//						}
//
//						Text("Calories: \(day.calories)")
//							.font(.subheadline)
//							.foregroundColor(.secondary)
//							.padding(.top, 5)
//					}
//					.frame(maxWidth: .infinity, alignment: .leading)
//					.padding()
//					.NeumorphicStyle()
//					.padding()
//				}
//				.tint(Color.pastelRose)
//				.font(.headline)
//				.fontWeight(.bold)
//				.background(Color.backgroundLight)
//
//			}
//		}
//		.padding()
//		.frame(maxWidth: .infinity, maxHeight: .infinity)
//	}
//	.navigationTitle("Meal Plans 🥦")
//	.background(Color.backgroundLight)
//}
