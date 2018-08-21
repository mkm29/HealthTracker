//
//  LeftMenuVC.swift
//
//
//  Created by Mitchell Murphy on 8/21/18.
//

import UIKit

enum LeftMenu: Int {
    case main = 0
    case cath
    case bowel
    case medication
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}


class LeftMenuVC: UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menus = ["home", "cath", "bowel", "medication", "logout"]
    var mainViewController: UIViewController!
    var cathViewController: UIViewController!
    var bowelViewController: UIViewController!
    var medicationsViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        mainViewController = UINavigationController(rootViewController: mainVC)
        //let cathNavVC = storyboard.instantiateViewController(withIdentifier: "CathNavVC") as! UINavigationController
        let cathTVC = storyboard.instantiateViewController(withIdentifier: "CathTVC") as! CathTVC
        cathViewController = UINavigationController(rootViewController: cathTVC)
        
        let bowelTVC = storyboard.instantiateViewController(withIdentifier: "BowelTVC") as! BowelTVC
        bowelViewController = UINavigationController(rootViewController: bowelTVC)
        
        let medicationTVC = storyboard.instantiateViewController(withIdentifier: "MedicationTVC") as! MedicationTVC
        medicationsViewController = UINavigationController(rootViewController: medicationTVC)
        
        imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main:
            slideMenuController()?.changeMainViewController(mainViewController, close: true)
        case .cath:
            slideMenuController()?.changeMainViewController(cathViewController, close: true)
        case .bowel:
            slideMenuController()?.changeMainViewController(bowelViewController, close: true)
        case .medication:
            slideMenuController()?.changeMainViewController(medicationsViewController, close: true)
        }
    }
    
}

extension LeftMenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .cath, .bowel, .medication:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView == scrollView {
            
        }
    }
    
}



extension LeftMenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .bowel, .cath, .medication:
                let cell = BaseTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
