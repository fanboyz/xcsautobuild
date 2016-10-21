
import Foundation

class ThreadedXcodeServerBotAPI: BotDeleter, BotTemplatesFetcher {

    private let api: XcodeServerBotAPI
    private let queue: DispatchQueue = {
        return DispatchQueue(label: "codes.seanhenry.xcs.network.queue", qos: .background, target: nil)
    }()

    init(api: XcodeServerBotAPI) {
        self.api = api
    }

    func deleteBot(forBranch branch: Branch) {
        doAsync {
            self.api.deleteBot(forBranch: branch)
        }
    }

    func fetchBotTemplates(_ completion: @escaping ([BotTemplate]) -> ()) {
        doAsync { 
            self.api.fetchBotTemplates(self.wrapInMainThread(completion))
        }
    }

    private func doAsync(_ work: @escaping () -> ()) {
        queue.async(execute: work)
    }

    private func wrapInMainThread<T>(_ work: @escaping (T) -> ()) -> (T) -> () {
        return GCDHelper().wrapInMainThread(work)
    }
}
