//
//  ImageHelper.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
import UIKit

import AlamofireImage
import Alamofire
let placeHolderImage = "https://cdn.dribbble.com/users/576099/screenshots/3325183/scope_placeholder.jpg?compress=1&resize=400x300"
func setImageFromNetwork(url :String, imageView : UIImageView){
    
    AF.request(url).responseImage { response in
       

        if case .success(let image) = response.result {
       
            imageView.image = image
        }
    }
}
