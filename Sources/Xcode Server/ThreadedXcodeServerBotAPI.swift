//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class ThreadedXcodeServerBotAPI: BotCreator, BotDeleter, BotTemplatesFetcher {

    private let api: XcodeServerBotAPI
    private let queue: dispatch_queue_t = {
        let attributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND, 0);
        return dispatch_queue_create("codes.seanhenry.xcs.network.queue", attributes)
    }()

    init(api: XcodeServerBotAPI) {
        self.api = api
    }

    func createBot(forBranch branch: Branch) {
        doAsync {
            self.api.createBot(forBranch: branch)
        }
    }

    func deleteBot(forBranch branch: Branch) {
        doAsync {
            self.api.deleteBot(forBranch: branch)
        }
    }

    func fetchBotTemplates(completion: ([BotTemplate]) -> ()) {
        doAsync { 
            self.api.fetchBotTemplates(self.wrapInMainThread(completion))
        }
    }

    private func doAsync(work: () -> ()) {
        dispatch_async(queue, work)
    }

    private func wrapInMainThread<T>(work: (T) -> ()) -> (T) -> () {
        return GCDHelper().wrapInMainThread(work)
    }
}
