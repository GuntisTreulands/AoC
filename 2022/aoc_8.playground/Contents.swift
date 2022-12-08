import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


doTask(test) // Part1: 21  Part2: 8
doTask(input) // Part1: 1832  Part2: 157320


class Tree {
	var height: Int
	var leftTree: Tree?
	var rightTree: Tree?
	var topTree: Tree?
	var bottomTree: Tree?

  func scenicIndex() -> Int {

    var leftIndex = 0
    var rightIndex = 0
    var topIndex = 0
    var bottomIndex = 0

    if let leftTree = leftTree {
      leftIndex = leftTree.checkLeftDistanceLargerThan(self.height)
    }

    if let rightTree = rightTree {
      rightIndex = rightTree.checkRightDistanceLargerThan(self.height)
    }

    if let topTree = topTree {
      topIndex = topTree.checkTopDistanceLargerThan(self.height)
    }

    if let bottomTree = bottomTree {
      bottomIndex = bottomTree.checkBottomDistanceLargerThan(self.height)
    }

    return leftIndex * rightIndex * topIndex * bottomIndex
  }

	func amIHidden() -> Bool {
		guard let leftTree = leftTree else {
			return false
		}
		guard let rightTree = rightTree else {
			return false
		}
		guard let topTree = topTree else {
			return false
		}
		guard let bottomTree = bottomTree else {
			return false
		}

		if leftTree.checkLeftTreeIfLargerThan(self.height) == false
			|| rightTree.checkRightTreeIfLargerThan(self.height) == false
			|| topTree.checkTopTreeIfLargerThan(self.height) == false
			|| bottomTree.checkBottomTreeIfLargerThan(self.height) == false {
			return false
		} else {
			return true
		}
	}

	func checkLeftTreeIfLargerThan(_ height: Int) -> Bool {

		if self.height >= height { return true }
		else if let leftTree = leftTree {
			return leftTree.checkLeftTreeIfLargerThan(height)
		} else {
			return false
		}
	}

	func checkRightTreeIfLargerThan(_ height: Int) -> Bool {
		if self.height >= height { return true }
		else if let rightTree = rightTree {
			return rightTree.checkRightTreeIfLargerThan(height)
		} else {
			return false
		}
	}

	func checkTopTreeIfLargerThan(_ height: Int) -> Bool {
		if self.height >= height { return true }
		else if let topTree = topTree {
			return topTree.checkTopTreeIfLargerThan(height)
		} else {
			return false
		}
	}

	func checkBottomTreeIfLargerThan(_ height: Int) -> Bool {
		if self.height >= height { return true }
		else if let bottomTree = bottomTree {
			return bottomTree.checkBottomTreeIfLargerThan(height)
		} else {
			return false
		}
	}


  func checkLeftDistanceLargerThan(_ height: Int) -> Int {

		if self.height >= height { return 1 }
		else if let leftTree = leftTree {
			return 1 + leftTree.checkLeftDistanceLargerThan(height)
		} else {
			return 1
		}
	}

  func checkRightDistanceLargerThan(_ height: Int) -> Int {

		if self.height >= height { return 1 }
		else if let rightTree = rightTree {
			return 1 + rightTree.checkRightDistanceLargerThan(height)
		} else {
			return 1
		}
	}

  func checkTopDistanceLargerThan(_ height: Int) -> Int {

		if self.height >= height { return 1 }
		else if let topTree = topTree {
			return 1 + topTree.checkTopDistanceLargerThan(height)
		} else {
			return 1
		}
	}

  func checkBottomDistanceLargerThan(_ height: Int) -> Int {

		if self.height >= height { return 1 }
		else if let bottomTree = bottomTree {
			return 1 + bottomTree.checkBottomDistanceLargerThan(height)
		} else {
			return 1
		}
	}


	init(height: Int) {
		self.height = height
	}
}


func doTask(_ string: String) {

	var grid = [[Tree]]()

	let treeLines = string.components(separatedBy: "\n")

	for treeLine in treeLines {
		if treeLine.isEmpty  { continue }

		grid.append(treeLine.map { Tree.init(height: Int(String($0))!) })
	}

	for rowIndex in 0..<grid.count {

		for columnIndex in 0..<grid[rowIndex].count {

			let currentItem = grid[rowIndex][columnIndex]

			if columnIndex < grid[rowIndex].count - 1 {
				let nextItem = grid[rowIndex][columnIndex+1]
				currentItem.rightTree = nextItem
			}

			if columnIndex > 0 {
				let previousItem = grid[rowIndex][columnIndex-1]
				currentItem.leftTree = previousItem
			}


			if rowIndex < grid.count - 1 {
				let bottomItem = grid[rowIndex + 1][columnIndex]
				currentItem.bottomTree = bottomItem
			}

			if rowIndex > 0 {
				let topItem = grid[rowIndex - 1][columnIndex]
				currentItem.topTree = topItem
			}

		}
	}


	let allTrees = grid.reduce([], +)

	let countOfVisibleTrees = allTrees.filter { $0.amIHidden() == false }


	print("Visible trees from outside: \(countOfVisibleTrees.count)\n")

	var maxSceenicIndex = 0

	for tree in allTrees {
		maxSceenicIndex = max(tree.scenicIndex(), maxSceenicIndex)
	}

	print("Max Scenic Index: \(maxSceenicIndex)")
}
