import HeliumLogger
import Foundation

HeliumLogger.use()

let slackbot = YoBurgerBot(token: kSlackAPIToken)

RunLoop.main.run()

