import UIKit
import Foundation


struct Perk: Equatable {
	var cost: Int
	var damage: Int
	var armor: Int
	var name: String = ""
}

struct Stats {
	var hitPoints: Int
	var damage: Int
	var armor: Int
	var perks: [Perk] = []

	var extraDamage: Int {
		var count = 0

		for perk in perks {
			count += perk.damage
		}
		return count
	}

	var extraArmor: Int {
		var count = 0

		for perk in perks {
			count += perk.armor
		}
		return count
	}
}



var testPlayerStats = Stats.init(hitPoints: 8, damage: 5, armor: 5)
var testBossStats = Stats.init(hitPoints: 12, damage: 7, armor: 2)

didPlayerWin(testPlayerStats, enemy: testBossStats) // Yes, Remaining 2


let weaponsPerks = [ // Weapon is mandatory
		Perk.init(cost: 8, damage: 4, armor: 0, name: "Dagger"),
		Perk.init(cost: 10, damage: 5, armor: 0, name: "Shortsword"),
		Perk.init(cost: 25, damage: 6, armor: 0, name: "Warhammer"),
		Perk.init(cost: 40, damage: 7, armor: 0, name: "Longsword"),
		Perk.init(cost: 74, damage: 8, armor: 0, name: "Greataxe")
	]
let armorPerks = [ // Armor is optional
		Perk.init(cost: 0, damage: 0, armor: 0),
		Perk.init(cost: 13, damage: 0, armor: 1, name: "Leather"),
		Perk.init(cost: 31, damage: 0, armor: 2, name: "Chainmail"),
		Perk.init(cost: 53, damage: 0, armor: 3, name: "Splintmail"),
		Perk.init(cost: 75, damage: 0, armor: 4, name: "Bandedmail"),
		Perk.init(cost: 102, damage: 0, armor: 5, name: "Platemail")
	]

let ringsPerks = [ // Rings are optional
		Perk.init(cost: 0, damage: 0, armor: 0),
		Perk.init(cost: 25, damage: 1, armor: 0, name: "Damage +1"),
		Perk.init(cost: 50, damage: 2, armor: 0, name: "Damage +2"),
		Perk.init(cost: 100, damage: 3, armor: 0, name: "Damage +3"),
		Perk.init(cost: 20, damage: 0, armor: 1, name: "Defence +1"),
		Perk.init(cost: 40, damage: 0, armor: 2, name: "Defence +2"),
		Perk.init(cost: 80, damage: 0, armor: 3, name: "Defence +3")
	]


var leastSpentGold = -1
var leastSpentPerks = [Perk]()

var mostSpentGold = -1
var mostSpentPerks = [Perk]()

let inputEnemy = Stats.init(hitPoints: 104, damage: 8, armor: 1)

for weapon in weaponsPerks {

	for armor in armorPerks {

		for ring1 in ringsPerks {

			for ring2 in ringsPerks {

				if ring2 == ring1 || ring1 == ring2 {
					continue
				}

				let result = didPlayerWin(Stats.init(hitPoints: 100, damage: 0, armor: 0, perks:
					[weapon, armor, ring1, ring2]),
					enemy: inputEnemy)

				let goldRequired = weapon.cost + armor.cost + ring1.cost + ring2.cost

				if result == true {

					if leastSpentGold == -1 || leastSpentGold > goldRequired {
						leastSpentGold = goldRequired
						leastSpentPerks = [weapon, armor, ring1, ring2]
					}
				} else {

					if mostSpentGold < goldRequired {
						mostSpentGold = goldRequired
						mostSpentPerks = [weapon, armor, ring1, ring2]
					}
				}
			}
		}
	}
}

// 78
// Longsword = 40 coins
// Leather = 13 coins
// Damage +1 = 25 coins
print("Least spent Gold set to win: \(leastSpentGold)")
print("Perks used:\n")
for perk in leastSpentPerks {
	if perk.name.isEmpty == false {
		print("\(perk.name) = \(perk.cost) coins")
	}
}

// 148
// Dagger = 8 coins
// Damage +3 = 100 coins
// Defence +2 = 40 coins
print("\nMost spent Gold set to lose: \(mostSpentGold)")
print("Perks used:\n")
for perk in mostSpentPerks {
	if perk.name.isEmpty == false {
		print("\(perk.name) = \(perk.cost) coins")
	}
}


func didPlayerWin(_ player: Stats, enemy: Stats) -> Bool {

	var player = player
	var enemy = enemy

	repeat {

		enemy.hitPoints = enemy.hitPoints - max(1, player.damage + player.extraDamage - enemy.armor - enemy.extraArmor)

		if enemy.hitPoints > 0 {
			player.hitPoints = player.hitPoints - max(1, enemy.damage + enemy.extraDamage - player.armor - player.extraArmor)
		} else {
//			print("Player wins! Player remaining hitPoints: \(player.hitPoints)")
			return true
		}

		if player.hitPoints <= 0 {
//			print("Enemy wins! Enemy remaining hitPoints: \(enemy.hitPoints)")
			return false
		}

	} while player.hitPoints > 0 && enemy.hitPoints > 0

	return false
}
