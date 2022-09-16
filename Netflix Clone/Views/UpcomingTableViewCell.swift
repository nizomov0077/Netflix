//
//  UpcomingTableViewCell.swift
//  Netflix Clone
//
//  Created by Жавохир Низомов on 03/09/22.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {

    static let identifire = "cell"
    
    private let upcomingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleUpcoming: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.sizeToFit()
        title.preferredMaxLayoutWidth = 200
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(upcomingImage)
        contentView.addSubview(titleUpcoming)
        contentView.addSubview(playButton)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
        
            upcomingImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            upcomingImage.widthAnchor.constraint(equalToConstant: 100),
            upcomingImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            upcomingImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
        ])
        
        NSLayoutConstraint.activate([
        
            titleUpcoming.leadingAnchor.constraint(equalTo: upcomingImage.trailingAnchor, constant: 10),
            titleUpcoming.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
        
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
        
    }
    
    public func configureUpcoming(with model: UpcomingViewModel){
        guard let url = URL(string:"https://image.tmdb.org/t/p/w500/\(model.poterURL)") else {
            return
        }
        upcomingImage.sd_setImage(with: url, completed: nil)
        titleUpcoming.text = model.titleName
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


