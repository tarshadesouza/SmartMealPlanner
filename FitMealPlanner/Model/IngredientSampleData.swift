//
//  IngredientData.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 18/12/2023.
//

import Foundation

struct IngredientData {
	static let shared = IngredientData()

	let vegetables = [
		"Broccoli", "Spinach", "Carrots", "Bell Peppers", "Tomatoes", "Cucumber",
		"Kale", "Zucchini", "Sweet Potatoes", "Asparagus", "Green Beans", "Brussels Sprouts",
		"Cauliflower", "Cabbage", "Onions", "Garlic", "Celery", "Lettuce",
		"Artichokes", "Eggplant", "Mushrooms", "Peas", "Radishes", "Beets",
		"Squash", "Pumpkin"
	]
	
	let fruits = [
		"Apples", "Bananas", "Strawberries", "Blueberries", "Grapes", "Oranges",
		"Pineapple", "Mango", "Peaches", "Watermelon", "Kiwi", "Avocado",
		"Berries", "Cherries", "Grapefruit", "Lemons", "Limes", "Pomegranate",
		"Cantaloupe", "Honeydew", "Apricots", "Plums", "Pears", "Raspberries",
		"Blackberries", "Cranberries"
	]
	
	let proteins = [
		"Chicken Breast", "Salmon", "Tofu", "Eggs", "Black Beans", "Greek Yogurt",
		"Beef", "Shrimp", "Quinoa", "Cottage Cheese", "Turkey", "Lentils",
		"Chickpeas", "Pork", "Soybeans", "Venison", "Tempeh", "Cod",
		"Haddock", "Trout", "Sardines", "Crab", "Lobster", "Scallops",
		"Chicken Thighs", "Bison"
	]
	
	let cereals = [
		"Quinoa", "Brown Rice", "Oats", "Whole Wheat Pasta", "Barley", "Buckwheat",
		"Farro", "Couscous", "Millet", "Bulgur", "Sorghum", "Spelt",
		"Wild Rice", "Polenta", "Amaranth", "Rye", "Freekeh", "Teff",
		"Bran Flakes", "Granola", "Cornflakes", "Bran Buds", "Wheat Germ", "Oat Bran",
		"Puffed Rice", "Kamut"
	]
	
}
