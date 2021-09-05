//
//  Difficulty.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 01/09/2021.
//

import Foundation

struct Difficulty {
    var lives: Int = Int.random(in: 1...6)
    var maxBalance: Float = Float.random(in: 0...0.5)
    var balanceSpeed: Float = Float.random(in: 1.0...3.0)
    var planeSpeed: Float = Float.random(in: 1.8...5.0)
}
