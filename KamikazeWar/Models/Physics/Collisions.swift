//
//  Collisions.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 07/05/2021.
//

import Foundation

struct Collisions: OptionSet {
    let rawValue: Int

    static let plane = Collisions(rawValue: 1 << 0)
    static let bullet = Collisions(rawValue: 1 << 1)
}
