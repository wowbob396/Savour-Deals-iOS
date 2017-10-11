//
//  DiscountViewController.swift
//  Savour
//
//  Created by Chris Patterson on 9/27/17.
//  Copyright © 2017 Chris Patterson. All rights reserved.
//

import UIKit
var newDeal: DealData!
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class DiscountViewController: UIViewController {
    var handler: AuthStateDidChangeListenerHandle!
    @IBOutlet weak var BOGOContainer: UIView!
    @IBOutlet weak var percentContainer: UIView!
    @IBOutlet weak var dollarContainer: UIView!
    @IBOutlet weak var segmentCont: UISegmentedControl!
    var BOGOvc: BogoController!
    var PercVC: PercentController!
    var DolVC: DollarController!
    var Dealtype: String!
    var resName: String!
    var deal: DealData!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if deal != nil{
            prevButton.setTitle("CANCEL", for: .normal)
            prevButton.setTitleColor(UIColor.red, for: .normal)
            newDeal = deal
            if (newDeal.dealDescription?.contains("$"))!{
                let strings = newDeal.dealDescription?.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: false)
                segmentCont.selectedSegmentIndex = 2
                DolVC.promoItem.text = "\(strings![2])"
                let dealTxt = "\(strings![0]) \(strings![1])"
                for i in 0..<DolVC.pickerView.numberOfRows(inComponent: 0){
                    if dealTxt == DolVC.pickerDataSource[i]{
                        DolVC.pickerView.selectRow(i, inComponent: 0, animated: true)
                    }
                }
            }
            else if (newDeal.dealDescription?.contains("%"))!{
                let strings = newDeal.dealDescription?.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: false)
                segmentCont.selectedSegmentIndex = 1
                PercVC.promoItem.text =  "\(strings![2])"
                let dealTxt = "\(strings![0]) \(strings![1])"
                for i in 0..<PercVC.pickerView.numberOfRows(inComponent: 0){
                    if dealTxt == PercVC.pickerDataSource[i]{
                        PercVC.pickerView.selectRow(i, inComponent: 0, animated: true)
                    }
                }
            }
            else{
                let strings = newDeal.dealDescription?.split(separator: " ", maxSplits: 5, omittingEmptySubsequences: false)
                segmentCont.selectedSegmentIndex = 0
                BOGOvc.promoText.placeholder =  "\(strings![5])"
            }
        }
        else{
            newDeal = DealData(ID: "")
            newDeal.dealType = Dealtype
            newDeal.restrauntName = self.resName
            newDeal.restrauntID = Auth.auth().currentUser?.uid
        }

        if segmentCont.selectedSegmentIndex == 0 {
            showBOGO()
        }
        else if segmentCont.selectedSegmentIndex == 1 {
            showPerc()
        }
        else if segmentCont.selectedSegmentIndex == 2 {
            showDollar()
        }
    }
    
    func showBOGO(){
        BOGOContainer.isHidden = false
        percentContainer.isHidden = true
        dollarContainer.isHidden = true
    }
    
    func showPerc(){
        BOGOContainer.isHidden = true
        percentContainer.isHidden = false
        dollarContainer.isHidden = true
    }
    
    func showDollar(){
        BOGOContainer.isHidden = true
        percentContainer.isHidden = true
        dollarContainer.isHidden = false
    }
    
    
    @IBAction func exitPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextPressed(_ sender: Any) {
        if segmentCont.selectedSegmentIndex == 0 {
            if BOGOvc.promoText.text == "" {
                let alert = UIAlertController(title: "Item Missing", message: "Please enter a promotion item to continue.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                newDeal?.dealDescription = "Buy One Get One Free \(BOGOvc.promoText.text!)"
                self.performSegue(withIdentifier: "datePick", sender: nil)
            }
        }
        else if segmentCont.selectedSegmentIndex == 1 {
            if PercVC.promoItem.text == "" {
                let alert = UIAlertController(title: "Item Missing", message: "Please enter a promotion item to continue.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                newDeal?.dealDescription  = "\(PercVC.pickerDataSource[PercVC.pickerView.selectedRow(inComponent: 0)]) \(PercVC.promoItem.text!)"
                self.performSegue(withIdentifier: "datePick", sender: nil)
            }
        }
        else if segmentCont.selectedSegmentIndex == 2 {
            if DolVC.promoItem.text == "" {
                let alert = UIAlertController(title: "Item Missing", message: "Please enter a promotion item to continue.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                newDeal?.dealDescription  = "\(DolVC.pickerDataSource[DolVC.pickerView.selectedRow(inComponent: 0)]) \(DolVC.promoItem.text!)"
                self.performSegue(withIdentifier: "datePick", sender: nil)
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if segmentCont.selectedSegmentIndex == 0 {
            showBOGO()
        }
        else if segmentCont.selectedSegmentIndex == 1 {
            showPerc()
        }
        else if segmentCont.selectedSegmentIndex == 2 {
            showDollar()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bogo"{
            BOGOvc = segue.destination as! BogoController
        }
        if segue.identifier == "perc"{
            PercVC = segue.destination as! PercentController
        }
        if segue.identifier == "doll"{
            DolVC = segue.destination as! DollarController
        }
    }
    @IBAction func prevPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}





class BogoController: UIViewController {
  
    @IBOutlet weak var promoText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}





class PercentController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerDataSource = [String]()
    
    @IBOutlet weak var promoItem: UITextField!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 1...12 {
            let percent = index * 5
            pickerDataSource.append("\(percent)% off")
        }
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
  
}






class DollarController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerDataSource = [String]()
    
    @IBOutlet weak var promoItem: UITextField!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for dollars in 1...50 {
            pickerDataSource.append("$\(dollars) off")
        }
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
}





class EndTimeController: UIViewController{
    @IBOutlet weak var EndPicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        if newDeal.endTime != nil{
            let date = Date(timeIntervalSince1970: newDeal.endTime!)
            EndPicker.setDate(date, animated: true)
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        newDeal?.endTime = EndPicker.date.timeIntervalSince1970
        self.performSegue(withIdentifier: "photo", sender: nil)
    }
    @IBAction func prevPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}



class StartTimeController: UIViewController{
    @IBOutlet weak var startPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if newDeal.startTime != nil{
            let date = Date(timeIntervalSince1970: newDeal.startTime!)
            startPicker.setDate(date, animated: true)
        }
        
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        newDeal?.startTime = startPicker.date.timeIntervalSince1970
        self.performSegue(withIdentifier: "date", sender: nil)
    }
    @IBAction func prevPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}




class PhotoSelectController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    var data = NSData()
    var ref: DatabaseReference!
    var storageRef: StorageReference!

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var selectPhoto: UIButton!
    @IBOutlet weak var rImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextBtn.isEnabled = false
        imagePicker.delegate = self
        self.ref = Database.database().reference()
        storageRef = StorageReference()
        if newDeal.restrauntPhoto != ""{
            self.nextBtn.isEnabled = true

            // Reference to an image file in Firebase Storage
            let storage = Storage.storage()
            let storageref = storage.reference(forURL: newDeal.restrauntPhoto!)
            // Reference to an image file in Firebase Storage
            let reference = storageref
                    
            // UIImageView in your ViewController
            let imageView: UIImageView = self.rImg
            
            // Placeholder image
            let placeholderImage = UIImage(named: "placeholder.jpg")
                    
            // Load the image using SDWebImage
            imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            
        }
    }
    @IBAction func nextPressed(_ sender: Any) {
        self.nextBtn.isEnabled = false
       let working = UIActivityIndicatorView()
        working.frame = rImg.frame
        working.activityIndicatorViewStyle = .whiteLarge  
        view.addSubview(working)
        working.color = UIColor.white
        working.startAnimating()
        self.ref.child("Deals").observeSingleEvent(of: .value, with: { (snapshot) in
            // set upload path for image
            if newDeal.dealID != nil {
                newDeal.dealID = "\(snapshot.childrenCount+1)"
            }
            let filePath = "Restaurants/\(Auth.auth().currentUser!.uid)/Photos/\(newDeal.dealID!)"
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).putData(self.data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    let alert = UIAlertController(title: "Upload Failed!", message: "Your image failed to upload to the database. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.rImg.image = nil
                    self.nextBtn.isEnabled = true

                }else{
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    newDeal.restrauntPhoto = downloadURL
                    self.performSegue(withIdentifier: "review", sender: nil)
                    self.nextBtn.isEnabled = true
                    working.stopAnimating()

                }
            }
            
        })

    }
    @IBAction func selectNewImgPressed(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            rImg.contentMode = .scaleToFill
            rImg.image = pickedImage
            dismiss(animated: true, completion: nil)
            data = UIImageJPEGRepresentation(rImg.image!, 0.8)! as NSData
            self.nextBtn.isEnabled = true

            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            rImg.contentMode = .scaleToFill
            rImg.image = pickedImage
            
            dismiss(animated: true, completion: nil)
            data = UIImageJPEGRepresentation(rImg.image!, 0.8)! as NSData
            self.nextBtn.isEnabled = true

        }
    }
        
            
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! ReviewController
        VC.img = self.rImg.image
    }
    @IBAction func prevPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}









