//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class Bot_JSONTransformableTests: XCTestCase {

    typealias Configuration = Bot.Configuration
    typealias Schedule = Bot.Configuration.Schedule
    typealias CleanFrequency = Bot.Configuration.CleanFrequency
    typealias TestAction = Bot.Configuration.TestAction
    typealias CodeCoverage = Bot.Configuration.TestAction.CodeCoverage
    typealias Trigger = Bot.Configuration.Trigger
    typealias Day = Bot.Configuration.Schedule.Period.Day
    typealias Blueprint = Bot.Configuration.Blueprint
    typealias Location = Blueprint.Location
    typealias AuthenticationStrategy = Blueprint.AuthenticationStrategy
    typealias Repository = Blueprint.Repository
    
    var bot: Bot!
    var schedule: Schedule!
    var builtFromClean: CleanFrequency!
    var performsTestAction: TestAction!
    var codeCoveragePreference: CodeCoverage!
    var triggers: [Trigger]!
    var blueprint: Blueprint!
    var location: Location!
    var authenticationStrategy: AuthenticationStrategy!
    var repository: Repository!
    let primaryRemoteID = "REMOTE_ID"
    let username = "username"
    let password = "p4ssw0rd"
    let url = "https://hello.com"
    let fingerprint = "qwe123"

    override func setUp() {
        super.setUp()
        createManualSchedule()
        createNeverCleanFrequency()
        createNoTestAction()
        createSchemeSettingCodeCoverage()
        createRepository()
        createAuthenticationStrategy()
        createLocation()
        createBlueprint()
        triggers = []
    }
    
    // MARK: - toJSON

    func test_toJSON_shouldParseName() {
        createBot()
        XCTAssertEqual(botJSON()["name"].string, "develop Bot")
    }

    // MARK: - group

    func test_toJSON_shouldCreateGroupUUID() {
        createBot()
        XCTAssertEqual(botJSON()["group"]["name"].string?.characters.count, 36)
    }

    // MARK: - Configuration

    func test_toJSON_shouldParseConfigSchemeName() {
        createBot()
        XCTAssertEqual(configJSON()["schemeName"].string, "xcsautobuild")
    }

    func test_toJSON_shouldParseConfigPerformsAnalyzeAction() {
        createBot()
        XCTAssertEqual(configJSON()["performsAnalyzeAction"].bool, true)
    }

    func test_toJSON_shouldParseConfigExportsProductFromArchive() {
        createBot()
        XCTAssertEqual(configJSON()["exportsProductFromArchive"].bool, true)
    }

    // MARK: - Schedule

    func test_toJSON_shouldParseManualSchedule() {
        createBot()
        XCTAssertEqual(scheduleTypeJSON().int, 3)
    }

    func test_toJSON_shouldParseCommitSchedule() {
        createCommitSchedule()
        createBot()
        XCTAssertEqual(scheduleTypeJSON().int, 2)
    }

    func test_toJSON_shouldParsePeriod() {
        createWeeklySchedule()
        createBot()
        XCTAssertEqual(scheduleTypeJSON().int, 1)
    }

    // MARK: - Period

    func test_toJSON_shouldParseWeeklyPeriod() {
        createWeeklySchedule()
        createBot()
        XCTAssertEqual(periodicScheduleIntervalJSON(), 3)
    }

    func test_toJSON_shouldParseDailyPeriod() {
        createDailySchedule()
        createBot()
        XCTAssertEqual(periodicScheduleIntervalJSON(), 2)
    }

    func test_toJSON_shouldParseHourlyPeriod() {
        createHourlySchedule()
        createBot()
        XCTAssertEqual(periodicScheduleIntervalJSON(), 1)
    }

    func test_toJSON_shouldSetScheduleIntervalTo0_whenNotPeriodical() {
        createCommitSchedule()
        createBot()
        XCTAssertEqual(periodicScheduleIntervalJSON(), 0)
        createManualSchedule()
        createBot()
        XCTAssertEqual(periodicScheduleIntervalJSON(), 0)
    }

    // MARK: - hourly

    func test_toJSON_shouldParseHourly() {
        createHourlySchedule()
        createBot()
        XCTAssertEqual(configJSON()["minutesAfterHourToIntegrate"], 54)
    }

    // MARK: - daily

    func test_toJSON_shouldParseDaily() {
        createDailySchedule()
        createBot()
        XCTAssertEqual(configJSON()["hourOfIntegration"], 1)
    }

    // MARK: - weekly

    func test_toJSON_shouldParseWeeklyOnMonday() {
        createWeeklySchedule()
        createBot()
        XCTAssertEqual(configJSON()["weeklyScheduleDay"], 1)
    }

    func test_toJSON_shouldParseWeeklyOnSunday() {
        createWeeklySchedule(.sunday)
        createBot()
        XCTAssertEqual(configJSON()["weeklyScheduleDay"], 7)
    }

    // MARK: - CleanFrequency

    func test_toJSON_shouldParseNeverCleanFrequency() {
        createBot()
        XCTAssertEqual(builtFromCleanJSON().int, 0)
    }

    func test_toJSON_shouldParseAlwaysCleanFrequency() {
        createAlwaysCleanFrequency()
        createBot()
        XCTAssertEqual(builtFromCleanJSON().int, 1)
    }

    func test_toJSON_shouldParseOneADayCleanFrequency() {
        createOnceADayCleanFrequency()
        createBot()
        XCTAssertEqual(builtFromCleanJSON().int, 2)
    }

    func test_toJSON_shouldParseOneAWeekCleanFrequency() {
        createOnceAWeekCleanFrequency()
        createBot()
        XCTAssertEqual(builtFromCleanJSON().int, 3)
    }

    // MARK: - TestAction

    func test_toJSON_shouldParseNoTestAction() {
        createNoTestAction()
        createBot()
        XCTAssertEqual(testActionJSON().bool, false)
    }

    func test_toJSON_shouldParseYesTestAction() {
        createYesTestAction()
        createBot()
        XCTAssertEqual(testActionJSON().bool, true)
    }

    // MARK: CodeCoverage

    func test_toJSON_shouldNotParseCodeCoverage_whenNoTestAction() {
        createBot()
        XCTAssertNil(codeCoverageJSON().int)
    }

    func test_toJSON_shouldParseSchemeSettingCodeCoverage() {
        createYesTestAction()
        createBot()
        XCTAssertEqual(codeCoverageJSON().int, 1)
    }

    func test_toJSON_shouldParseEnabledCodeCoverage() {
        createEnabledCodeCoverage()
        createYesTestAction()
        createBot()
        XCTAssertEqual(codeCoverageJSON().int, 2)
    }

    func test_toJSON_shouldParseDisabledCodeCoverage() {
        createDisabledCodeCoverage()
        createYesTestAction()
        createBot()
        XCTAssertEqual(codeCoverageJSON().int, 3)
    }

    // MARK: - triggers

    func test_toJSON_shouldParseEmptyTriggers() {
        createBot()
        XCTAssertEqual(triggersJSON().array?.isEmpty, true)
    }

    func test_toJSON_shouldParseBeforeTrigger() {
        addBeforeTrigger()
        createBot()
        XCTAssertEqual(triggersJSON()[0]["phase"].int, 1)
    }

    func test_toJSON_shouldParseTriggerScript() {
        addBeforeTrigger()
        createBot()
        XCTAssertEqual(triggersJSON()[0]["scriptBody"].string, "echo \"testing\"")
    }

    func test_toJSON_shouldParseTriggerName() {
        addBeforeTrigger()
        createBot()
        XCTAssertEqual(triggersJSON()[0]["name"].string, "before")
    }

    func test_toJSON_shouldParseAfterTrigger() {
        addAfterTrigger()
        createBot()
        XCTAssertEqual(triggersJSON()[0]["phase"].int, 2)
    }

    func test_toJSON_shouldParseAfterTrigger_withFalseConditions() {
        addAfterTrigger()
        createBot()
        XCTAssertEqual(conditionsJSON()["onWarnings"].bool, false)
        XCTAssertEqual(conditionsJSON()["onBuildErrors"].bool, false)
        XCTAssertEqual(conditionsJSON()["onInternalErrors"].bool, false)
        XCTAssertEqual(conditionsJSON()["onAnalyzerWarnings"].bool, false)
        XCTAssertEqual(conditionsJSON()["onFailingTests"].bool, false)
        XCTAssertEqual(conditionsJSON()["onSuccess"].bool, false)
    }

    func test_toJSON_shouldParseAfterTrigger_withTrueConditions() {
        addAfterTriggerWithAllConditions()
        createBot()
        XCTAssertEqual(conditionsJSON()["onWarnings"].bool, true)
        XCTAssertEqual(conditionsJSON()["onBuildErrors"].bool, true)
        XCTAssertEqual(conditionsJSON()["onInternalErrors"].bool, true)
        XCTAssertEqual(conditionsJSON()["onAnalyzerWarnings"].bool, true)
        XCTAssertEqual(conditionsJSON()["onFailingTests"].bool, true)
        XCTAssertEqual(conditionsJSON()["onSuccess"].bool, true)
    }

    func test_toJSON_shouldSetTriggerType_forAfterTrigger() {
        addAfterTrigger()
        createBot()
        XCTAssertEqual(triggersJSON()[0]["type"].int, 1)
    }

    func test_toJSON_shouldSetTriggerType_forBeforeTrigger() {
        addBeforeTrigger()
        createBot()
        XCTAssertEqual(triggersJSON()[0]["type"].int, 1)
    }

    // MARK: - Blueprint

    func test_blueprintLocations_containsDictionary() {
        createBot()
        XCTAssertNotNil(blueprintLocationsJSON().dictionary)
    }

    // MARK: - location

    func test_location_shouldHaveBranchID() {
        createBot()
        XCTAssertEqual(blueprintLocationJSON()["DVTSourceControlBranchIdentifierKey"].string, "master")
    }

    func test_location_shouldHaveBranchID_whenDifferentName() {
        createLocation(branchName: "develop")
        createBlueprint()
        createBot()
        XCTAssertEqual(blueprintLocationJSON()["DVTSourceControlBranchIdentifierKey"].string, "develop")
    }

    func test_location_shouldOptionsKey() {
        createLocation(branchName: "develop")
        createBlueprint()
        createBot()
        XCTAssertEqual(blueprintLocationJSON()["DVTSourceControlBranchOptionsKey"].int, 1)
    }

    func test_location_shouldHaveBranchLocationType() {
        createLocation(branchName: "develop")
        createBlueprint()
        createBot()
        XCTAssertEqual(blueprintLocationJSON()["DVTSourceControlWorkspaceBlueprintLocationTypeKey"].string, "DVTSourceControlBranch")
    }

    // MARK: - projectName

    func test_projectName() {
        createBot()
        XCTAssertEqual(blueprintJSON()["DVTSourceControlWorkspaceBlueprintNameKey"].string, "project_name")
    }

    func test_projectName_shouldNotBeHardCoded() {
        createBlueprint(projectName: "project_name2")
        createBot()
        XCTAssertEqual(blueprintJSON()["DVTSourceControlWorkspaceBlueprintNameKey"].string, "project_name2")
    }

    // MARK: - projectPath

    func test_projectPath() {
        createBot()
        XCTAssertEqual(blueprintJSON()["DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey"].string, "project_name.xcodeproj")
    }

    func test_projectPath_shouldNotBeHardCoded() {
        createBlueprint(projectName: "project_name2")
        createBot()
        XCTAssertEqual(blueprintJSON()["DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey"].string, "project_name2.xcodeproj")
    }

    // MARK: - primaryRemoteKey

    func test_primaryRemoteKey() {
        createBot()
        XCTAssertEqual(blueprintJSON()["DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey"].string, primaryRemoteID)
    }

    func test_primaryRemoteKey_shouldNotBeHardCoded() {
        createRepository(id: "remote2")
        createBlueprint()
        createBot()
        XCTAssertEqual(blueprintJSON()["DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey"].string, "remote2")
    }

    // MARK: - authenticationStrategy

    func test_authenticationStrategy_shouldSharePrimaryRemoteKey() {
        createBot()
        XCTAssertNotNil(blueprintJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey"][primaryRemoteID])
    }

    func test_authenticationStrategy_shouldHaveUsername() {
        createBot()
        XCTAssertEqual(authenticationStrategyJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryUsernameKey"].string, username)
    }

    func test_authenticationStrategy_shouldHaveUsernameWhichIsNotHardcoded() {
        createAuthenticationStrategy(username: "user2")
        createBlueprint()
        createBot()
        XCTAssertEqual(authenticationStrategyJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryUsernameKey"].string, "user2")
    }

    func test_authenticationStrategy_shouldHavePassword() {
        createBot()
        XCTAssertEqual(authenticationStrategyJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryPasswordKey"].string, password)
    }

    func test_authenticationStrategy_shouldHavePasswordWhichIsNotHardcoded() {
        createAuthenticationStrategy(password: "pass2")
        createBlueprint()
        createBot()
        XCTAssertEqual(authenticationStrategyJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryPasswordKey"].string, "pass2")
    }

    func test_authenticationStrategy_shouldHaveBasicAuthKey() {
        createBot()
        XCTAssertEqual(authenticationStrategyJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationTypeKey"].string, "DVTSourceControlBasicAuthenticationStrategy")
    }

    // MARK: - checkoutPath

    func test_checkoutPath_shouldBeSameAsProjectName() {
        createBot()
        XCTAssertEqual(blueprintJSON()["DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey"][primaryRemoteID].string, "project_name")
    }

    // MARK: - blueprintVersion

    func test_blueprintVersion_is204() {
        createBot()
        XCTAssertEqual(blueprintJSON()["DVTSourceControlWorkspaceBlueprintVersion"].int, 204)
    }

    // MARK: - repository

    func test_repository_shouldTrustCertificate() {
        createBot()
        XCTAssertEqual(blueprintRepositoryJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryEnforceTrustCertFingerprintKey"].bool, true)
    }

    func test_repository_shouldSharePrimaryRepositoryKey() {
        createBot()
        XCTAssertEqual(blueprintRepositoryJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryIdentifierKey"].string, primaryRemoteID)
    }

    func test_repository_shouldBeGitSystem() {
        createBot()
        XCTAssertEqual(blueprintRepositoryJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositorySystemKey"].string, "com.apple.dt.Xcode.sourcecontrol.Git")
    }

    func test_repository_shouldSetURL() {
        createBot()
        XCTAssertEqual(blueprintRepositoryJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryURLKey"].string, url)
    }

    func test_repository_urlShouldNotBeHardCoded() {
        createRepository(url: "url2")
        createBlueprint()
        createBot()
        XCTAssertEqual(blueprintRepositoryJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryURLKey"].string, "url2")
    }

    func test_repository_shouldHaveCertifacteFingerprint() {
        createBot()
        XCTAssertEqual(blueprintRepositoryJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryTrustedCertFingerprintKey"].string, fingerprint)
    }

    func test_repository_shouldHaveNonHardcodedCertifacteFingerprint() {
        createRepository(fingerprint: "123")
        createBlueprint()
        createBot()
        XCTAssertEqual(blueprintRepositoryJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryTrustedCertFingerprintKey"].string, "123")
    }

    // MARK: - Helpers

    func createBot() {
        bot = Bot(name: "develop Bot",
                  configuration: createConfiguration())
    }

    func createConfiguration() -> Configuration {
        return Configuration(
            schedule: schedule,
            schemeName: "xcsautobuild",
            builtFromClean: builtFromClean,
            performsAnalyzeAction: true,
            performsTestAction: performsTestAction,
            exportsProductFromArchive: true,
            triggers: triggers,
            sourceControlBlueprint: blueprint
        )
    }

    func createManualSchedule() {
        schedule = .manual
    }

    func createCommitSchedule() {
        schedule = .commit
    }

    func createWeeklySchedule(day: Day = .monday) {
        schedule = .periodically(.weekly(day))
    }

    func createDailySchedule() {
        schedule = .periodically(.daily(hourOfIntegration: 1))
    }

    func createHourlySchedule() {
        schedule = .periodically(.hourly(minuteOfIntegration: 54))
    }

    func createNeverCleanFrequency() {
        builtFromClean = .never
    }

    func createAlwaysCleanFrequency() {
        builtFromClean = .always
    }

    func createOnceADayCleanFrequency() {
        builtFromClean = .onceADay
    }

    func createOnceAWeekCleanFrequency() {
        builtFromClean = .onceAWeek
    }

    func createNoTestAction() {
        performsTestAction = .no
    }

    func createYesTestAction() {
        performsTestAction = .yes(codeCoveragePreference)
    }

    func createSchemeSettingCodeCoverage() {
        codeCoveragePreference = .useSchemeSetting
    }

    func createEnabledCodeCoverage() {
        codeCoveragePreference = .enabled
    }

    func createDisabledCodeCoverage() {
        codeCoveragePreference = .disabled
    }

    func addBeforeTrigger() {
        triggers.append(Trigger(
            phase: .before,
            name: "before",
            scriptBody: "echo \"testing\""
        ))
    }

    func addAfterTrigger() {
        triggers.append(Trigger(
            phase: .after([]),
            name: "after",
            scriptBody: "echo \"testing\""
        ))
    }

    func addAfterTriggerWithAllConditions() {
        triggers.append(Trigger(
            phase: .after([.onWarnings, .onBuildErrors, .onInternalErrors, .onAnalyzerWarnings, .onFailingTests, .onSuccess]),
            name: "after",
            scriptBody: "echo \"testing\""
        ))
    }

    func createBlueprint(projectName projectName: String = "project_name") {
        blueprint = Blueprint(
            location: location,
            projectName: projectName,
            projectPath: projectName + ".xcodeproj",
            authenticationStrategy: authenticationStrategy,
            repository: repository
        )
    }

    func createLocation(branchName name: String = "master") {
        location = Location(branchName: name)
    }

    func createAuthenticationStrategy(username username: String = "username", password: String = "p4ssw0rd") {
        authenticationStrategy = .basic(username, password)
    }

    func createRepository(id id: String = "REMOTE_ID", url: String = "https://hello.com", fingerprint: String = "qwe123") {
        repository = Repository(id: id, url: url, fingerprint: fingerprint)
    }

    func botJSON() -> FlexiJSON {
        return FlexiJSON(dictionary: bot.toJSON())
    }

    func configJSON() -> FlexiJSON {
        return botJSON()["configuration"]
    }

    func scheduleTypeJSON() -> FlexiJSON {
        return configJSON()["scheduleType"]
    }

    func periodicScheduleIntervalJSON() -> FlexiJSON {
        return configJSON()["periodicScheduleInterval"]
    }

    func builtFromCleanJSON() -> FlexiJSON {
        return configJSON()["builtFromClean"]
    }

    func testActionJSON() -> FlexiJSON {
        return configJSON()["performsTestAction"]
    }

    func codeCoverageJSON() -> FlexiJSON {
        return configJSON()["codeCoveragePreference"]
    }

    func triggersJSON() -> FlexiJSON {
        return configJSON()["triggers"]
    }

    func conditionsJSON() -> FlexiJSON {
        return triggersJSON()[0]["conditions"]
    }

    func blueprintJSON() -> FlexiJSON {
        return configJSON()["sourceControlBlueprint"]
    }

    func blueprintLocationsJSON() -> FlexiJSON {
        return blueprintJSON()["DVTSourceControlWorkspaceBlueprintLocationsKey"]
    }

    func blueprintLocationJSON() -> FlexiJSON {
        return blueprintLocationsJSON()[primaryRemoteID]
    }

    func authenticationStrategyJSON() -> FlexiJSON {
        return blueprintJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationStrategiesKey"][primaryRemoteID]
    }

    func blueprintRepositoryJSON() -> FlexiJSON {
        return blueprintJSON()["DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey"][0]
    }
}
