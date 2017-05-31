//
//  PostSeshhVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import AVFoundation

class PostSeshhVC: UIViewController {
    
    @IBOutlet weak var titleTxtFld: UITextField!
    @IBOutlet weak var descriptionTxtFld: UITextField!
    @IBOutlet weak var clearPostBtn: UIBarButtonItem!
    @IBOutlet weak var drinksCategory: UIView!
    @IBOutlet weak var entertainmentCategory: UIView!
    @IBOutlet weak var activeCategory: UIView!
    @IBOutlet weak var musicCategory: UIView!
    @IBOutlet weak var recreationalCategory: UIView!
    @IBOutlet weak var sportsCategory: UIView!
    @IBOutlet weak var startDateBtn: UIButton!
    @IBOutlet weak var endDateBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var chooseCategoryView: UIView!
    @IBOutlet weak var drinksImg: UIImageView!
    @IBOutlet weak var entertainmentImg: UIImageView!
    @IBOutlet weak var activeImg: UIImageView!
    @IBOutlet weak var musicImg: UIImageView!
    @IBOutlet weak var recreationalImg: UIImageView!
    @IBOutlet weak var sportsImg: UIImageView!
    
    

    var selectedImg: UIImage?
    var videoUrl: URL?
    var selectedCategory: String?
    var buddies: [String] = []
    var postDict = [String: Any]()
    var dataReady = false
    
    override func viewDidLoad() { //PHOTO/VIDEO PICKER GESTURE
        super.viewDidLoad()
        postDict = [:]
        clearCategory()
        startDatePicker.isHidden = true
        endDatePicker.isHidden = true
        initGestures()
        customImgs()
    }
    
    override func viewWillAppear(_ animated: Bool) { //DNI
        super.viewWillAppear(animated)
    }
    
