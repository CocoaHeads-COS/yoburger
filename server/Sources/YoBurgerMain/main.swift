import YoBurgerServices
import HeliumLogger

HeliumLogger.use()

let slackbot = YoBurgerBot(token: kSlackAPIToken)

RunLoop.main.run()

