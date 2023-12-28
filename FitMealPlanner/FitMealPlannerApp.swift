//
//  FitMealPlannerApp.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 11/12/2023.
//

import SwiftUI
import SwiftData

@main
struct FitMealPlannerApp: App {
	
	
	let modelContainer: ModelContainer
	
	init() {
		do {
			modelContainer = try ModelContainer(for: Ingredient.self, MealPlan.self, MealPlan.Day.self, MealPlan.Meal.self )
		} catch {
			fatalError("Could not initialize ModelContainer")
		}
	}

    var body: some Scene {
        WindowGroup {
			MealPlanner()
		}
		.modelContainer(modelContainer)
//		.modelContainer(for: [Ingredient.self, MealPlan.self, MealPlan.Day.self, MealPlan.Meal.self ])
    }
}
