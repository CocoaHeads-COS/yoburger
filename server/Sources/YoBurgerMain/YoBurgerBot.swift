import Foundation
import SlackKit

class YoBurgerBot {

  let bot: SlackKit
  
  typealias YBUserID = String
  typealias YBUserName = String
  
  var users = [YBUserID:YBUser]()
  var allUsersInChannel = [YBUserID:YBUserName]()
  
  init(token: String) {
    bot = SlackKit()
    bot.addRTMBotWithAPIToken(token)
    bot.addWebAPIAccessWithToken(token)
    bot.notificationForEvent(.message) { [weak self] (event, client) in
      guard
        let message = event.message?.text,
        let channel = event.message?.channel,
        let yoburgerID = client?.authenticatedUser?.id,
        let messageSenderID = event.message?.user,
        self?.saveAllUserNamesInChannel(event: event, client: client) == true, //Generates username table
        let username = self?.allUsersInChannel[messageSenderID],
        let referrers = self?.getAllReferredUsersIn(message: message)
        else {
          return
      }
      
      if messageSenderID != yoburgerID {
        if message.uppercased().contains("DEBUG") {
          self?.sendMessage(channel: channel, message: "Debug :)")
          
        } else if message.uppercased().contains("BURGERHISTORY") && referrers.count > 0 {
          for referrer in referrers {
            let referrerName = self?.allUsersInChannel[referrer] ?? "Unknown"
            let referrerCount = self?.users[referrer]?.history.count ?? 0
            let messageToSend = "@\(referrerName) has \(referrerCount) :hamburger:s"
            self?.sendMessage(channel: channel, message: messageToSend)
          }
          
        } else {
          
          for user in referrers {
            
            //Add user to db if they don't already exist
            if self?.users[user] == nil {
              let username = self?.allUsersInChannel[user] ?? "Unknown"
              let newUser = YBUser(name: username, id: user)
              self?.users[user] = newUser
            }
            
            //Add burger to sender's history
            self?.saveBurgerInUsersHistory(userId: user, referrer: messageSenderID)
          }
          
          //Send Message to Slack Channel
          //Slack uses :hamburger: instead of emoji, so we check for both
          if message.contains("🍔") || message.contains(":hamburger:") {
            for user in referrers {
              let refusername = self?.allUsersInChannel[user] ?? "Unknown"
              let refburgercount = self?.users[user]?.history.count ?? 0
              var ifplural = ""
              if refburgercount > 1 {
                ifplural = "s"
              }
              self?.sendMessage(channel: channel, message: "@\(username) has given @\(refusername) a :hamburger:.\n@\(refusername) now has [ \(refburgercount) ] :hamburger:\(ifplural)")
            }
          }
          //Debug Log
          print("Message from \(username): \(message)")
        }
      }
    }
  }
  
  func sendMessage(channel:String, message:String) {
    self.bot.webAPI?.sendMessage(channel: channel, text: message, username: "YoBurger", asUser: true, parse: nil, linkNames: true, attachments: nil, unfurlLinks: nil, unfurlMedia: nil, iconURL: nil, iconEmoji: nil, success: nil, failure: nil)
  }
  
  func saveAllUserNamesInChannel(event:Event, client:Client?) -> Bool {
    guard let client = client else {return false}
  
    for user in client.users {
      if let id = user.value.id {
        allUsersInChannel[id] = user.value.name
      }
    }
    return true //Succeeded
  }
  
  func getAllReferredUsersIn(message:String) -> [YBUserID] {
    var referredUsers = [YBUserID]()
    for (id, _) in allUsersInChannel {
      if message.contains(id) {
        referredUsers.append(id)
      }
    }
    return referredUsers
  }
  
  func saveBurgerInUsersHistory(userId: YBUserID, referrer: YBUserID) {
    let newHistory = YBHistory(userid: userId, date: Date(), referrer: referrer)
    print("Adding burger to \(userId) from \(referrer)")
    users[userId]?.history.append(newHistory)
  }
  
}
