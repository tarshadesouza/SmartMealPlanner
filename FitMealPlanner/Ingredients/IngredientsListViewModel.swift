//
//  IngredientsListViewModel.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 20/12/2023.
//

import Foundation
import SwiftUI

class IngredientListViewModel: ObservableObject {
	@Binding var category: IngredientCategory?
	@Published var filteredIngredients: [Ingredient] = []
	@Published var selectedIngredients = Set<Ingredient>()
	
	init(category: Binding<IngredientCategory?>) {
		_category = category
		setUpIngredientData()
	}

	func setUpIngredientData() {
		guard let category = category else { return }
		switch category {
		case .Vegetables:
			filteredIngredients = vegetables.map { Ingredient(category: category, name: $0) }
		case .Fruit:
			filteredIngredients = fruits.map { Ingredient(category: category, name: $0) }
		case .Proteins:
			filteredIngredients = proteins.map { Ingredient(category: category, name: $0) }
		case .Cereals:
			filteredIngredients = cereals.map { Ingredient(category: category, name: $0) }
		}
	}
}
