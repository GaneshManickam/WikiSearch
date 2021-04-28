//
//  HomeTableViewCell.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HomeTableViewCell {
    /**
     Function to load data into the ui
     - PARAMETER data: Instance of `SearchResponsePages`
     */
    func loadDataIntoUI(_ data: SearchResponsePages) {
        self.titleLabel.text = data.title ?? " "
        self.itemImageView.image = UIImage(named: "ic_default_placeholder")
        if let imgUrl = URL(string: data.thumbnail?.source ?? "") {
            self.itemImageView.kf.setImage(with: imgUrl)
        }
        if let subTitleText = data.terms?.descriptionArray?.first {
            self.subTitleLabel.text = subTitleText
        } else {
            self.subTitleLabel.text = " "
        }
    }
    /**
     Function to load data into ui
     - PARAMETER data: Instance of `RecentlyViewed`
     */
    func loadDataIntoUI(_ data: RecenltyViewed) {
        self.titleLabel.text = data.titleValue
        self.itemImageView.image = UIImage(named: "ic_default_placeholder")
        if let imgUrl = URL(string: data.imageUrl) {
            self.itemImageView.kf.setImage(with: imgUrl)
        }
        self.subTitleLabel.text = data.subTitleValue.isEmpty ? " " : data.subTitleValue
    }
}
