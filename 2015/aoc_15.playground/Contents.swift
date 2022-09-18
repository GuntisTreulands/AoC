import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

//calculateBestRecipe(test) // 62842800  // 44, 56
//calculateBestRecipe(input) // 222870   // 21, 5, 31, 43
calculateBestRecipe(input, withCaloriesTarget:true) // 117936  // 21, 8, 26, 45


struct Ingredient {
	let capacity: Int
	let durability: Int
	let flavor: Int
	let texture: Int
	let calories: Int
}


func calculateBestRecipe(_ string: String, withCaloriesTarget: Bool = false) {

	let input = string.components(separatedBy: "\n")

	var ingredients = [Ingredient]()

	var perfectCombinations = [Int]()

	for description in input {
		if description.isEmpty {
			continue
		}

		let capacity = Int(description.components(separatedBy: "capacity ").last!.components(separatedBy: ", ").first!)!
		let durability = Int(description.components(separatedBy: "durability ").last!.components(separatedBy: ", ").first!)!
		let flavor = Int(description.components(separatedBy: "flavor ").last!.components(separatedBy: ", ").first!)!
		let texture = Int(description.components(separatedBy: "texture ").last!.components(separatedBy: ", ").first!)!
		let calories = Int(description.components(separatedBy: "calories ").last!.components(separatedBy: ", ").first!)!

		ingredients.append(Ingredient.init(capacity: capacity, durability: durability, flavor: flavor, texture: texture, calories: calories))
	}

	var maxEncounteredValue = 0

	if ingredients.count == 4 {
		for one in 1..<100 {
			for two in 1..<100 {
				for three in 1..<100 {
					for four in 1..<100 {

						if one + two + three + four == 100 {
							let capacity = max(0, ingredients[0].capacity * one + ingredients[1].capacity * two + ingredients[2].capacity * three + ingredients[3].capacity * four)

							let durability = max(0, ingredients[0].durability * one + ingredients[1].durability * two + ingredients[2].durability * three + ingredients[3].durability * four)

							let flavor = max(0, ingredients[0].flavor * one + ingredients[1].flavor * two + ingredients[2].flavor * three + ingredients[3].flavor * four)

							let texture = max(0, ingredients[0].texture * one + ingredients[1].texture * two + ingredients[2].texture * three + ingredients[3].texture * four)

							let calories = max(0, ingredients[0].calories * one + ingredients[1].calories * two + ingredients[2].calories * three + ingredients[3].calories * four)

							let totalValue = capacity * durability * flavor * texture

							if !withCaloriesTarget || (withCaloriesTarget && calories == 500) {
								if totalValue > maxEncounteredValue {
									maxEncounteredValue = totalValue
									perfectCombinations.removeAll()
									perfectCombinations.append(one)
									perfectCombinations.append(two)
									perfectCombinations.append(three)
									perfectCombinations.append(four)
								}
							}

						}
					}
				}
			}
		}
	} else if ingredients.count == 2 {
		for one in 1..<100 {

			let two = 100-one

			let firstIngredient = ingredients.first!
			let secondIngredient = ingredients.last!

			let capacity = max(0, firstIngredient.capacity * one + secondIngredient.capacity * two)

			let durability = max(0, firstIngredient.durability * one + secondIngredient.durability * two)

			let flavor = max(0, firstIngredient.flavor * one + secondIngredient.flavor * two)

			let texture = max(0, firstIngredient.texture * one + secondIngredient.texture * two)

			let totalValue = capacity * durability * flavor * texture

			if totalValue > maxEncounteredValue {
				maxEncounteredValue = totalValue
				perfectCombinations.removeAll()
				perfectCombinations.append(one)
				perfectCombinations.append(two)
			}
		}
	}

	print("maxEncounteredValue = \(maxEncounteredValue)")

	if withCaloriesTarget {
		print("Perfect Ingredients For Calories target 500 = \(perfectCombinations)")
	} else {
		print("Perfect Ingredients = \(perfectCombinations)")
	}
}
