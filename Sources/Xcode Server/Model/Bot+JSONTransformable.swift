//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

extension Bot {

    func toJSON() -> [String: AnyObject] {
        return [
            "name": name,
            "configuration": configuration.toJSON(),
            "group": ["name": NSUUID().UUIDString]
        ]
    }
}

extension Bot.Configuration {

    func toJSON() -> [String: AnyObject] {
        return [
            "schemeName": schemeName,
            "performsAnalyzeAction": performsAnalyzeAction,
            "exportsProductFromArchive": exportsProductFromArchive,
            "builtFromClean": builtFromClean.rawValue,
            "sourceControlBlueprint": sourceControlBlueprint.toJSON()
            ]
            + schedule.toJSON()
            + performsTestAction.toJSON()
            + ["triggers": triggers.map { $0.toJSON() }]
    }
}

extension Bot.Configuration.Schedule {

    func toJSON() -> [String: AnyObject] {
        let result: [String: AnyObject] = [
            "scheduleType": toInt(),
            "periodicScheduleInterval": 0
        ]
        if case .periodically(let period) = self {
            return result + period.toJSON()
        }
        return result
    }
}

extension Bot.Configuration.Schedule.Period {

    func toJSON() -> [String: AnyObject] {
        switch self {
        case .hourly(let minuteOfIntegration):
            return [
                "periodicScheduleInterval": 1,
                "minutesAfterHourToIntegrate": minuteOfIntegration
            ]
        case .daily(let hourOfIntegration):
            return [
                "periodicScheduleInterval": 2,
                "hourOfIntegration": hourOfIntegration
            ]
        case .weekly(let day):
            return [
                "periodicScheduleInterval": 3,
                "weeklyScheduleDay": day.rawValue
            ]
        }
    }
}

extension Bot.Configuration.TestAction {

    func toJSON() -> [String: AnyObject] {
        let result = [
            "performsTestAction": toBool(),
            ]
        if case .yes(let coverage) = self {
            return result + ["codeCoveragePreference": coverage.rawValue]
        }
        return result
    }

    func toBool() -> Bool {
        switch self {
        case .no:
            return false
        case .yes:
            return true
        }
    }
}

extension Bot.Configuration.Trigger {

    func toJSON() -> [String: AnyObject] {
        let result: [String: AnyObject] = [
            "phase": phase.toInt(),
            "name": name,
            "scriptBody": scriptBody,
            "type": 1
        ]
        if case .after(let conditions) = phase {
            return result + ["conditions": conditions.toJSON()]
        }
        return result
    }
}

extension Bot.Configuration.Trigger.Phase {

    func toInt() -> Int {
        switch self {
        case .before:
            return 1
        case .after:
            return 2
        }
    }
}

extension Bot.Configuration.Trigger.Phase.Conditions {

    func toJSON() -> [String: AnyObject] {
        return [
            "onWarnings": contains(.onWarnings),
            "onBuildErrors": contains(.onBuildErrors),
            "onInternalErrors": contains(.onInternalErrors),
            "onAnalyzerWarnings": contains(.onAnalyzerWarnings),
            "onFailingTests": contains(.onFailingTests),
            "onSuccess": contains(.onSuccess),
        ]
    }
}

extension Bot.Configuration.Blueprint {

    func toJSON() -> [String: AnyObject] {
        return [
            "DVTSourceControlWorkspaceBlueprintLocationsKey": location.toJSON(remoteID: primaryRemoteID),
            "DVTSourceControlWorkspaceBlueprintNameKey": projectName,
            "DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey": projectPath,
            "DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey": primaryRemoteID,
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationStrategiesKey": [
                primaryRemoteID: authenticationStrategy.toJSON()
            ],
            "DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey": [
                primaryRemoteID: projectName
            ],
            "DVTSourceControlWorkspaceBlueprintVersion": 204,
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey": [repository.toJSON(remoteID: primaryRemoteID)]
        ]
    }
}

extension Bot.Configuration.Blueprint.Repository {

    func toJSON(remoteID remoteID: String) -> [String: AnyObject] {
        return [
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryEnforceTrustCertFingerprintKey": true,
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryIdentifierKey": remoteID,
            "DVTSourceControlWorkspaceBlueprintRemoteRepositorySystemKey": "com.apple.dt.Xcode.sourcecontrol.Git",
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryURLKey": url,
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryTrustedCertFingerprintKey": fingerprint
        ]
    }
}

extension Bot.Configuration.Blueprint.Location {

    func toJSON(remoteID remoteID: String) -> [String: AnyObject] {
        return [
            remoteID: [
                "DVTSourceControlBranchIdentifierKey": branchName,
                "DVTSourceControlBranchOptionsKey": 1,
                "DVTSourceControlWorkspaceBlueprintLocationTypeKey": "DVTSourceControlBranch"
            ]
        ]
    }
}

extension Bot.Configuration.Blueprint.AuthenticationStrategy {

    func toJSON() -> [String: AnyObject] {
        guard case let .basic(username, password) = self else { return [:] }
        return [
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryUsernameKey": username,
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryPasswordKey": password,
            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationTypeKey": "DVTSourceControlBasicAuthenticationStrategy"
        ]
    }
}

private func +(lhs: [String: AnyObject], rhs: [String: AnyObject]) -> [String: AnyObject] {
    var result = lhs
    for (key, value) in rhs {
        result[key] = value
    }
    return result
}
