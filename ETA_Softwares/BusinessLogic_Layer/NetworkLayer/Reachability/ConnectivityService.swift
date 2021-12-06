//
//  ConnectivityService.swift
//  Scoot911_Aditya
//
//  Created by A1502 on 02/12/21.
//

import Foundation
import Alamofire

protocol IConnectivityService {
    var networkConnected:Bool{get}
}

struct ConnectivityService : IConnectivityService {
    /*
     use get current network status
     */
    internal var networkConnected:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
