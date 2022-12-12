import UIKit
import Foundation
import GameplayKit


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

var alphabeth = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

//doTask(test) // Part1: 31   Part2: 29
doTask(input) // Part1: 449   Part2: 443

class RoadPost: Equatable {
	static func == (lhs: RoadPost, rhs: RoadPost) -> Bool {
		if lhs.x > rhs.x || lhs.y > rhs.y {
			return false
		}

		return true
	}

	var name: String
	var x: Int
	var y: Int

	var identificator: String {
		return "\(x)-\(y)"
	}

	init(name: String, x: Int, y: Int) {
		self.name = name
		self.x = x
		self.y = y
	}
}

func doTask(_ string: String) {

	let instructions = string.components(separatedBy: "\n")

	var startRoadPost: RoadPost!
	var targetRoadPost: RoadPost!

	var roadPosts: [String:RoadPost] = [:]
	var startRoadPosts: [RoadPost] = []

	var y = 0


	for instruction in instructions {
		if instruction.isEmpty  { continue }

		var x = 0

		for roadPost in instruction {
			let roadPost = RoadPost.init(name: "\(roadPost)", x: x, y: y)

			x += 1

			if roadPost.name == "S" {
				roadPost.name = "a"
				startRoadPost = roadPost
			}

			if roadPost.name == "a" {
				startRoadPosts.append(roadPost)
			}

			if roadPost.name == "E" {
				roadPost.name = "z"
				targetRoadPost = roadPost
			}

			roadPosts[roadPost.identificator] = roadPost
		}

		y += 1
	}

	let maxLineCount = instructions.first!.count
	let maxColumnCount = maxColumnCount


	var nodes = [String: MyNode]()

	for roadPost in roadPosts.values {
		let node = MyNode.init(name: roadPost.identificator)
		nodes[roadPost.identificator] = node
	}


	for roadPost in roadPosts.values {
		let roadPostWeight = alphabeth.firstIndex(of: roadPost.name)!
		let currentNode = nodes[roadPost.identificator]!
		
		if roadPost.x > 0 {
			let tmpRoadPost = roadPosts["\(roadPost.x-1)-\(roadPost.y)"]!
			let targetNode = nodes[tmpRoadPost.identificator]!
			let tmpRoadPostWeight = alphabeth.firstIndex(of: tmpRoadPost.name)!
			if roadPostWeight + 1 >= tmpRoadPostWeight {
				currentNode.addConnection(to: targetNode, bidirectional: false, weight: Float(1))
			}
		}

		if roadPost.x < maxLineCount - 1 {
			let tmpRoadPost = roadPosts["\(roadPost.x+1)-\(roadPost.y)"]!
			let targetNode = nodes[tmpRoadPost.identificator]!
			let tmpRoadPostWeight = alphabeth.firstIndex(of: tmpRoadPost.name)!
			if roadPostWeight + 1 >= tmpRoadPostWeight {
				currentNode.addConnection(to: targetNode, bidirectional: false, weight: Float(1))
			}
		}

		if roadPost.y > 0 {
			let tmpRoadPost = roadPosts["\(roadPost.x)-\(roadPost.y-1)"]!
			let targetNode = nodes[tmpRoadPost.identificator]!
			let tmpRoadPostWeight = alphabeth.firstIndex(of: tmpRoadPost.name)!
			if roadPostWeight + 1 >= tmpRoadPostWeight {
				currentNode.addConnection(to: targetNode, bidirectional: false, weight: Float(1))
			}
		}

		if roadPost.y < maxColumnCount - 1 {
			let tmpRoadPost = roadPosts["\(roadPost.x)-\(roadPost.y+1)"]!
			let targetNode = nodes[tmpRoadPost.identificator]!
			let tmpRoadPostWeight = alphabeth.firstIndex(of: tmpRoadPost.name)!
			if roadPostWeight + 1 >= tmpRoadPostWeight {
				currentNode.addConnection(to: targetNode, bidirectional: false, weight: Float(1))
			}
		}

		nodes[roadPost.identificator] = currentNode
	}

	print("startRoadPost.identificator \(startRoadPost.identificator)")
	print("targetRoadPost.identificator \(targetRoadPost.identificator)")

	let startNode: MyNode = nodes[startRoadPost.identificator]!
	let endNode: MyNode = nodes[targetRoadPost.identificator]!

	let myGraph = GKGraph()

	let allNodes = Array(nodes.values)

	myGraph.add(allNodes)

	let path = myGraph.findPath(from: startNode, to: endNode)

	print("Path from \(allNodes.first!.name) to \(allNodes.last!.name):")

	var nodeNames: [String] = []
	var nodeCosts: [Float] = []

	path.flatMap({ $0 as? MyNode}).forEach { node in
		nodeNames.append(node.name)
	}

	var total: Float = 0

	if path.isEmpty == false {
		for i in 0..<(path.count-1) {
			total += path[i].cost(to: path[i+1])
			nodeCosts.append(path[i].cost(to: path[i+1]))

			print("Node: \((path[i] as! MyNode).name) to: \((path[i+1] as! MyNode).name) =  Price: \(path[i].cost(to: path[i+1]))")
		}

		print("Total cost \(total), Total Steps: \(nodeCosts.count)")
	} else {
		print("Could not determine path")
	}


	// PART 2

	var shortestPathSteps: Int = nodeCosts.count

	print("startRoadPosts count: \(startRoadPosts.count)")
	var index = 0
	for roadPost in startRoadPosts {
		print("Start \(index+1) of \(startRoadPosts.count)")
		index += 1
		let tmpStartNode = nodes[roadPost.identificator]!
		let path = myGraph.findPath(from: tmpStartNode, to: endNode)

		if path.isEmpty == false {

			print("Total Steps: \(path.count-1)")

			shortestPathSteps = min(path.count-1, shortestPathSteps)
		} else {
			//print("Could not determine path")
		}
	}

	print("shortestPathSteps: \(shortestPathSteps)")
}


class MyNode: GKGraphNode {
	let name: String
  	var travelCost: [GKGraphNode: Float] = [:]

  	init(name: String) {
    	self.name = name
    	super.init()
  	}

  	required init?(coder aDecoder: NSCoder) {
    	self.name = ""
    	super.init()
  	}

  	override func cost(to node: GKGraphNode) -> Float {
    	return travelCost[node] ?? 0
  	}

  	func addConnection(to node: GKGraphNode, bidirectional: Bool = true, weight: Float) {
   		self.addConnections(to: [node], bidirectional: bidirectional)
    	travelCost[node] = weight
    	guard bidirectional else { return }
    	(node as? MyNode)?.travelCost[self] = weight
  	}
}
