//
//  UserModel.swift
//  Server
//
//  Created by Shane Cowherd on 6/17/17.
//
//

import Foundation

class YBUser {
  var name:String
  var id:String
  var history:[YBHistory] = [YBHistory]()
  init(name:String, id:String) {
    self.name = name
    self.id = id
  }
}

struct YBHistory {
  var userid:String
  var date:Date
  var referrer:String
}
