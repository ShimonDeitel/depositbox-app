import XCTest

final class DepositboxUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddEntryFlow() throws {
        app.buttons["addEntryButton"].tap()
        let nameField = app.textFields["nameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText("UI Test Client")
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Client"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissOnTapOutside() throws {
        app.buttons["addEntryButton"].tap()
        let nameField = app.textFields["nameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        XCTAssertTrue(app.keyboards.element.exists)
        app.navigationBars.element.tap()
        XCTAssertFalse(app.keyboards.element.exists)
    }

    func testFreeLimitTriggersPaywall() throws {
        for i in 0..<13 {
            app.buttons["addEntryButton"].tap()
            let nameField = app.textFields["nameField"]
            if nameField.waitForExistence(timeout: 1) {
                nameField.tap()
                nameField.typeText("Entry \(i)")
                app.buttons["saveButton"].tap()
            }
        }
        XCTAssertTrue(app.buttons["paywallPurchaseButton"].waitForExistence(timeout: 3) || app.staticTexts["Depositbox Pro"].waitForExistence(timeout: 2))
    }

    func testSettingsOpens() throws {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }
}
