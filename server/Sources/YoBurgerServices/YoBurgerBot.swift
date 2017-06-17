import Foundation
import SlackKit

class YoBurgerBot {

    let bot: SlackKit

    nit(token: String) {
        bot = SlackKit()
        bot.addRTMBotWithAPIToken(token)
        bot.addWebAPIAccessWithToken(token)
        bot.notificationForEvent(.message) { [weak self] (event, client) in
            guard
                let message = event.message,
                let id = client?.authenticatedUser?.id,
                message.text?.contains(id) == true
            else {
                return
            }
            self?.handleMessage(message)
        }
    }
    
    init(clientID: String, clientSecret: String) {
        bot = SlackKit()
        let oauthConfig = OAuthConfig(clientID: clientID, clientSecret: clientSecret)
        bot.addServer(oauth: oauthConfig)
        bot.notificationForEvent(.message) { [weak self] (event, client) in
            guard
                let message = event.message,
                let id = client?.authenticatedUser?.id,
                message.text?.contains(id) == true
            else {
                return
            }
            self?.handleMessage(message)
        }
    }
    
    // MARK: Bot logic
    private func handleMessage(_ message: Message) {
        if let text = message.text?.lowercased(), let channel = message.channel {
            for (robot, verdict) in verdicts {
                let lowerbot = robot.lowercased()
                if text.contains(lowerbot) {
                    let reaction = "Hello, World"
                    bot.webAPI?.addReaction(name: reaction, channel: channel, timestamp: message.ts, success: nil, failure: nil)
                    return
                }
            }
            // Not found
            bot.webAPI?.addReaction(name: "question", channel: channel, timestamp: message.ts, success: nil, failure: nil)
            return
        }
    }

}