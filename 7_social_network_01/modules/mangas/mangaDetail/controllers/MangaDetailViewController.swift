//
//  MangaDetailViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 25/7/22.
//

import UIKit

class MangaDetailViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var myRankLabel: UILabel!
    @IBOutlet weak var rankStackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var editButton: UIButton!
    
    var mangaId: String?
    var viewmodel: MangaDetailViewModel?
    let screenWidth = UIScreen.main.bounds.width - 10
    var selectedRow = 0
    var rateValues = ["1", "2", "3", "4" ,"5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        coverImageView.layer.cornerRadius = 10
        rankStackView.isHidden = true
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        let uiNib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        commentsTableView.register(uiNib, forCellReuseIdentifier: "CommentCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initViewModel()
    }
    
    func setupButton() {
        editButton.backgroundColor = .blue
        editButton.layer.cornerRadius = 28
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        
        editButton.setTitle("", for: .normal)
        
//        editButton.tintColor = .white
        editButton.layer.shadowColor = UIColor.black.cgColor
        editButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        editButton.layer.shadowOpacity = 0.5
        editButton.layer.shadowRadius = 3.0
        editButton.isHidden = true
    }
    
    func initViewModel() {
        viewmodel = MangaDetailViewModel(mangaId: mangaId!)
        viewmodel?.getManga()
        viewmodel?.getComments()
        viewmodel?.reloadComments = { [weak self] in
            self?.commentsTableView.reloadData()
        }
        viewmodel?.setData = { [weak self] in
            self?.setupData()
        }
    }
    
    func setupData() {
        titleLabel.text = viewmodel?.mangaData?.name
        descriptionLabel.text = viewmodel?.mangaData?.description
        categoriesLabel.text = viewmodel?.mangaData?.categories.joined(separator: ", ")
        rankLabel.text = String((viewmodel?.mangaData?.ratingAvg)!)
        myRankLabel.text = viewmodel?.myCurrentRank
        authorLabel.text = viewmodel?.mangaAuthor
        editButton.isHidden = !viewmodel!.isEditable
        rankStackView.isHidden = viewmodel!.isEditable
        ImageManager.shared.loadImage(from: URL(string: (viewmodel?.mangaData?.frontPage)!)!) { result in
            switch result {
            case .success(let image):
                self.coverImageView.image = image
            case .failure(let error):
                print("Can't display the image \(error)")
            }
        }
    }
    
    @IBAction func rateManga(_ sender: Any) {
        let auxVc = UIViewController()
        auxVc.preferredContentSize = CGSize(width: screenWidth, height: 100)
        let ratePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        ratePicker.delegate = self
        ratePicker.dataSource = self
        
        ratePicker.selectRow(selectedRow, inComponent: 0, animated: false)
        
        auxVc.view.addSubview(ratePicker)
        ratePicker.centerXAnchor.constraint(equalTo: auxVc.view.centerXAnchor).isActive = true
        ratePicker.centerYAnchor.constraint(equalTo: auxVc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Rate this manga", message: "Select a number", preferredStyle: .actionSheet)
        
        alert.setValue(auxVc, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {action in
            self.selectedRow = ratePicker.selectedRow(inComponent: 0)
            self.viewmodel?.rateManga(rating: self.selectedRow + 1)
        }))
        present(alert, animated: true)
    }
    
    @IBAction func leaveComment(_ sender: Any) {
        let alert = UIAlertController(title: "Leave a Comment", message: "Please Follow the community guidelines", preferredStyle: .alert)
        
        alert.addTextField{ (textField: UITextField) -> Void in
            textField.placeholder = "Add caption"
        }
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {action in
            
            if let textField = alert.textFields?.first {
                self.viewmodel?.createComment(content: textField.text!)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alert, animated: true)
    }
    
    @IBAction func editManga(_ sender: Any) {
        let vc = CreateMangaViewController()
        vc.isNew = false
        vc.mangaEdit = viewmodel?.mangaData
        show(vc, sender: nil)
    }
}

extension MangaDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = rateValues[row]
        label.sizeToFit()
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rateValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}

extension MangaDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (viewmodel?.comments.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell ?? CommentTableViewCell()
        
        let cellData = viewmodel?.getCellData(at: indexPath)
        
        
        cell.contentCommentLabel.text = cellData?.content
        
        viewmodel?.getUserName(for: cellData!) { user in
            cell.authorCommentLabel.text = user.name
        }
        
        return cell
    }
    
    
}
