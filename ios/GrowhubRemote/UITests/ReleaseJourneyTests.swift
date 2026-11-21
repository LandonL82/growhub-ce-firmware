import XCTest

final class ReleaseJourneyTests: XCTestCase {
    func testGrowhubAndOutletNamesKeepDeviceIdentity() {
        let app = XCUIApplication()
        app.launchArguments = ["--demo"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Greenhouse"].waitForExistence(timeout: 8))
        app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Greenhouse")).firstMatch.tap()
        app.buttons["Rename Growhub"].tap()
        XCTAssertTrue(app.alerts["Growhub Name"].exists)
        app.alerts.textFields.firstMatch.tap()
        app.alerts.textFields.firstMatch.typeText("Kitchen garden")
        app.alerts.buttons["Save"].tap()
        XCTAssertTrue(app.navigationBars["Kitchen garden"].exists)
        XCTAssertTrue(app.staticTexts["GrowHub_0001"].exists)
        app.buttons["rename-outlet-1"].tap()
        app.alerts.textFields.firstMatch.tap()
        app.alerts.textFields.firstMatch.typeText("Grow lights")
        app.alerts.buttons["Save"].tap()
        XCTAssertTrue(app.buttons["Rename Grow lights"].exists)
        XCTAssertEqual(app.switches["outlet-1-power"].label, "Grow lights power")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.staticTexts["GrowHub_0001"].exists)
        XCTAssertTrue(app.staticTexts["Kitchen garden"].exists)
        app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Indoor garden")).firstMatch.tap()
        XCTAssertTrue(app.buttons["Rename Outlet 1"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Kitchen garden")).firstMatch.tap()
        XCTAssertTrue(app.buttons["Rename Grow lights"].exists)
        capture("03-named-outlets")
    }
    func testDemoNavigationAndControls() {
        let app = XCUIApplication()
        app.launchArguments = ["--demo"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Greenhouse"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Indoor garden"].exists)
        capture("01-controllers")
        app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Greenhouse")).firstMatch.tap()
        XCTAssertTrue(app.buttons["Resume schedules"].waitForExistence(timeout: 3))
        let power = app.switches["Outlet 1 power"]
        XCTAssertTrue(power.exists)
        power.tap()
        XCTAssertEqual(power.value as? String, "1")
        capture("02-outlets")
        app.buttons["Resume schedules"].tap()
        XCTAssertTrue(app.buttons["Use manual control"].waitForExistence(timeout: 3))
        app.buttons["Use manual control"].tap()
        app.buttons["Switch all to Manual"].tap()
        XCTAssertTrue(app.buttons["Resume schedules"].waitForExistence(timeout: 3))
        app.swipeUp()
        app.buttons["Full controls"].tap()
        XCTAssertTrue(app.buttons["Schedules"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.webViews.count, 0)
        app.buttons["Done"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.buttons["Help and demo"].tap()
        app.swipeUp()
        app.buttons["Privacy policy"].tap()
        XCTAssertTrue(app.staticTexts["Growhub Remote Privacy Policy"].waitForExistence(timeout: 3))
    }
    func testNativeControllerPagesAndScheduleSave() {
        let app = XCUIApplication()
        app.launchArguments = ["--demo"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Greenhouse"].waitForExistence(timeout: 8))
        app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Greenhouse")).firstMatch.tap()
        app.swipeUp()
        app.buttons["Full controls"].tap()
        XCTAssertTrue(app.buttons["Schedules"].waitForExistence(timeout: 5))
        app.buttons["Schedules"].tap()
        XCTAssertTrue(app.switches["Always on"].firstMatch.waitForExistence(timeout: 3))
        app.switches["Always on"].firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
        XCTAssertEqual(app.switches["Always on"].firstMatch.value as? String, "1")
        capture("05-edited-schedule")
        app.navigationBars.buttons["Save"].tap()
        app.buttons["Save schedules"].tap()
        capture("06-after-schedule-save")
        XCTAssertTrue(app.buttons["Schedules"].waitForExistence(timeout: 3))
        app.buttons["Schedules"].tap()
        XCTAssertEqual(app.switches["Always on"].firstMatch.value as? String, "1")
        app.navigationBars["Schedules"].buttons.element(boundBy: 0).tap()
        for (link, title) in [("Outlet assignments", "Outlet assignments"), ("Device and time", "Device and time"), ("Wi-Fi", "Wi-Fi"), ("Command Center", "Command Center"), ("Firmware updates", "Firmware updates"), ("Diagnostics and actions", "Diagnostics")] {
            let button = app.buttons[link]
            if !button.isHittable { app.swipeUp() }
            button.tap()
            XCTAssertTrue(app.navigationBars[title].waitForExistence(timeout: 3))
            XCTAssertEqual(app.webViews.count, 0)
            if title == "Diagnostics" { app.swipeUp(); XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "Unavailable")).firstMatch.exists) }
            app.navigationBars[title].buttons.element(boundBy: 0).tap()
        }
        capture("04-native-settings")
    }
    private func capture(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
