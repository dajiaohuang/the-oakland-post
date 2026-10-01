//
//  PostCell.swift
//  The Oakland Post
//
//  Custom UITableViewCell for posts.
//
//  Created by Andrew Clissold on 6/14/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!

    weak var delegate: StarButtonDelegate?

    var item: MWFeedItem! {
        didSet {
            // Set the thumbnail image.
            let placeholder = UIImage(named: "Placeholder")
            if let enclosures = item.enclosures where !enclosures.isEmpty,
                let dict = enclosures[0] as? NSDictionary,
                let type = dict["type"] as? String where type.hasPrefix("image"),
                let urlString = dict["url"] as? String,
                let URL = NSURL(string: urlString) {
                thumbnail.sd_setImageWithURL(URL, placeholderImage: placeholder)
            } else {
                thumbnail.image = placeholder
            }

            descriptionLabel.text = item.title

            // Figure out and set the date label.
            var time = -item.date.timeIntervalSinceNow / 60.0
            var unit = "m"
            if time >= 60.0 {
                time /= 60.0
                unit = "h"
                if time >= 24.0 {
                    time /= 24.0
                    unit = "d"
                }
            }
            dateLabel.text = "\(Int(time))\(unit) ago"

        }
    }

    @IBAction func starButtonPressed(sender: UIButton) {
        delegate?.didSelectStarButton(sender, forItem: item)
    }

    override func prepareForReuse() {
        starButton.selected = false
        super.prepareForReuse()
    }

}
