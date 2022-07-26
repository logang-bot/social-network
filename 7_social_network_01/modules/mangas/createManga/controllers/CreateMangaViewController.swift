//
//  CreateMangaViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 21/7/22.
//

import UIKit
import RadioGroup

class CreateMangaViewController: ImagePickerViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    
    var isEdditingPhoto = false
    var firebaseManager = FirebaseManager.shared
    let viewmodel = CreateMangaViewModel()
    var selectedCats = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        initViewModel()
        
        let uiNib = UINib(nibName: "OptionTableViewCell", bundle: nil)
        categoriesTableView.register(uiNib, forCellReuseIdentifier: "OptionCell")
    }
    
    
    @IBAction func selectPhoto(_ sender: Any) {
        showAddImageOptionAlert()
    }
    
    
    @IBAction func resetPhoto(_ sender: Any) {
        coverImageView.image = UIImage(named: "addImage")
        resetButton.isHidden = true
        isEdditingPhoto = false
    }
    
    @IBAction func createManga(_ sender: Any) {
        viewmodel.createManga(name: nameTextField.text!, description: descriptionTextField.text, categories: selectedCats, frontPage: coverImageView.image!) { 
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func initViewModel() {
        viewmodel.getCategories()
        viewmodel.reloadData = { [weak self] in
            self?.categoriesTableView.reloadData()
        }
    }
    
    override func setImage(data: Data) {
        coverImageView.image = UIImage(data: data)
        coverImageView.alpha = 1.0
        isEdditingPhoto = true
        resetButton.isHidden = false
    }
    
}

extension CreateMangaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionTableViewCell ?? OptionTableViewCell()
        
        let cellData = viewmodel.getCellData(at: indexPath)
        cell.setUpData(option: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentCell = tableView.cellForRow(at: indexPath) as! OptionTableViewCell
        let newCat = currentCell.toggleStatus()
        
        if newCat != "" {
            selectedCats.append(newCat)
        } else {
            selectedCats.removeAll(where: {$0 == newCat})
        }
    }
}
