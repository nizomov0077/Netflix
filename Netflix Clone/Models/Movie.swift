//
//  Movie.swift
//  Netflix Clone
//
//  Created by Жавохир Низомов on 02/09/22.
//

import Foundation

struct TrendingMoviesRespons: Codable {
    let results: [Movies]
}

struct Movies: Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let original_name: String?
    let poster_path: String?
    let release_date: String?
    let overview: String?
    let vote_average: Double
    let vote_count: Int
}
