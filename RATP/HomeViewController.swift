//
//  HomeViewController.swift
//  RATP
//
//  Created by jpo on 18/11/2019.
//  Copyright © 2019 jpo. All rights reserved.
//

import UIKit
import FirebaseCore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lignes: [Ligne] = []
    struct Ligne {
        let code, direction, station: String
        init(code: String, direction:String, station:String) {
            self.code=code
            self.direction = direction
            self.station = station
        }
    }
    
    @IBOutlet weak var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count reevaluted")
        print(lignes)
        print(lignes.count)
        return lignes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Label", for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    func addLine(code: String, direction: String, station: String) {
        
        
        var temp: [Ligne] = []
        temp.append(Ligne(code: code, direction: direction, station: station))
        self.lignes = temp
        print(self.lignes)
        self.table.reloadData()
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addStationViewController = storyBoard.instantiateViewController(withIdentifier: "addStationViewController") as! AddStationViewController
        addStationViewController.homeViewController = self
        self.present(addStationViewController, animated: true, completion: nil)
    }
}
