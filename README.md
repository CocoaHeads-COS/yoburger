# yoburger
The home of the YoBurger SlackBot,  give and receive :hamburger: ‘s to promote mutual support in slack

## Install and run yoburger locally on your Mac
0. Install Xcode
1. Clone the repo `git clone https://github.com/CocoaHeads-COS/yoburger.git`
2. Rename `<projectdir>/server/Sources/YoBurgerMain/config.swift.template` to `<projectdir>/server/Sources/YoBurgerMain/config.swift`
3. Add your Slackbot api to `server/Sources/YoBurgerMain/config.swift`
4. Open terminal and goto the `server` subfolder. `cd <projectdir>/server`
5. Build the app `swift build`
6. *Optional*: Create an Xcode Project to edit with Xcode `swift package generate-xcodeproj`
7. Run the app `.build/debug/YoBurgerMain`

## Add Slackbot to your Slack channel
1. Goto: https://my.slack.com/services/new/bot
2. Enter `yoburger`
3. Click `Add Bot Integration`
4. Copy the API token to `<projectdir>/server/Sources/YoBurgerMain/config.swift`
5. Go back to your channel and invite the bot. `/invite yoburger`

## Testing with Docker Locally 

1. Change Directdory to the location of the server
`cd <projectdir>/server`

2. Issue docker-compose command to test
`docker-compose -f docker-test.yml up`

3. Or Issue docker-compose command to run unit tests
`docker-compose -f docker-unit-test.yml`
