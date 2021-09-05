//
//  UserDefaults+Extensions.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 27/08/2021.
//

import Foundation

extension UserDefaults {
    
    private enum Keys {
        static let highScore = "highScore"
    }
    
    var highScore: HighScore {
        get{
            if let data = UserDefaults.standard.data(forKey: Keys.highScore) {
                do {
                    let decoder = JSONDecoder()
                    let highScoreUpdated = try decoder.decode(HighScore.self, from: data)
                    
                    return highScoreUpdated
                } catch {
                    print("Unable to Decode HighScore (\(error))")
                }
            }
            return HighScore(score: 0, date: Date())
        }
        set{
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                setValue(data, forKey: Keys.highScore)
            } catch {
                print("Unable to Encode HighScore (\(error))")
            }
        }
    }
}


