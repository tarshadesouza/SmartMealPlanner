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
	@Binding var ingredients:[IngredientCategory: [Ingredient]]
	
	init(category: Binding<IngredientCategory?>, ingredients: Binding<[IngredientCategory: [Ingredient]]>) {
		_category = category
		_ingredients = ingredients
	}

	var selectedIngredients: [Ingredient] {
		guard let category = category else { return [] }
		return ingredients[category]?.filter { $0.isSelected } ?? []
	}
	
	func selectIngredient(_ ingredient: Ingredient) {
		guard let category = category else { return }

		guard let index = ingredients[category]?.firstIndex(of: ingredient) else {
			return
		}
		let ingredients = ingredients[category]
		ingredients?[index].isSelected.toggle()
	}

}
