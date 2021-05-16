//
//  CryptoTableViewCell.swift
//  CryptoTrack
//
//  Created by Zhanibek Lukpanov on 11.05.2021.
//

import UIKit
import SDWebImage

class CryptoTableViewCell: UITableViewCell {
  
    static let reuseID = "CryptoTableViewCell"
    
    // MARK:- Properties
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    private let symbolLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .systemGreen
        label.textAlignment = .right
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK:- Initializators
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(iconImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        symbolLabel.sizeToFit()
        
        let size: CGFloat = contentView.frame.size.height/1.1
        
        nameLabel.frame = CGRect(x: 29 + size, y: 0, width: contentView.frame.size.width/2, height: contentView.frame.size.height/2)
        
        symbolLabel.frame = CGRect(x: 29 + size, y: contentView.frame.size.height/2, width: contentView.frame.size.width/2, height: contentView.frame.size.height/2)
        
        priceLabel.frame = CGRect(x: contentView.frame.size.width/2, y:0, width: (contentView.frame.size.width/2)-29, height: contentView.frame.size.height)
        
        iconImageView.frame = CGRect(x: 20, y: (contentView.frame.size.height-size)/2, width: size, height: size)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        iconImageView.image = nil
    }
    
    func configure(viewModel: CryptoTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        symbolLabel.text = viewModel.symbol
        guard let url = viewModel.iconUrl else { return }
        iconImageView.sd_setImage(with: url, completed: nil)
    }
    
}
