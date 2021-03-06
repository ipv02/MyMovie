
import UIKit
import GoogleSignIn
import FirebaseAuth


class LoginViewController: UIViewController {
    
    @IBOutlet var googleButton: UIButton!
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    weak var delegate: AuthNavigatingDelegateProtocol?
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.styleTextfield(emailTextfield)
        Utilities.styleTextfield(passwordTextfield)
        
        setupButtonView()
    }
    
    
    // MARK: - Private methods
    private func setupButtonView() {
        
        googleButton.layer.cornerRadius = 7
        googleButton.backgroundColor = .white
        googleButton.titleLabel?.textColor = .black
        googleButton.layer.shadowColor = UIColor.black.cgColor
        googleButton.layer.shadowRadius = 4
        googleButton.layer.shadowOpacity = 0.2
        googleButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        googleButton.customizeGoogleButton()
        
        loginButton.layer.cornerRadius = 7
        loginButton.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        loginButton.titleLabel?.textColor = .black
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowRadius = 4
        loginButton.layer.shadowOpacity = 0.2
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        signUpButton.layer.cornerRadius = 7
        signUpButton.backgroundColor = .white
        signUpButton.titleLabel?.textColor = .black
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        signUpButton.layer.shadowRadius = 4
        signUpButton.layer.shadowOpacity = 0.2
        signUpButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    //MARK: - IB Action
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        AuthService.shared.login(email: emailTextfield.text!,
                                 password: passwordTextfield.text!) { (result) in
            switch result {
            case .success(_):
                self.showAlert(with: "Success!", and: "You are logged in!") {
                    self.performSegue(withIdentifier: "loginVC", sender: nil)
                }
            case .failure(let error):
                self.showAlert(with: "Error!", and: error.localizedDescription)
            }
        }
    }
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()

    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
}
