//
//  Bot.swift
//
//
//

import Foundation

struct Bot {

    var name: String
    let configuration: Configuration

    struct Configuration {

        enum Schedule {
            case periodically(Period)
            case commit
            case manual

            enum Period {
                case hourly(minuteOfIntegration: Int)
                case daily(hourOfIntegration: Int)
                case weekly(Day)

                enum Day: Int {
                    case monday = 1
                    case tuesday
                    case wednesday
                    case thursday
                    case friday
                    case saturday
                    case sunday
                }
            }

            func toInt() -> Int {
                switch self {
                case .periodically:
                    return 1
                case .commit:
                    return 2
                case .manual:
                    return 3
                }
            }
        }

        enum CleanFrequency: Int {
            case never
            case always
            case onceADay
            case onceAWeek
        }

        enum TestAction {
            case yes(CodeCoverage)
            case no

            enum CodeCoverage: Int {
                case useSchemeSetting = 1
                case enabled
                case disabled
            }
        }

        struct Trigger {
            enum Phase {
                case before
                case after(Conditions)

                struct Conditions: OptionSetType {

                    static let onWarnings = Conditions(rawValue: 1)
                    static let onBuildErrors = Conditions(rawValue: 2)
                    static let onInternalErrors = Conditions(rawValue: 4)
                    static let onAnalyzerWarnings = Conditions(rawValue: 8)
                    static let onFailingTests = Conditions(rawValue: 16)
                    static let onSuccess = Conditions(rawValue: 32)
                    let rawValue: Int

                    init(rawValue: Int) {
                        self.rawValue = rawValue
                    }
                }
            }

            let phase: Phase
            let name: String
            let scriptBody: String
        }

        struct Blueprint {

            struct Location {
                let branchName: String
            }

            struct Repository {
                let id: String
                let url: String
                let fingerprint: String
            }

            enum AuthenticationStrategy {
                case basic(String, String)
            }

            let location: Location
            let projectName: String
            let projectPath: String
            let authenticationStrategy: AuthenticationStrategy
            let repository: Repository
            var primaryRemoteID: String {
                return repository.id
            }
        }

        let schedule: Schedule
        let schemeName: String
        let builtFromClean: CleanFrequency
        let performsAnalyzeAction: Bool
        let performsTestAction: TestAction
        let exportsProductFromArchive: Bool
        let triggers: [Trigger]
        let sourceControlBlueprint: Blueprint
    }
}