class ReviewController: UIViewController{
    var ref: DatabaseReference!
    var img: UIImage!
    @IBOutlet weak var rImg: UIImageView!
    @IBOutlet weak var rName: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.ref = Database.database().reference()
        rImg.image = img
        rName.text = newDeal.restrauntName
        desc.text = newDeal.dealDescription
        let startD = Date(timeIntervalSince1970: newDeal.startTime!)
        let endD = Date(timeIntervalSince1970: newDeal.endTime!)
        let calendar = NSCalendar.current
        var year = calendar.component(.year, from: startD)
        var month = calendar.component(.month, from: startD)
        var day = calendar.component(.day, from: startD)
        startDate.text = "Start Date: \(month)/\(day)/\(year)"
        year = calendar.component(.year, from: endD)
        month = calendar.component(.month, from: endD)
        day = calendar.component(.day, from: endD)
        endDate.text = "End Date: \(month)/\(day)/\(year)"
        
    }
    @IBAction func submitDeal(_ sender: Any) {
        let deal = [
            "rID": newDeal.restrauntID!,
            "rName":  newDeal.restrauntName!,
            "dealDesc": newDeal.dealDescription!,
            "rPhotoLoc":   newDeal.restrauntPhoto!,
            "EndTime": newDeal.endTime!,
            "StartTime": newDeal.startTime!,
            "Filter": newDeal.dealType!
            ] as [String : Any]
        ref = Database.database().reference()
        ref.child("Deals").child(newDeal.dealID!).setValue(deal)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func prevPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}