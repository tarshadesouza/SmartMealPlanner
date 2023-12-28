//
//  Ingredient.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 19/12/2023.
//

import Foundation
import SwiftData


public enum IngredientCategory: String {
	case Fruit = "Fruit 🍎"
	case Vegetables = "Veggies 🥑"
	case Cereals = "Cereals 🥖"
	case Proteins = "Proteins 🥩"

	 var sampleIngredients: [Ingredient] {
		switch self {
		case .Fruit:
			IngredientData.shared.fruits.map { Ingredient(category: .Fruit, name: $0) }
		case .Vegetables:
			IngredientData.shared.vegetables.map { Ingredient(category: .Vegetables, name: $0) }
		case .Cereals:
			IngredientData.shared.cereals.map { Ingredient(category: .Cereals, name: $0) }
		case .Proteins:
			IngredientData.shared.proteins.map { Ingredient(category: .Proteins, name: $0) }
		}
	}
}

@Model
public class Ingredient: Hashable, Identifiable {
	@Attribute(.unique) public let id = UUID()
	@Attribute public let category: String
	@Attribute(.unique) public let name: String
	public var isSelected: Bool = false

	public init(id: UUID = UUID(), category: IngredientCategory, name: String) {
		self.id = id
		self.category = category.rawValue
		self.name = name
	}
}
