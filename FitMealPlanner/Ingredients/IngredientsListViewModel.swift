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
	
	init(category: Binding<IngredientCategory?>) {
		_category = category
		setUpIngredientData()
	}

	func setUpIngredientData() {
		guard let category = category else { return }
		switch category {
		case .Vegetables:
			filteredIngredients = IngredientData.shared.vegetables.map { Ingredient(category: category, name: $0) }
		case .Fruit:
			filteredIngredients = IngredientData.shared.fruits.map { Ingredient(category: category, name: $0) }
		case .Proteins:
			filteredIngredients = IngredientData.shared.proteins.map { Ingredient(category: category, name: $0) }
		case .Cereals:
			filteredIngredients = IngredientData.shared.cereals.map { Ingredient(category: category, name: $0) }
		}
	}

	var selectedIngredients: [Ingredient] {
		filteredIngredients.filter{ $0.isSelected }
	}
}
