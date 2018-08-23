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
    case medications
    case physicians
    case appointments
    case notes
    case supplies
    case logout
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}


class LeftMenuVC: UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menus = ["home", "cath schedule", "bowel history", "medications", "physicians", "appointments", "notes", "supplies", "logout"]
    var mainViewController: UIViewController!
    var cathViewController: UIViewController!
    var bowelViewController: UIViewController!
    var medicationsViewController: UIViewController!
    var physiciansViewController: UIViewController!
    var appointmentsViewController: UIViewController!
    var notesViewController: UIViewController!
    var suppliesViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor.lightGray
        tableView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        // 1 - Home
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        mainViewController = UINavigationController(rootViewController: mainVC)
        
        
        // 2 - Cath Schedule
        let cathTVC = storyboard.instantiateViewController(withIdentifier: "CathTVC") as! CathTVC
        cathViewController = UINavigationController(rootViewController: cathTVC)
        
        // 3 - Bowel History
        let bowelTVC = storyboard.instantiateViewController(withIdentifier: "BowelTVC") as! BowelTVC
        bowelViewController = UINavigationController(rootViewController: bowelTVC)
        
        // 4 - Medications
        let medicationTVC = storyboard.instantiateViewController(withIdentifier: "MedicationTVC") as! MedicationTVC
        medicationsViewController = UINavigationController(rootViewController: medicationTVC)
        
        // 5 - Physicians
        let physiciansVC = storyboard.instantiateViewController(withIdentifier: "PhysiciansTVC") as! PhysiciansTVC
        physiciansViewController = UINavigationController(rootViewController: physiciansVC)
        
        // 6 - Appointments
        let appointmentsVC = storyboard.instantiateViewController(withIdentifier: "AppointmentsTVC") as! AppointmentsTVC
        appointmentsViewController = UINavigationController(rootViewController: appointmentsVC)
        
        // 7 - Notes
        let notesVC = storyboard.instantiateViewController(withIdentifier: "NotesTVC") as! NotesTVC
        notesViewController = UINavigationController(rootViewController: notesVC)
        
        // 8 - Supplies
        let suppliesVC = storyboard.instantiateViewController(withIdentifier: "SuppliesTVC") as! SuppliesTVC
        suppliesViewController = UINavigationController(rootViewController: suppliesVC)
        
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
        case .medications:
            slideMenuController()?.changeMainViewController(medicationsViewController, close: true)
        case .appointments:
            slideMenuController()?.changeMainViewController(appointmentsViewController, close: true)
        case .logout:
            logout()
        case .notes:
            slideMenuController()?.changeMainViewController(notesViewController, close: true)
        case .physicians:
            slideMenuController()?.changeMainViewController(physiciansViewController, close: true)
        case .supplies:
            slideMenuController()?.changeMainViewController(suppliesViewController, close: true)
        }
    }
    
    func logout() {
        if let ex = slideMenuController() as? ExSlideMenuController, let coordinator = ex.coordinator {
            coordinator.isAuthenticated = false
        } else {
            //print("Could not get ExSlideMenuController to logout...")
            AppDelegate.getAppDelegate().showAlert("Error", "Sorry there was a problem logging out.")
        }
        self.goToInitialViewController()
    }
    
}

extension LeftMenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .cath, .bowel, .medications, .appointments, .logout, .notes, .physicians, .supplies:
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
            case .main, .bowel, .cath, .medications, .appointments, .logout, .notes, .physicians, .supplies:
                let cell = BaseTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
