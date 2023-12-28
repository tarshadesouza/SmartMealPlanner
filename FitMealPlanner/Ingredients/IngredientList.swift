//
//  IngredientList.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 12/12/2023.
//

import SwiftUI
import SwiftData

struct IngredientList: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) private var modelContext
	@Query var userAddedIngredients: [Ingredient]
	@ObservedObject private var viewModel: IngredientListViewModel
	@State private var newIngredient = ""
    @State private var isShowingNewIngredientField = false
	
	init(category: Binding<IngredientCategory?>, ingredients: Binding<[IngredientCategory: [Ingredient]]>) {
		self.viewModel = IngredientListViewModel(category: category, ingredients: ingredients)
	}
	
	var body: some View {
		NavigationView {
			ZStack(alignment: .bottom) {
				VStack(spacing: 0) {
					newIngredientField
					ingredientsList
				}
				.frame(maxHeight: .infinity)
				doneButton
				.toolbar {
					Button("", systemImage: "plus") {
						withAnimation {
							isShowingNewIngredientField.toggle()
						}
					}
				}
			}
			.navigationTitle(viewModel.category?.rawValue ?? "")
			.tint(Color.pastelRose)
		}
		.onFirstAppear {
			Task {
				loadUsersAddedIngredients()
			}
		}
		.onDisappear() {
			Task {
				viewModel.category = nil
			}
		}
	}
	
	private var doneButtonTitle: String {
		viewModel.selectedIngredients.count >= 1 ? "\(viewModel.selectedIngredients.count) ✅" : "\(viewModel.selectedIngredients.count) selections"
	}

	private var doneButton: some View {
		 Button(
			action: {
				Task {
					viewModel.category = nil
					dismiss()
				}
			},
			label: {
				Text(doneButtonTitle)
					.frame(minWidth: 80)
			}
		)
		.buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 20)))
		.scaleEffect(viewModel.selectedIngredients.count >= 1 ? 1.0 : 0.92)
		.animation(.easeOut, value: viewModel.selectedIngredients)
	}

	private var newIngredientField: some View {
		TextField(isShowingNewIngredientField ? "Add an ingredient" : " ",
				  text: $newIngredient, onCommit: {
			addNewIngredient()
			withAnimation {
				isShowingNewIngredientField.toggle()
			}
		})
		.padding()
		.frame(height: isShowingNewIngredientField ? 50 : 0)
		.NeumorphicStyle()
		.padding()
		.opacity(isShowingNewIngredientField ? 1 : 0)
	}
	
	private var ingredientsList: some View {
		List {
			ForEach(viewModel.ingredients[viewModel.category ?? .Fruit] ?? [], id: \.self) { ingredient in
				ingredientListItem(ingredient)
					.swipeActions {
						if isDeletable(ingredient: ingredient) {
							Button(role: .destructive) {
								deleteIngredient(ingredient)
							} label: {
								Label("Delete", systemImage: "trash")
							}
						}
					}
					.onTapGesture {
						viewModel.selectIngredient(ingredient)
					}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
	
	private func ingredientListItem(_ ingredient: Ingredient) -> some View {
		HStack {
			Image(systemName: ingredient.isSelected ? "checkmark.square" : "square")
				.resizable()
				.frame(width: 24, height: 24)
				.foregroundColor(ingredient.isSelected ? Color.white : Color.pastelRose)
				.background(ingredient.isSelected ? Color.pastelRose : Color.white)
				.cornerRadius(4)
			Text(ingredient.name)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
	}


	private func addNewIngredient() {
		guard let category = viewModel.category else { return }
		viewModel.ingredients[category]?.insert(Ingredient(category: category, name: newIngredient), at: 0)
		modelContext.insert(Ingredient(category: category, name: newIngredient))
		newIngredient = ""
	}

	private func isDeletable(ingredient: Ingredient) -> Bool {
		guard let category = viewModel.category else { return false }
		let userAdded = userAddedIngredients.filter { $0.category == category.rawValue}

		return userAdded.contains(ingredient) ? true : false
	}
	
	private func deleteIngredient(_ ingredient: Ingredient) {
		guard let category = viewModel.category, let index = viewModel.ingredients[category]?.firstIndex(of: ingredient) else {
			return
		}
		modelContext.delete(ingredient)
		viewModel.ingredients[category]?.remove(at: index)
	}

	private func loadUsersAddedIngredients() {
		guard let category = viewModel.category else { return }
		let userAdded = userAddedIngredients.filter { $0.category == category.rawValue }
		// Filter out ingredients that already exist in selectedIngredients
		let newIngredients = userAdded.filter { userIngredient in
			!(viewModel.ingredients[category]?.contains(where: { $0.name == userIngredient.name }) ?? false)
		}
		// Insert only the new ingredients
		viewModel.ingredients[category]?.insert(contentsOf: newIngredients, at: 0)
	}
	private func ingredientCell(_ ingredient: String) -> some View {
		Text(ingredient)
	}
}

//#Preview {
//	 let config = ModelConfiguration(isStoredInMemoryOnly: true)
//	 let container = try! ModelContainer(for: Ingredient.self, configurations: config)
//
//	return IngredientList(category: .constant(.Fruit))
//		 .modelContainer(container)
//}
