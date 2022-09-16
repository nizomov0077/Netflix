//
//  API CAller.swift
//  Netflix Clone
//
//  Created by Жавохир Низомов on 01/09/22.
//

import Foundation

struct Constant {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org/"
    static let YouTubeAPI_KEY = "AIzaSyDSvDL2PbXAAxAH7dzpVs3VKjAD5IAYUfc"
    static let YouTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
    //Trending Movies
    func getTrendingMovies(completion: @escaping (Result<[Movies], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)3/trending/movie/day?api_key=\(Constant.API_KEY)") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            do{
                let results = try JSONDecoder().decode(TrendingMoviesRespons.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //Trending Tv
    func getTrendingTvs(completion: @escaping(Result<[Movies], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)3/trending/tv/day?api_key=\(Constant.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesRespons.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
    
    //Upcoming Movies
    func getUpcomingMovies(completion: @escaping(Result<[Movies], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)3/movie/upcoming?api_key=\(Constant.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesRespons.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //Top Rated
    func getTopRated(completion: @escaping(Result<[Movies], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)3/movie/top_rated?api_key=\(Constant.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesRespons.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //Get Popular
    func getPopular(completion: @escaping(Result<[Movies], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)3/movie/popular?api_key=\(Constant.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesRespons.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //Get Discover
    func getDiscover(completion: @escaping(Result<[Movies], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)3/discover/movie?api_key=\(Constant.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingMoviesRespons.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
    
    //SearchResult
    func search(with query: String, completion: @escaping(Result<[Movies], Error>) -> Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constant.baseURL)3/search/movie?api_key=\(Constant.API_KEY)&query=\(query)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingMoviesRespons.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
    
    func getMovie(with query: String, comoletion: @escaping(Result<VideoElement, Error>) -> Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constant.YouTubeBaseURL)q=\(query)&key=\(Constant.YouTubeAPI_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                comoletion(.success(results.items[0]))
                print((results.items[0]))
            }catch{
                comoletion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
}
