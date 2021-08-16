//
//  SeasonsPickerViewController.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
import UIKit


class SeasonsPickerViewController : UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    var didSelectSeason : (_ season  : Season) -> Void = {_ in}
    
    var seasons = [Season]()
    
    override func viewDidLoad() {
        tableView.reloadData()
    }
    
}
extension SeasonsPickerViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let season = seasons[indexPath.row]
        didSelectSeason(season)
        dismiss(animated: true, completion: nil)
    }
}
extension SeasonsPickerViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
                }
                return cell
            }()
            
        cell.textLabel?.text = seasons[indexPath.row].title
            
        return cell
    }
    
    
}
