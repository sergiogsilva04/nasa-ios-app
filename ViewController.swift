
import UIKit

class ViewController: UIViewController {
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .systemGreen
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(datePicker)
        datePicker.center = view.center 
    }
}

