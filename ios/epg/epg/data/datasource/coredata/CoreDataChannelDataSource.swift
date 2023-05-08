import Foundation
import CoreData

struct CoreDataChannelDataSource: ChannelDataSource {
    let container: NSPersistentContainer

    init(){
        container = NSPersistentContainer(name: "EpgModel")
        container.loadPersistentStores { description, error in

            if error != nil {
                fatalError("Cannot Load Core Data Model")
            }
        }
    }

    func getAll() async throws -> [Channel] {
        let request = ChannelEntity.fetchRequest()

        return try container.viewContext
            .fetch(request)
            .compactMap { channelEntity in
                Channel(entity: channelEntity)
            }
    }

    func saveAll(channels: [Channel]?) async {
        channels?.forEach { channel in
            let channelEntity = ChannelEntity(context: container.viewContext)
            channelEntity.id = channel.id
            channelEntity.name = channel.name
            channelEntity.iconUrl = channel.icon?.url
        }

        saveContext()
    }

    private func saveContext(){
        let context = container.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension Channel {
    init?(entity: ChannelEntity) {
        guard let id = entity.id, let name = entity.name else {
            return nil
        }

        self.init(id: id, name: name, icon: entity.iconUrl.map { .init(url: $0) })
    }
}
