//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Жавохир Низомов on 26/08/22.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Upcoming = 2
    case Popular = 3
    case TopRarted = 4
}

class HomeViewController: UIViewController {

    private var randomTrendingMovies: Movies?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending movies", "Popular", "Trending Tv", "Upcoming Movies", "Top rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView( frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        
        configureNavBar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        
        configureHeroHeaderView()
        
    }
    
    //MARK: Function random photo HeaderImageView
    private func configureHeroHeaderView() {
        
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
                
            case .success(let title):
                let selectedTitle = title.randomElement()
                self?.randomTrendingMovies = selectedTitle
                self?.headerView?.configure(with: UpcomingViewModel(titleName: selectedTitle?.original_title ?? "", poterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar(){
        var image = UIImage(named: "netflix_logo")
        
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
            
        ]
        navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
            
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { results in
                switch results{
                case.success(let movies):
                    cell.configure(with: movies)
                case.failure(let error):
                    print(error.localizedDescription)
                }
        }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { results in
                switch results{
                case.success(let tv):
                    cell.configure(with: tv)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { results in
                switch results{
                case.success(let popular):
                    cell.configure(with: popular)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { results in
                switch results {
                case .success(let upComing):
                    cell.configure(with: upComing)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRarted.rawValue:
            APICaller.shared.getTopRated { results in
                switch results {
                case .success(let topRated):
                    cell.configure(with: topRated)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header = view as? UITableViewHeaderFooterView else {return}
//        
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaulyOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaulyOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
  
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
