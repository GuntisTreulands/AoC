import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


calculateDistanceForEachParticipant(test, forSeconds: 1000) // 1120  .. 689
calculateDistanceForEachParticipant(input, forSeconds: 2503) // 2696 .. 1084




struct Reindeer {
	let name: String
	let speed: Int
	let flyTime: Int
	let restTime: Int
	var pointsEarned: Int

	func currentDistance(from time: Int) -> Int {
		var length = time

		var flyingTime = 0
		var restingTime = 0
		var isFlying = true

		repeat {
			if isFlying {
				if length >= flyTime {
					length -= flyTime
					flyingTime += flyTime
				} else {
					flyingTime += length
					length -= length
				}

			} else {
				if length >= restTime {
					length -= restTime
					restingTime += restTime
				} else {
					restingTime += length
					length -= length
				}
			}

			isFlying.toggle()

		} while length > 0

		return flyingTime * speed
	}
}



func calculateDistanceForEachParticipant(_ string: String, forSeconds: Int) {

	let input = string.components(separatedBy: "\n")

	var participants = [Reindeer]()

	var results = [String: Int]()

	for description in input {
		if description.isEmpty {
			continue
		}

		// Get params

		let participantName = description.components(separatedBy: " can").first!
		let speed = Int(description.components(separatedBy: " km").first!.components(separatedBy: "fly ").last!)!
		let flyTime = Int(description.components(separatedBy: " seconds,").first!.components(separatedBy: "for ").last!)!
		let restTime = Int(description.components(separatedBy: " seconds.").first!.components(separatedBy: "rest for ").last!)!

		let reindeer = Reindeer.init(name: participantName, speed: speed, flyTime: flyTime, restTime: restTime, pointsEarned: 0)

		participants.append(reindeer)


		// Calculate total traveled distance
		results[participantName] = reindeer.currentDistance(from: forSeconds)
	}

	// Now calculate score for appropriate reindeers at each second (after first second)
	for second in 1..<forSeconds {

		var topDistance = 0

		for reindeer in participants {
			topDistance = max(topDistance, reindeer.currentDistance(from: second))
		}

		var newArray = [Reindeer]()

		for var reindeer in participants {
			if reindeer.currentDistance(from: second) == topDistance {
				reindeer.pointsEarned += 1
			}

			newArray.append(reindeer)
		}

		participants = newArray
	}

	// Results...

	print("Distance results \(results)")

	print("Best travel distance \(results.values.sorted().last!)")

	var topScore = 0

	for reindeer in participants {
		topScore = max(topScore, reindeer.pointsEarned)
		print("\(reindeer.name) - Earned points: \(reindeer.pointsEarned)")
	}

	print("Top score \(topScore)")
}
