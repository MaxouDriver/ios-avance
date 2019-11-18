//
//  HomeViewController.swift
//  RATP
//
//  Created by jpo on 18/11/2019.
//  Copyright © 2019 jpo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    lazy var lignes: [Int] = self.getMetroLines()
    
    func getMetroLines() -> [Int]{
        var temp: [Int] = []
        for i in 0...17 {
            temp.append(i + 1)
        }
        return temp
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lignes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Label", for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        self.present(homeViewController, animated: true, completion: nil)
    }
}
