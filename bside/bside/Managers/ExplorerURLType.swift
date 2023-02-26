//
//  ExplorerURLType.swift
//  bside
//
//  Created by Justin Hunter on 2/21/23.
//

import Foundation
import FlowSDK

enum ExplorerURLType {
    case txHash(String)
    case address(String)

    func url(network: Network) -> URL? {
        switch self {
        case let .txHash(hash):
            return network == .mainnet
                ? URL(string: "https://flowscan.org/transaction/\(hash)")
                : URL(string: "https://testnet.flowscan.org/transaction/\(hash)")
        case let .address(address):
            return network == .mainnet
                ? URL(string: "https://flowscan.org/account/\(address)")
                : URL(string: "https://testnet.flowscan.org/account/\(address)")
        }
    }
}
