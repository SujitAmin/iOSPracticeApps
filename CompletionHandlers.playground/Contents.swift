import UIKit

class Firebase {
    func createUser(userName : String, password : String, completion : (Bool, Int) -> Void)  {
        //does something time consuming
        var isSuccess = true;
        var userId = 123
        completion(isSuccess, userId)
    }
}

class MyApp {
    func registerButtonPressed() {
        weak var firebase = Firebase()
        firebase?.createUser(userName: "SujitAmin", password: "123836", completion: { (isSuccess , userId) in
            print("Registration is Successful : \(isSuccess) \(userId)");
        })
    }
    
}
