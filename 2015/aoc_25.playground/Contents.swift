import UIKit
import Foundation


var row = 0
var column = 0
var nextIteration = 0


let initial = 20151125
var nextCalculated = initial

var targetRow = 2978
var targetColumn = 3083


for _ in 0...targetRow * targetColumn {

	if row == 0 {

		nextIteration += 1
		row = nextIteration
		column = 0

	} else {
		row -= 1
		column += 1
	}

	nextCalculated = nextCalculated*252533 % 33554393

	if row+1 == targetRow && column+1 == targetColumn {
		print("Row \(row+1), Column \(column+1) = \(nextCalculated)")
		break
	}
}

