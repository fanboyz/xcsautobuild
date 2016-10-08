//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class FileBotTemplatePersister: BotTemplateSaver, BotTemplateLoader {

    private let file: String
    private let dataLoader: DataLoader
    private let dataWriter: DataWriter

    init(file: String, dataLoader: DataLoader = DefaultDataLoader(), dataWriter: DataWriter = DefaultDataWriter()) {
        self.file = file
        self.dataLoader = dataLoader
        self.dataWriter = dataWriter
    }

    func load() -> BotTemplate? {
        guard let data = dataLoader.loadData(from: file),
              let name = FlexiJSON(data: data)["name"].string else { return nil }
        return BotTemplate(name: name, data: data)
    }

    func save(_ template: BotTemplate) {
        dataWriter.write(data: template.data, toFile: file)
    }
}
