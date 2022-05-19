//
//  PhotoTableViewCell.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import UIKit
import Kingfisher

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: CornerRadiusImage!
    
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(viewModel: PhotoCellViewModel) {
        
        if viewModel.isAdBanner {
            photoView.cornerRadiusValue = 0
            photoView.translatesAutoresizingMaskIntoConstraints = false
            leadingConstraint.constant = 0
            trailingConstraint.constant = 0
        }

        guard let imageURL = URL(string: viewModel.photoURL ?? "") else {return}
        photoView.kf.setImage(with: imageURL)

    }
    
}
