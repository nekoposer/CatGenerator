//
//  ViewController.swift
//  CatGenerator
//
//  Created by salfetka on 01.11.2024.

import UIKit

class GenerateViewController: UIViewController {

    @IBOutlet weak var generateImage: UIImageView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var generateLabel: UILabel!
    @IBOutlet weak var generateIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var generateTextField: UITextField!
    
    @IBAction func onClickGenerateButton(_ sender: Any) {
        generateIndicator.startAnimating()
        generateButton.isEnabled = false
        downloadCat(with: generateTextField.text!)
    }
    
    private func downloadCat(with text: String) {
        guard let url = URL(string: "https://cataas.com/cat/says/\(text)?FontSize=50&fontColor=white") else {
                    return
                }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async { [weak self] in
                        self?.generateLabel.text = "Download error"
                        self?.generateIndicator.stopAnimating()
                        self?.generateButton.isEnabled = true
                    }
                    return
                }
                
                guard text != "" else {
                    DispatchQueue.main.async { [weak self] in
                        self?.generateLabel.text = "Download error"
                        self?.generateIndicator.stopAnimating()
                        self?.generateButton.isEnabled = true
                    }
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.generateImage.image = UIImage(data: data)
                    self?.generateLabel.text = "Downloading is succesfull!"
                    self?.generateIndicator.stopAnimating()
                    self?.generateButton.isEnabled = true
                }
            }
            
            task.resume()
        }
    
    private var activeTextField: UITextField?
    @objc func keyboardWillShow(notification: Notification) {
                guard let userInfo = notification.userInfo,
                      let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return
                }
                
                let keyboardHeight = keyboardFrame.height
                scrollView.contentInset.bottom = keyboardHeight
                scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
                
                // Прокручиваем scrollView, чтобы textField был виден
                if let activeField = activeTextField {
                    let visibleRect = scrollView.convert(activeField.frame, from: activeField.superview)
                    scrollView.scrollRectToVisible(visibleRect, animated: true)
                }
        }
        
        @objc func keyboardWillHide(notification: Notification) {
            // Возвращаем contentInset scrollView в исходное состояние
            scrollView.contentInset = .zero
            scrollView.scrollIndicatorInsets = .zero
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            activeTextField = textField
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            activeTextField = nil
        }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

