//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class FileBotTemplatePersister: BotTemplateSaver, BotTemplateLoader {

    private let file: String
    private let dataLoader: DataLoader

    init(file: String, dataLoader: DataLoader = DefaultDataLoader()) {
        self.file = file
        self.dataLoader = dataLoader
    }

    func load() -> BotTemplate? {
        guard let data = dataLoader.loadData(from: file),
              let name = FlexiJSON(data: data)["name"].string else { return nil }
        return BotTemplate(name: name, data: data)
    }

    func save(_ template: BotTemplate) {
        // TODO:
        try? template.data.write(to: Foundation.URL(fileURLWithPath: file), options: [.atomic])
    }
}