    func initGestures() {
        let drinksTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.drinksCategoryPicked))
        drinksCategory.addGestureRecognizer(drinksTapGesture)
        drinksCategory.isUserInteractionEnabled = true
        let entertainmentTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.entertainmentCategoryPicked))
        entertainmentCategory.addGestureRecognizer(entertainmentTapGesture)
        entertainmentCategory.isUserInteractionEnabled = true
        let activeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.activeCategoryPicked))
        activeCategory.addGestureRecognizer(activeTapGesture)
        activeCategory.isUserInteractionEnabled = true
        let musicTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.musicCategoryPicked))
        musicCategory.addGestureRecognizer(musicTapGesture)
        musicCategory.isUserInteractionEnabled = true
        let recreationalTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.recreationalCategoryPicked))
        recreationalCategory.addGestureRecognizer(recreationalTapGesture)
        recreationalCategory.isUserInteractionEnabled = true
        let sportsTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.sportsCategoryPicked))
        sportsCategory.addGestureRecognizer(sportsTapGesture)
        sportsCategory.isUserInteractionEnabled = true
        startDatePicker.addTarget(self, action: #selector(startDatePickerChanged(startDatePicker:)), for: UIControlEvents.valueChanged)
        endDatePicker.addTarget(self, action: #selector(endDatePickerChanged(endDatePicker:)), for: UIControlEvents.valueChanged)
    }
    
    func clearCategory() {
        selectedCategory = ""
        drinksCategory.backgroundColor = UIColor.clear
        entertainmentCategory.backgroundColor = UIColor.clear
        activeCategory.backgroundColor = UIColor.clear
        musicCategory.backgroundColor = UIColor.clear
        recreationalCategory.backgroundColor = UIColor.clear
        sportsCategory.backgroundColor = UIColor.clear
        categoryLbl.text = "Choose Seshh Category"
    }
    
    //NEED TO FACTORISE THIS.
    func customImgs() {
        drinksImg.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        drinksImg.layer.borderWidth = 1
        entertainmentImg.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        entertainmentImg.layer.borderWidth = 1
        activeImg.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        activeImg.layer.borderWidth = 1
        musicImg.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        musicImg.layer.borderWidth = 1
        recreationalImg.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        recreationalImg.layer.borderWidth = 1
        sportsImg.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        sportsImg.layer.borderWidth = 1
        
        drinksCategory.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        drinksCategory.layer.borderWidth = 1
        entertainmentCategory.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        entertainmentCategory.layer.borderWidth = 1
        activeCategory.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        activeCategory.layer.borderWidth = 1
        musicCategory.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        musicCategory.layer.borderWidth = 1
        recreationalCategory.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        recreationalCategory.layer.borderWidth = 1
        sportsCategory.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
        sportsCategory.layer.borderWidth = 1
    }
    
    func drinksCategoryPicked() {
        clearCategory()
        drinksCategory.backgroundColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1)
        selectedCategory = "drinks"
        categoryLbl.text = "Drinks"
    }
    
    func entertainmentCategoryPicked() {
        clearCategory()
        entertainmentCategory.backgroundColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1)
        selectedCategory = "entertainment"
        categoryLbl.text = "Entertainment"
    }
    
    func activeCategoryPicked() {
        clearCategory()
        activeCategory.backgroundColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1)
        selectedCategory = "active"
        categoryLbl.text = "Active"
    }
    
    func musicCategoryPicked() {
        clearCategory()
        musicCategory.backgroundColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1)
        selectedCategory = "music"
        categoryLbl.text = "Music"
    }
    
    func recreationalCategoryPicked() {
        clearCategory()
        recreationalCategory.backgroundColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1)
        selectedCategory = "recreational"
        categoryLbl.text = "Recreational"
    }
    
    func sportsCategoryPicked() {
        clearCategory()
        sportsCategory.backgroundColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1)
        selectedCategory = "sports"
        categoryLbl.text = "Sports"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //KEYBOARD DISMISS
        view.endEditing(true)
        
    }
    
    @IBAction func clearPostBtnPressed(_ sender: Any) { //DNI
        clearPost()
    }
    

    
    // CLEAR ALL CELLS IN POST - MAY NEED TO BE REMOVED
    
    func clearPost() { //DNI
        self.titleTxtFld.text = ""
        self.descriptionTxtFld.text = ""
        self.startDateBtn.setTitle("DD/MM/YYYY", for: UIControlState.normal)
        self.endDateBtn.setTitle("DD/MM/YYYY", for: UIControlState.normal)
        clearCategory()
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        checkInputFlds()
        if dataReady {
            let nextPostVC = storyboard?.instantiateViewController(withIdentifier: "PostSeshh2VC") as! PostSeshh2VC
            nextPostVC.passedDict = postDict
            navigationController?.pushViewController(nextPostVC, animated: true)
        } else {
            ProgressHUD.showError("All Fields Must Be Filled/Selected")
        }
    }
    
    func checkInputFlds() {
        guard let title = titleTxtFld.text, !title.isEmpty, let description = descriptionTxtFld.text, !description.isEmpty, let startDate = startDateBtn.titleLabel?.text, startDate != "DD/MM/YYYY", let endDate = endDateBtn.titleLabel?.text, endDate != "DD/MM/YYYY", let category = selectedCategory, !category.isEmpty else {
            // signUpBtn.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            nextBtn.isEnabled = false
            dataReady = false
            return
        }
        nextBtn.isEnabled = true
        addInputsToDict()
    }
    
    func addInputsToDict() {
        
        postDict["title"] = titleTxtFld.text
        postDict["description"] = descriptionTxtFld.text
        postDict["startDate"] = startDateBtn.titleLabel?.text
        postDict["endDate"] = endDateBtn.titleLabel?.text
        postDict["category"] = selectedCategory
        print("CONNOR: INPUTS ADDED TO DICT \(postDict)")
        dataReady = true
    }
    
    @IBAction func startDateBtnPressed(_ sender: Any) {
        startDatePicker.datePickerMode = UIDatePickerMode.date
        chooseCategoryView.isHidden = true
        nextBtn.isHidden = true
        startDatePicker.isHidden = false
    }
    
    @IBAction func endDateBtnPressed(_ sender: Any) {
        endDatePicker.datePickerMode = UIDatePickerMode.date
        chooseCategoryView.isHidden = true
        nextBtn.isHidden = true
        endDatePicker.isHidden = false
    }
    
    func startDateFormat() {
        
        let dateFormatter = DateFormatter()
        let short = DateFormatter.Style.short
        dateFormatter.dateStyle = short
        dateFormatter.dateFormat = "dd/MM/YYYY"
        let strDate = dateFormatter.string(from: startDatePicker.date)
        startDateBtn.titleLabel!.text = strDate
    }
    
    func endDateFormat() {
        
        let dateFormatter = DateFormatter()
        let short = DateFormatter.Style.short
        dateFormatter.dateStyle = short
        dateFormatter.dateFormat = "dd/MM/YYYY"
        let strDate = dateFormatter.string(from: endDatePicker.date)
        endDateBtn.titleLabel!.text = strDate
    }
    
    func startDatePickerChanged(startDatePicker:UIDatePicker) {
        
        startDateFormat()
        startDatePicker.isHidden = true
        chooseCategoryView.isHidden = false
        nextBtn.isHidden = false
    }
    
    func endDatePickerChanged(endDatePicker:UIDatePicker) {
        
        endDateFormat()
        endDatePicker.isHidden = true
        chooseCategoryView.isHidden = false
        nextBtn.isHidden = false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


