//
//  VKAuthService.swift
//  VKClient
//
//  Created by Константин Зонин on 24.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import Alamofire

class VKAuthService : VKApiService {
    
    init() {
        super.init("https://oauth.vk.com/authorize")
    }
    
    func сreateAuthRequest() throws -> URLRequest {
        guard let url = URL(string: pathUrl) else {
            assertionFailure()
            throw UrlCreateError.wrongUrl
        }
        var parameters: Parameters {
            return [
                "client_id": idApi,
                "display": "mobile",
                "redirect_uri": "https://oauth.vk.com/blank.html",
                "scope": "friends,photos,groups,wall,messages",
                "response_type": "token",
                "v": apiVersion
            ]
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

enum UrlCreateError : Error {
    case wrongUrl
}
