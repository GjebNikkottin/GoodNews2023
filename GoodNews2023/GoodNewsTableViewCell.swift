//
//  GoodNewsTableViewCell.swift
//  GoodNews2023
//
//  Created by Глеб on 30.08.2023.
//

import UIKit

class GoodNewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?
        //imageData: Data
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        //self.imageData = imageData
    }
        
}

class GoodNewsTableViewCell: UITableViewCell {
    static let identifier = "GoodNewsTableViewCell"
    
    private let goodNewsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let goodNewsSubtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let goodNewsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    } ()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(goodNewsTitleLabel)
        contentView.addSubview(goodNewsSubtitleLabel)
        contentView.addSubview(goodNewsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        goodNewsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 70
        )
        goodNewsSubtitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height/2
        )
        goodNewsImageView.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        goodNewsTitleLabel.text = nil
        goodNewsSubtitleLabel.text = nil
        goodNewsImageView.image = nil
    }
    
    func configure(with viewModel: GoodNewsTableViewCellViewModel) {
        goodNewsTitleLabel.text = viewModel.title
        goodNewsSubtitleLabel.text = viewModel.subtitle
        
        //Image
        if let data = viewModel.imageData {
            goodNewsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            //fetch
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data 
                DispatchQueue.main.async {
                    self?.goodNewsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
}
