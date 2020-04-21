//
//  DataTableCell.swift
//  Firebase Chat App
//
//  Created by AshutoshD on 06/04/20.
//  Copyright © 2020 ravindraB. All rights reserved.
//

import UIKit
import Kingfisher

class DataTableCell: UITableViewCell {
    
    @IBOutlet weak var lblFName: UILabel!
    @IBOutlet weak var lblLName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    
    var ChatModel : ChatModel?{
        didSet{
            lblFName.text = ChatModel?.firstName
            lblLName.text = ChatModel?.lastName
            let url = URL(string: (ChatModel!.profileUrl))
            if let url = url  as? URL {
                KingfisherManager.shared.retrieveImage(with: url as Resource , options: nil, progressBlock: nil) {(image, error, cache, imgUrl) in
                    self.imgView.image = image
                    self.imgView.kf.indicatorType = .activity
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
