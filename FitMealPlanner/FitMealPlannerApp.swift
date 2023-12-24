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

    var body: some Scene {
        WindowGroup {
			MealPlanner()
		}
		.modelContainer(for: [Ingredient.self, MealPlan.self, MealPlan.Day.self, MealPlan.Meal.self ])
    }
}
