//
//  AuthManager.swift
//  Spotify
//
//  Created by David Marukhyan on 01.12.21.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constans {
        static let clientID = "e9bdb377b5a145b38fa3ab18d3e9c167"
        static let clientSecret = "71fbfaacdd7740e6bdf07ba3960f45b2"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let string = "https://accounts.spotify.com/authorize?response_type=code&client_id=\(Constans.clientID)&scope=user-read-private&redirect_uri=http://localhost:8080&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refeshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String,completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: Constans.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "http://localhost:8080")
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constans.clientID + ":" + Constans.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        
        guard let refreshToken = self.refeshToken else {
            return
        }
        
        guard let url = URL(string: Constans.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constans.clientID + ":" + Constans.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed")
                self?.cacheToken(result: result)
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
            
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
