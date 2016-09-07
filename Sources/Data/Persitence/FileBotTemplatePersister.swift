//
//  FileBotTemplatePersister.swift
//
//
//

import Foundation

class FileBotTemplatePersister: BotTemplateSaver {

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

    func save(template: BotTemplate) {
        template.data.writeToFile(file, atomically: true)
    }
}
