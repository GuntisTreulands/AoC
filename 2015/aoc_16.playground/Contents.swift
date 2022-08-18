import UIKit
import Foundation


let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var input = String(data:inputData, encoding:String.Encoding.utf8)!

struct Sue {
	let children: Int
	let cats: Int
	let samoyeds: Int
	let pomeranians: Int
	let akitas: Int
	let vizslas: Int
	let goldfish: Int
	let trees: Int
	let cars: Int
	let perfumes: Int

	func Part1IsThisSueMatchingAtLeastInThreeParams(_ sue: Sue) -> Bool {
		var matches = 0

		if sue.children == self.children { matches += 1 }
		if sue.cats == self.cats { matches += 1 }
		if sue.samoyeds == self.samoyeds { matches += 1 }
		if sue.pomeranians == self.pomeranians { matches += 1 }
		if sue.akitas == self.akitas { matches += 1 }
		if sue.vizslas == self.vizslas { matches += 1 }
		if sue.goldfish == self.goldfish { matches += 1 }
		if sue.trees == self.trees { matches += 1 }
		if sue.cars == self.cars { matches += 1 }
		if sue.perfumes == self.perfumes { matches += 1 }

		return (matches == 3)
	}


	func Part2IsThisSueMatchingAtLeastInThreeParams(_ sue: Sue) -> Bool {
		var matches = 0

		if sue.children == self.children { matches += 1 }
		if sue.cats < self.cats { matches += 1 }
		if sue.samoyeds == self.samoyeds { matches += 1 }
		if sue.pomeranians > self.pomeranians && self.pomeranians != -1 { matches += 1 }
		if sue.akitas == self.akitas { matches += 1 }
		if sue.vizslas == self.vizslas { matches += 1 }
		if sue.goldfish > self.goldfish && self.goldfish != -1 { matches += 1 }
		if sue.trees < self.trees { matches += 1 }
		if sue.cars == self.cars { matches += 1 }
		if sue.perfumes == self.perfumes { matches += 1 }

		return (matches == 3)
	}
}

let targetSue = Sue.init(children: 3, cats: 7, samoyeds: 2, pomeranians: 3, akitas: 0, vizslas: 0, goldfish: 5, trees: 3, cars: 2, perfumes: 1)

findSueNumber(input, withTargetSue:targetSue)

func findSueNumber(_ string: String, withTargetSue: Sue) {

	let descriptions = string.components(separatedBy: "\n")

	var allSues = [Int:Sue]()

	for description in descriptions {
		if description.isEmpty {
			continue
		}

		var children = -1
		var cats = -1
		var samoyeds = -1
		var pomeranians = -1
		var akitas = -1
		var vizslas = -1
		var goldfish = -1
		var trees = -1
		var cars = -1
		var perfumes = -1


		let sueIndex = Int(description.components(separatedBy: "Sue ").last!.components(separatedBy: ":").first!)!

		if description.contains("children") {
			children = value(description, type: "children")
		}

		if description.contains("cats") {
			cats = value(description, type: "cats")
		}

		if description.contains("samoyeds") {
			samoyeds = value(description, type: "samoyeds")
		}

		if description.contains("pomeranians") {
			pomeranians = value(description, type: "pomeranians")
		}

		if description.contains("akitas") {
			akitas = value(description, type: "akitas")
		}

		if description.contains("vizslas") {
			vizslas = value(description, type: "vizslas")
		}

		if description.contains("goldfish") {
			goldfish = value(description, type: "goldfish")
		}

		if description.contains("trees") {
			trees = value(description, type: "trees")
		}

		if description.contains("cars") {
			cars = value(description, type: "cars")
		}

		if description.contains("perfumes") {
			perfumes = value(description, type: "perfumes")
		}

		allSues[sueIndex] = Sue.init(children: children, cats: cats, samoyeds: samoyeds, pomeranians: pomeranians, akitas: akitas, vizslas: vizslas, goldfish: goldfish, trees: trees, cars: cars, perfumes: perfumes)
	}

	for key in allSues.keys.sorted() {

		let sue = allSues[key]!

		if sue.Part1IsThisSueMatchingAtLeastInThreeParams(targetSue) {
			print("Part 1 Possible Target Sue: \(key)")
		}

		if sue.Part2IsThisSueMatchingAtLeastInThreeParams(targetSue) {
			print("Part 2 Possible Target Sue: \(key)")
		}
	}
}


func value(_ string: String, type: String) -> Int {
	let step = string.components(separatedBy: "\(type): ").last!
	if step.contains(",") {
		return Int(step.components(separatedBy: ",").first!)!
	}

	return Int(step)!
}
