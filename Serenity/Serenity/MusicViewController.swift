//
//  MusicViewController.swift
//  Serenity
//
//  Created by Diana Tran on 5/29/24.
//

import Foundation
import UIKit

class MusicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let tableView = UITableView()
    var tracks: [Track] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchToken()
        setupViews()
        setupSwipeBackGesture()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)
        
        logoImageView.image = UIImage(named: "Serenity")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
                
        titleLabel.text = "Spotify Recommended Meditation Songs:"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)
        view.addSubview(tableView)
        
        // Add the back button
        let backButton = UIButton(type: .system)
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(UIColor(red: 0.29, green: 0.18, blue: 0.51, alpha: 1.00), for: .normal)
        backButton.backgroundColor = UIColor(red: 0.90, green: 0.85, blue: 0.96, alpha: 1.00)
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
     
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func fetchToken() {
        
        let clientId = "dd5599d91f324bffb2535f9b65b59de0"
        let clientSecret = "1e048582b6ac4d41b1814585354e152e"
        
        let clientCredentials = "\(clientId):\(clientSecret)"
        let clientCredentialsData = clientCredentials.data(using: .utf8)!
        let encodedClientCredentials = clientCredentialsData.base64EncodedString()
        
        let tokenUrl = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: tokenUrl)
        request.httpMethod = "POST"
        request.addValue("Basic \(encodedClientCredentials)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "grant_type=client_credentials"
        request.httpBody = body.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.presentAlert(message: "Something went wrong, try again later!")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                DispatchQueue.main.async {
                    self.presentAlert(message: "Something went wrong, try again later!")
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    DispatchQueue.main.async { self.getRecommendations(accessToken: accessToken)
                    }
                } else if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let error = json["error"] as? [String: Any], let message = error["message"] as? String {
                    DispatchQueue.main.async {
                        self.presentAlert(message: "Something went wrong: \(message), try again later!")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.presentAlert(message: "Something went wrong, try again later!")
                }
                return
            }
        }
        
        task.resume()
        
    }
    
    private func getRecommendations(accessToken: String) {
        let tokenUrl = URL(string: "https://api.spotify.com/v1/recommendations?limit=10&seed_tracks=55YaGVtmlMuuz6KyrNBY1F,7LitEEkRqT4kkwgMlmzeik,6g9PHDFE7215jXbL666Ac0&max_speechiness=0.1")!
        
        var request = URLRequest(url: tokenUrl)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.presentAlert(message: "Something went wrong, try again later!")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                DispatchQueue.main.async {
                    self.presentAlert(message: "Something went wrong, try again later!")
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let tracksArray = json["tracks"] as? [[String: Any]] {
                    var fetchedTracks: [Track] = []
                                    
                    for track in tracksArray {
                        let trackName = track["name"] as? String ?? "Unknown Track"
                        let album = track["album"] as? [String: Any]
                        let images = album?["images"] as? [[String: Any]]
                        let imageUrl = images?.first?["url"] as? String ?? ""
                        let trackUrl = (track["external_urls"] as? [String: Any])?["spotify"] as? String ?? ""
                        fetchedTracks.append(Track(name: trackName, imageUrl: imageUrl, trackUrl: trackUrl))
                    }
                                    
                    DispatchQueue.main.async {
                        self.tracks = fetchedTracks
                        self.tableView.reloadData()
                    }
                } else if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let error = json["error"] as? [String: Any], let message = error["message"] as? String {
                    DispatchQueue.main.async {
                        self.presentAlert(message: "Something went wrong: \(message), try again later!")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.presentAlert(message: "Something went wrong, try again later!")
                }
                return
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tracks.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = tracks[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = track.name
        cell.imageView?.image = nil
                
        if let url = URL(string: track.imageUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    if let currentCell = tableView.cellForRow(at: indexPath) {
                        currentCell.imageView?.image = UIImage(data: data)
                        currentCell.setNeedsLayout()
                    }
                }
            }.resume()
        }
                
        cell.accessoryType = .disclosureIndicator
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
        if let url = URL(string: track.trackUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func navigateBack() {
        dismiss(animated: true, completion: nil)
    }    
}
