//
//  CreateMangaViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 21/7/22.
//

import UIKit
import SVProgressHUD

class CreateMangaViewController: ImagePickerViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    var blurredBackgroundView: BlurredBackground?
    var isEdditingPhoto = false
    let viewmodel = CreateMangaViewModel()
    var selectedCats = [String]()
    var currentPhoto: UIImage?
    
    var isNew = true
    var mangaEdit: Manga?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettings()
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        showAddImageOptionAlert()
    }
    
    @IBAction func resetPhoto(_ sender: Any) {
        if isNew {
            coverImageView.image = UIImage(named: "addImage")
        }
        else {
            coverImageView.image = currentPhoto
        }
        resetButton.isHidden = true
        isEdditingPhoto = false
    }
    
    @IBAction func createManga(_ sender: Any) {
        guard isEdditingPhoto == true else {
            ErrorAlert.shared.showAlert(title: "Not allowed", message: "Please choose a cover image for your manga", target: self)
            return
        }
        if isNew {
            SVProgressHUD.show()
            self.blurredBackgroundView?.isHidden = false
            viewmodel.createManga(name: nameTextField.text!, description: descriptionTextField.text, categories: selectedCats, frontPage: coverImageView.image!)
        } else {
            ConfirmAlert(title: "Are you sure you want to upload these changes?", message: "", preferredStyle: .alert).showAlert(target: self) { () in
                SVProgressHUD.show()
                self.blurredBackgroundView?.isHidden = false
                let newValues = [
                    "name": self.nameTextField.text!,
                    "description": self.descriptionTextField.text!,
                    "categories": self.selectedCats
                ] as [String : Any]
                if self.isEdditingPhoto {
                    self.viewmodel.updateFullManga(values: newValues, photo: self.coverImageView.image!)
                } else {
                    self.viewmodel.updateManga(values: newValues)
                }
            }
        }
    }
    
    func setupSettings() {
        resetButton.isHidden = true
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        initViewModel()
        setupView()
        fillData()
        let uiNib = UINib(nibName: OptionTableViewCell.nibName, bundle: nil)
        categoriesTableView.register(uiNib, forCellReuseIdentifier: OptionTableViewCell.identifier)
        blurredBackgroundView = BlurredBackground(parent: self)
        blurredBackgroundView?.isHidden = true
    }
    
    func initViewModel() {
        viewmodel.getCategories()
        viewmodel.finishEditing = { [weak self] in
            SVProgressHUD.dismiss()
            self!.blurredBackgroundView!.isHidden = true
            self?.navigationController?.popViewController(animated: true)
        }
        viewmodel.reloadData = { [weak self] in
            self?.categoriesTableView.reloadData()
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
                    self.currentPhoto = image
                case .failure:
                    print("cant fetch the image of the manga")
                }
            }
        }
    }
    
    @objc func showDeleteDialog() {
        ConfirmAlert(title: "Are you sure you want to delete this manga?", message: "This action can not be reversed", preferredStyle: .alert).showAlert(target: self) { () in
            self.viewmodel.deleteManga()
            self.navigationController?.popViewController(animated: true)
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
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.identifier, for: indexPath) as? OptionTableViewCell ?? OptionTableViewCell()
        
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
            selectedCats.removeAll(where: {$0 == newCat})
        }
    }
}
