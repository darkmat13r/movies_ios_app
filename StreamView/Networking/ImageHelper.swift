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
func setImageFromNetwork(url :String, imageView : UIImageView){
    
    AF.request(url).responseImage { response in
       

        if case .success(let image) = response.result {
       
            imageView.image = image
        }
    }
}
