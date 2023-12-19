//
//  IngredientList.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 12/12/2023.
//

import SwiftUI

struct IngredientList: View {
	let category: IngredientCategory
	@State private var filteredIngredients: [Ingredient]
	@State private var selectedIngredients = Set<Ingredient>()

	init(category: IngredientCategory) {
		self.category = category
		switch category {
		case .Vegetables:
			_filteredIngredients = State(initialValue: vegetables.map { Ingredient(category: category, name: $0) })
		case .Fruit:
			_filteredIngredients = State(initialValue: fruits.map { Ingredient(category: category, name: $0) })
		case .Proteins:
			_filteredIngredients = State(initialValue: proteins.map { Ingredient(category: category, name: $0) })
		case .Cereals:
			_filteredIngredients = State(initialValue: cereals.map { Ingredient(category: category, name: $0) })
		}
	}
	var body: some View {
		NavigationView {
			ZStack(alignment: .bottom) {
				List(filteredIngredients, id: \.self, selection: $selectedIngredients) { ingredient in
					Text(ingredient.name)
						.listRowBackground(
							Color.clear
								.background(
									selectedIngredients.contains(ingredient)
									? Color.pastelMint.opacity(0.5)
									: Color.clear
								)
								.animation(.interpolatingSpring(stiffness: 70, damping: 10), value: selectedIngredients)
						)
						.onTapGesture {
							withAnimation {
								// Add the ingredient to the selected set
								if selectedIngredients.contains(ingredient) {
									selectedIngredients.remove(ingredient)
								} else {
									selectedIngredients.insert(ingredient)
								}
							}
						}
				}
				.environment(\.editMode, .constant(.active))
				.navigationTitle(category.rawValue)
				RoundedPrimaryButton(title: "\(selectedIngredients.count) selections") {
					print("done")
				}
				
			}
			.tint(Color.pastelRose)
		}
	}
	
	private func ingredientCell(_ ingredient: String) -> some View {
		Text(ingredient)
	}
}

#Preview {
	IngredientList(category: .Fruit)
}
