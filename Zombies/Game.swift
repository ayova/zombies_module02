//
//  Game.swift
//  Zombies
//
//  Created by Adrian Tineo on 05.02.20.
//  Copyright © 2020 Adrian Tineo. All rights reserved.
//

import Foundation

enum Direction {
    case up
    case down
    case left
    case right
}

struct Game {
    private var grid: [[String]]
    private var zombiesPositions: [(Int,Int)] = []
    // available chars are:
    // ⬜️ = ground
    // ⬛️ = darkness
    // 🚶‍♂️ = player
    // 🧟 = zombie
    // 🆘 = exit
    // 🚧 = obstacle (optional)
    // 🔦 = flashlight (optional)
    
    // MARK : initializer
    init() {
        grid = [["🆘", "⬜️", "⬜️", "⬜️", "⬜️"],
                ["⬜️", "⬜️", "⬜️", "⬜️", "⬜️"],
                ["⬜️", "⬜️", "⬜️", "⬜️", "⬜️"],
                ["⬜️", "⬜️", "⬜️", "⬜️", "⬜️"],
                ["⬜️", "⬜️", "⬜️", "⬜️", "🚶‍♂️"]]
        
        placeZombies()
    }
    
    // MARK: private methods
    private mutating func placeZombies() {
        // TODO: place zombies according to given rules
        var numberOfZombies = 0
        while numberOfZombies < 2 { // number of zombies to create
            let zombieXPosition = Int.random(in: 0...4)
            let zombieYPosition = Int.random(in: 0...4)
            let zombiePosition = (zombieXPosition,zombieYPosition)
            switch zombiePosition {
            case (0,0): break
            case (0,1): break
            case (1,0): break
            case (1,1): break
            case (4,4): break
            case (4,3): break
            case (3,4): break
            case (3,3): break
            default:
                zombiesPositions.insert(zombiePosition, at: numberOfZombies)
                numberOfZombies += 1 // add 1 AFTER insert - otherwise, inserts into the wrong place
                print("Zombie position: \(numberOfZombies) - \(zombiePosition)") // uncomment for debugging only
            }
        }
    }
    
    private var playerPosition: (Int, Int) {
        for (x, row) in grid.enumerated() {
            for (y, square) in row.enumerated() {
                if square == "🚶‍♂️" {
                    return (x, y)
                }
            }
        }
        fatalError("We lost the player!")
    }
    
    private mutating func updateSquare(_ x: Int, _ y: Int, _ content: String) {
        // FIXME: this can crash
        // fix: guard against 'out of range'
        guard x <= 4 && x >= 0 && y <= 4 && y >= 0 else { return }
        grid[x][y] = content
    }
    
    // MARK: public API
    mutating func movePlayer(_ direction: Direction) {
        precondition(canPlayerMove(direction))
        
        // move player
        let (x, y) = playerPosition
        updateSquare(x, y, "⬜️")
        switch direction {
        case .up:
            updateSquare(x-1, y, "🚶‍♂️")
        case .down:
            updateSquare(x+1, y, "🚶‍♂️")
        case .left:
            updateSquare(x, y-1, "🚶‍♂️")
        case .right:
            updateSquare(x, y+1, "🚶‍♂️")
        }
    }
    
    func canPlayerMove(_ direction: Direction) -> Bool {
        // FIXME: this is buggy
        // fix: check actual values
        let (x, y) = playerPosition
        switch direction {
        case .up:
            if grid.indices.contains(x-1) {
                return true
            }
        case .down:
            if grid.indices.contains(x+1) {
                return true
            }
        case .left:
            if grid[x].indices.contains(y-1) {
                return true
            }
        case .right:
            if grid[x].indices.contains(y+1) {
                return true
            }
        }
        return false
    }
    
    var visibleGrid: [[String]] {
        // TODO: give a grid where only visible squares are copied, the rest
        // should be seen as ⬛️
        
        var visibleGrid: [[String]] = grid
        let (playerX, playerY) = playerPosition
        let cellAbove = (playerX-1,playerY)
        let cellBelow = (playerX+1,playerY)
        let cellLeft = (playerX,playerY-1)
        let cellRight = (playerX,playerY+1)
        for (x, row) in visibleGrid.enumerated() {
            for (y,_) in row.enumerated() {
                visibleGrid[x][y] = "⬛️"
                visibleGrid[0][0] = "🆘"
                visibleGrid[playerX][playerY] = "🚶‍♂️"
                if (x,y) == cellAbove || (x,y) == cellBelow || (x,y) == cellLeft || (x,y) == cellRight {
                    if (x,y) == zombiesPositions[0] || (x,y) == zombiesPositions[1] {
                        visibleGrid[x][y] = "🧟"
                    } else {
                    visibleGrid[x][y] = "⬜️"
                    }
                }
            }
        }
        
        return visibleGrid
    }
    
    var hasWon: Bool {
        // FIXME: player cannot win, why?
        // fix: only one is needed to win, hence, || instead of &&
        if grid[0][1] == "🚶‍♂️" || grid[1][0] == "🚶‍♂️" {
            return true
        }
        return false
    }
    
    var hasLost: Bool {
        // TODO: calculate when player has lost (when revealing a zombie)
        let (x,y) = playerPosition
        if  (x+1,y) == zombiesPositions[0] || (x+1,y) == zombiesPositions[1] {
            return true
        }
        if (x-1,y) == zombiesPositions[0] || (x-1,y) == zombiesPositions[1] {
            return true
        }
        if (x,y+1) == zombiesPositions[0] || (x,y+1) == zombiesPositions[1] {
            return true
        }
        if (x,y-1) == zombiesPositions[0] || (x,y-1) == zombiesPositions[1] {
            return true
        }
        return false
    }
}
