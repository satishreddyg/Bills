//
//  HelperFunctions.swift
//  Bills
//
//  Created by Satish Garlapati on 7/3/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import Foundation

func throwExecutionError(_ message: Constants.error) -> Never {
    return fatalError(message.rawValue)
}
