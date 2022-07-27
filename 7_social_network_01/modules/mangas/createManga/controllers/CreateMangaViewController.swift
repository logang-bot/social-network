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
    
    @IBOutlet weak var createButton: UIButton!
    
    var isEdditingPhoto = false
    var firebaseManager = FirebaseManager.shared
    let viewmodel = CreateMangaViewModel()
    var selectedCats = [String]()
    
    var isNew = true
    var mangaEdit: Manga?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        initViewModel()
        setupView()
        fillData()
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
        if isNew {
            viewmodel.createManga(name: nameTextField.text!, description: descriptionTextField.text, categories: selectedCats, frontPage: coverImageView.image!)
        } else {
            let newValues = [
                "name": nameTextField.text!,
                "description": descriptionTextField.text!,
                "categories": selectedCats
            ] as [String : Any]
            if isEdditingPhoto {
                viewmodel.updateFullManga(values: newValues, photo: coverImageView.image!)
            } else {
                viewmodel.updateManga(values: newValues)
            }
        }
    }
    
    func setupView() {
        if !isNew {
            createButton.setTitle("Update Manga", for: .normal)
            let trashImage = UIImage(systemName: "trash.fill")?.withRenderingMode(.alwaysOriginal)
            
            let trashButton = UIBarButtonItem(image: trashImage, style: .plain, target: self, action: #selector(showDeleteDialog))
            
            navigationItem.rightBarButtonItem = trashButton
        }
    }
    
    func fillData() {
        if !isNew, let manga = mangaEdit {
            viewmodel.manga = manga
            nameTextField.text = manga.name
            descriptionTextField.text = manga.description
            ImageManager.shared.loadImage(from: URL(string: manga.frontPage)!) { result in
                switch result {
                case .success(let image):
                    self.coverImageView.image = image
                case .failure:
                    print("cant fetch the image of the manga")
                }
            }
        }
    }
    
    @objc func showDeleteDialog() {
        DispatchQueue.main.async {
            let sheet = UIAlertController(title: "Are you sure you want to delete this manga?", message: nil, preferredStyle: .alert)
            
            sheet.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                self.viewmodel.deleteManga()
                self.navigationController?.popViewController(animated: true)
            })
            
            sheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.navigationController?.present(sheet, animated: true, completion: nil)
            
        }
    }
    
    func initViewModel() {
        viewmodel.getCategories()
        viewmodel.finishEditing = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
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
        if !isNew {
            if (mangaEdit?.categories.contains(where: {$0 == cellData.name}))! {
                cell.toggleStatus()
                selectedCats.append(cellData.name)
            }
        }
        cell.setUpData(option: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentCell = tableView.cellForRow(at: indexPath) as! OptionTableViewCell
        let newCat = currentCell.toggleStatus()
        
        if currentCell.status {
            selectedCats.append(newCat)
        } else {
            print(newCat)
            selectedCats.removeAll(where: {$0 == newCat})
            print("removing")
            print(selectedCats)
        }
    }
}
