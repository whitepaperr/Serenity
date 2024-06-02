import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let baseUrl = "https://serenity-8ffbd9b8a148.herokuapp.com/api/v1"
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            if let topController = self.getTopViewController() {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                topController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func getTopViewController() -> UIViewController? {
        guard let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow }).first else {
                return nil
        }
        
        var topController = window.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
    
    // Login
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseUrl)/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.showAlert(message: "Login failed: No response from server")
                completion(false)
                return
            }
            if httpResponse.statusCode == 200 {
                if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                    HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
                }
                completion(true)
            } else {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = jsonObject["msg"] as? String {
                            self.showAlert(message: "Login failed: \(errorMessage)")
                        } else {
                            self.showAlert(message: "Login failed: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Login failed: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Login failed: No data received")
                }
                completion(false)
            }
        }
        task.resume()
    }
    
    // Register
    func register(name: String, email: String, password: String, gender: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseUrl)/auth/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["name": name, "email": email, "password": password, "gender": gender]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.showAlert(message: "Registration failed: No response from server")
                completion(false)
                return
            }
            if httpResponse.statusCode == 201 {
                completion(true)
            } else {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = jsonObject["msg"] as? String {
                            self.showAlert(message: "Registration failed: \(errorMessage)")
                        } else {
                            self.showAlert(message: "Registration failed: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Registration failed: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Registration failed: No data received")
                }
                completion(false)
            }
        }
        task.resume()
    }
    
    // Logout
    func logout(completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseUrl)/auth/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.showAlert(message: "Logout failed: No response from server")
                completion(false)
                return
            }
            if httpResponse.statusCode == 200 {
                completion(true)
            } else {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = jsonObject["msg"] as? String {
                            self.showAlert(message: "Logout failed: \(errorMessage)")
                        } else {
                            self.showAlert(message: "Logout failed: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Logout failed: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Logout failed: No data received")
                }
                completion(false)
            }
        }
        task.resume()
    }
    
    // Get Current User
    func getCurrentUser(completion: @escaping (Data?) -> Void) {
        let url = URL(string: "\(baseUrl)/users/current-user")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
            request.allHTTPHeaderFields = cookieHeader
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.showAlert(message: "Fetch current user failed: No response from server")
                completion(nil)
                return
            }
            if httpResponse.statusCode == 200 {
                completion(data)
            } else {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = jsonObject["msg"] as? String {
                            self.showAlert(message: "Fetch current user failed: \(errorMessage)")
                        } else {
                            self.showAlert(message: "Fetch current user failed: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Fetch current user failed: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Fetch current user failed: No data received")
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
    // Update User
    func updateUser(name: String, email: String, gender: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseUrl)/users/update-user")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["name": name, "email": email, "gender": gender, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.showAlert(message: "Update user failed: No response from server")
                completion(false)
                return
            }
            if httpResponse.statusCode == 200 {
                completion(true)
            } else {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = jsonObject["msg"] as? String {
                            self.showAlert(message: "Update user failed: \(errorMessage)")
                        } else {
                            self.showAlert(message: "Update user failed: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Update user failed: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Update user failed: No data received")
                }
                completion(false)
            }
        }
        task.resume()
    }
    
    // Fetch Data
    func fetchData(completion: @escaping (Data?) -> Void) {
        let url = URL(string: "\(baseUrl)/data")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
            request.allHTTPHeaderFields = cookieHeader
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.showAlert(message: "Fetch data failed: No response from server")
                completion(nil)
                return
            }
            if httpResponse.statusCode == 200 {
                completion(data)
            } else {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = jsonObject["msg"] as? String {
                            self.showAlert(message: "Fetch data failed: \(errorMessage)")
                        } else {
                            self.showAlert(message: "Fetch data failed: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Fetch data failed: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Fetch data failed: No data received")
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
    // Create Data
    func createData(note: String, duration: Int, date: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseUrl)/data")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["note": note, "duration": duration, "date": date]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.showAlert(message: "Create data failed: No response from server")
                completion(false)
                return
            }
            if httpResponse.statusCode == 201 {
                completion(true)
            } else {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = jsonObject["msg"] as? String {
                            self.showAlert(message: "Create data failed: \(errorMessage)")
                        } else {
                            self.showAlert(message: "Create data failed: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Create data failed: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Create data failed: No data received")
                }
                completion(false)
            }
        }
        task.resume()
    }
    
    // Update Data
    func updateData(id: String, note: String, duration: Int, date: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseUrl)/data/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["note": note, "duration": duration, "date": date]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.showAlert(message: "Update data failed: No response from server")
                completion(false)
                return
            }
            if httpResponse.statusCode == 200 {
                completion(true)
            } else {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = jsonObject["msg"] as? String {
                            self.showAlert(message: "Update data failed: \(errorMessage)")
                        } else {
                            self.showAlert(message: "Update data failed: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Update data failed: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Update data failed: No data received")
                }
                completion(false)
            }
        }
        task.resume()
    }
    
    // Delete Data
    func deleteData(id: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseUrl)/data/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.showAlert(message: "Delete data failed: No response from server")
                completion(false)
                return
            }
            if httpResponse.statusCode == 200 {
                completion(true)
            } else {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = jsonObject["msg"] as? String {
                            self.showAlert(message: "Delete data failed: \(errorMessage)")
                        } else {
                            self.showAlert(message: "Delete data failed: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Delete data failed: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Delete data failed: No data received")
                }
                completion(false)
            }
        }
        task.resume()
    }
    
    func updateRepeatFrequency(frequency: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseUrl)/updateRepeatFrequency")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body: [String: Any] = ["frequency": frequency]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.showAlert(message: "Update repeat frequency failed: No response from server")
                completion(false)
                return
            }
            if httpResponse.statusCode == 200 {
                completion(true)
            } else {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = jsonObject["msg"] as? String {
                            self.showAlert(message: "Update repeat frequency failed: \(errorMessage)")
                        } else {
                            self.showAlert(message: "Update repeat frequency failed: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Update repeat frequency failed: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Update repeat frequency failed: No data received")
                }
                completion(false)
            }
        }
        task.resume()
    }
}
