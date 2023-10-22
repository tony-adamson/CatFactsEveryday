//
//  DataCatFact.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 23.09.2023.
//

import Foundation

struct DataCatFact: Decodable {
    var fact: String
    
    @frozen enum Contants {
        static let url = "https://catfact.ninja/fact"
    }
}

