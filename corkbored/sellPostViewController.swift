//
//  sellPostViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/19/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class sellPostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemConditionPicker: UIPickerView!
    @IBOutlet weak var itemDescription: UITextField!
    
    var itemCondition = ""
    
    var itemConditionArray = ["Perfect, like my body", "like new", "great", "good", "okay", "fair", "terrible, like my ex"]
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return itemConditionArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemConditionArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        itemCondition = itemConditionArray[row]
    }
    

  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
