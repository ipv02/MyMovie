

import UIKit
import FirebaseAuth


class SignUpViewController: UIViewController {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var confirmPasswordTextfield: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var logInButton: UIButton!
    
    weak var delegate: AuthNavigatingDelegateProtocol?
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextfieldView()
        setupButtonView()
    }
    
    // MARK: - Private methods
    private func setupTextfieldView() {
        Utilities.styleTextfield(emailTextfield)
        Utilities.styleTextfield(passwordTextfield)
        Utilities.styleTextfield(confirmPasswordTextfield)
    }
    
    private func setupButtonView() {
        
        signUpButton.layer.cornerRadius = 7
        signUpButton.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        signUpButton.titleLabel?.textColor = .black
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        signUpButton.layer.shadowRadius = 4
        signUpButton.layer.shadowOpacity = 0.2
        signUpButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        logInButton.layer.cornerRadius = 7
        logInButton.backgroundColor = .white
        logInButton.titleLabel?.textColor = .black
        logInButton.layer.shadowColor = UIColor.black.cgColor
        logInButton.layer.shadowRadius = 4
        logInButton.layer.shadowOpacity = 0.2
        logInButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    //MARK: IB Action
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        AuthService.shared.register(email: emailTextfield.text,
                                    password: passwordTextfield.text,
                                    confirmPassword: confirmPasswordTextfield.text) { (result) in
            switch result {
            case .success(_):
                
                FirestoreService.shared.saveProfileWith(email: self.emailTextfield.text!,
                                                        password: self.passwordTextfield.text!) { (result) in
                    switch result {
                    case .success(let userModel):
                        print(userModel)
                    case .failure(let error):
                        print(error)
                    }
                }
                
                self.showAlert(with: "Success", and: "You are registered") {
                    self.performSegue(withIdentifier: "signUp", sender: nil)
                }
            case .failure(let error):
                self.showAlert(with: "Error!", and: error.localizedDescription)
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
}

//MARK: - Alert Controller
extension UIViewController {
    
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = {}) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
