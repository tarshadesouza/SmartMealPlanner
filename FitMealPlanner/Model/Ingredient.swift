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
