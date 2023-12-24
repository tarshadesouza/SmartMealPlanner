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
	@Binding var selectedIngredients: [IngredientCategory: [Ingredient]]
	
	init(category: Binding<IngredientCategory?>, selectedIngredients: Binding<[IngredientCategory: [Ingredient]]>) {
		self.viewModel = IngredientListViewModel(category: category)
		_selectedIngredients = selectedIngredients
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
		.onAppear() {
			Task {
				loadUsersAddedIngredients()
				// Load in any selected ingredients and update your initialized ingredient list programatically.
				synchronizeSelectionState()
			}
		}
		.onDisappear() {
			Task {
				print(viewModel.selectedIngredients.count)
				if let category = viewModel.category {
					// Check if the category is already in the dictionary
					if var existingSelectedIngredients = selectedIngredients[category] {
						// Append the selected ingredients to the existing array
						existingSelectedIngredients.append(contentsOf: viewModel.selectedIngredients)
						selectedIngredients[category] = existingSelectedIngredients
					} else {
						// If the category is not in the dictionary, add a new entry
						selectedIngredients[category] = viewModel.selectedIngredients
					}
				}
				viewModel.category = nil

//				selectedIngredients = [viewModel.category ?? .Fruit : viewModel.selectedIngredients]
//				selectedIngredients = viewModel.selectedIngredients // this will set it back to 0! if its in a diff category. for example i go from fruit select two and then go to veggies.. i go back and now nothing from fruit is selected
				
			}
		}
	}
	
//	private func synchronizeSelectionState() {
//		  for (index, ingredient) in viewModel.filteredIngredients.enumerated() {
//			  if let selectedIngredient = selectedIngredients.first(where: { $0.name == ingredient.name }) {
//				  viewModel.filteredIngredients[index].isSelected = selectedIngredient.isSelected
//			  }
//		  }
//	  }
	
	private func synchronizeSelectionState() {
		 guard let category = viewModel.category else { return }

		 for (index, ingredient) in viewModel.filteredIngredients.enumerated() {
			 if let selectedCategoryIngredients = selectedIngredients[category],
				let selectedIngredient = selectedCategoryIngredients.first(where: { $0.name == ingredient.name }) {
				 viewModel.filteredIngredients[index].isSelected = selectedIngredient.isSelected
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
//					selectedIngredients = viewModel.selectedIngredients
					selectedIngredients[viewModel.category ?? .Fruit] = viewModel.selectedIngredients

					dismiss()
				}
			},
			label: {
				Text(doneButtonTitle)
					.frame(minWidth: 80)
			}
		)
		.buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 20)))
		.scaleEffect(viewModel.selectedIngredients.count ?? 0 >= 1 ? 1.0 : 0.92)
		.animation(.easeOut, value: viewModel.selectedIngredients)
	}

	private var newIngredientField: some View {
		TextField(isShowingNewIngredientField ? "Add an ingredient" : " ",
				  text: $newIngredient, onCommit: {
			guard let category = viewModel.category else { return }
			viewModel.filteredIngredients.insert(Ingredient(category: category, name: newIngredient), at: 0)
			modelContext.insert(Ingredient(category: category, name: newIngredient))
			newIngredient = ""

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
			ForEach(viewModel.filteredIngredients.indices, id: \.self) { index in
				let ingredient = viewModel.filteredIngredients[index]
				ingredientListItem(ingredient)
					.swipeActions {
						if isDeletable(ingredient: ingredient) {
							Button(role: .destructive) {
								deleteIngredient(at: index)
							} label: {
								Label("Delete", systemImage: "trash")
							}
						}
					}
					.onTapGesture {
						selectIngredient(ingredient, at: index)
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

	private func selectIngredient(_ ingredient: Ingredient, at index: Int) {
		viewModel.filteredIngredients[index].isSelected.toggle()
	}

	private func isDeletable(ingredient: Ingredient) -> Bool {
		guard let category = viewModel.category else { return false }
		let userAdded = userAddedIngredients.filter { $0.category == category.rawValue}

		return userAdded.contains(ingredient) ? true : false
	}

	private func deleteIngredient(at index: Int) {
		guard let category = viewModel.category else { return }
		let ingredient = viewModel.filteredIngredients[index]
		modelContext.delete(ingredient)
		viewModel.filteredIngredients.remove(at: index)
	}

	private func loadUsersAddedIngredients() {
		guard let category = viewModel.category else { return }
		let userAdded = userAddedIngredients.filter { $0.category == category.rawValue}
		viewModel.filteredIngredients.insert(contentsOf: userAdded, at: 0)
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

struct SelectedIngredientsKey: PreferenceKey {
	static var defaultValue: Set<Ingredient> = []
	
	static func reduce(value: inout Set<Ingredient>, nextValue: () -> Set<Ingredient>) {
		value = nextValue()
	}
}
