//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Жавохир Низомов on 26/08/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var movie: [Movies] = [Movies]()
    
    private let searchBarController: UISearchController = {
        let serach = UISearchController(searchResultsController: SearchResultVC())
        serach.searchBar.searchBarStyle = .minimal
        serach.searchBar.placeholder = "Search for Movie or Tv"
        return serach
    }()
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifire)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchBarController
        navigationController?.navigationBar.tintColor = .label
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchTable)
        
        searchTable.dataSource = self
        searchTable.delegate = self
        
        fetchUpcoming()
        
        searchBarController.searchResultsUpdater = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }

    private func fetchUpcoming(){
        APICaller.shared.getDiscover { [weak self] results in
            switch results {
            case .success(let titles):
                self?.movie = titles
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, SearchResultVCDelegate{
    func searchResultVCDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifire, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        
        let titles = movie[indexPath.row]
        cell.configureUpcoming(with: UpcomingViewModel(titleName: titles.original_name ?? titles.original_title ?? "Unknown", poterURL: titles.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = movie[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, titleOverView: title.overview ?? "", youTubeVideo: videoElement))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
            !query.trimmingCharacters(in: .whitespaces).isEmpty,
            query.trimmingCharacters(in: .whitespaces).count >= 3,
            let resultController = searchController.searchResultsController as? SearchResultVC else {
                return
            
        }
        
            resultController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
//                    print(self.movie)
                    resultController.movie = titles
                    resultController.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
}
