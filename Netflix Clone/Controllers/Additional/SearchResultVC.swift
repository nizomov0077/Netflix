//
//  SearchResultVC.swift
//  Netflix Clone
//
//  Created by Жавохир Низомов on 03/09/22.
//

import UIKit

protocol SearchResultVCDelegate: AnyObject {
    func searchResultVCDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultVC: UIViewController {

    public var movie: [Movies] = [Movies]()
    
    public weak var delegate: SearchResultVCDelegate?
    
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
        
        
    }

}

extension SearchResultVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let title = movie[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = movie[indexPath.row]
        let titleName = title.original_title ?? ""
        let titleOverView = title.overview ?? ""
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchResultVCDidTapItem(TitlePreviewViewModel(title: titleName, titleOverView: titleOverView, youTubeVideo: videoElement))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}
