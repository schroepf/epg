import Foundation
import CoreData

struct CoreDataDataSource {
    private let container: NSPersistentContainer

    private var context: NSManagedObjectContext {
        container.viewContext
    }

    init(){
        container = NSPersistentContainer(name: "EpgModel")
        container.loadPersistentStores { description, error in

            if error != nil {
                fatalError("Cannot Load Core Data Model")
            }
        }
    }

    private func deleteAllEntities(entityType: NSManagedObject.Type) throws {
        let fetchRequest: NSFetchRequest<any NSFetchRequestResult> = entityType.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try context.execute(batchDeleteRequest)
        try saveContext()
    }

    private func saveContext() throws {
        guard context.hasChanges else {
            return
        }

        try context.save()
    }
}

extension CoreDataDataSource: ChannelDataSource {
    func getAll() async throws -> [Channel] {
        let request = ChannelEntity.fetchRequest()

        return try container.viewContext
            .fetch(request)
            .compactMap { channelEntity in
                Channel(entity: channelEntity)
            }
    }

    func saveAll(channels: [Channel]?) async throws {
        try deleteAllEntities(entityType: ChannelEntity.self)

        try channels?.forEach { channel in
            let channelEntity = ChannelEntity(context: container.viewContext)

            channelEntity.id = channel.id
            channelEntity.name = channel.name
            channelEntity.iconUrl = channel.icon?.url
            
            try saveContext()
        }
    }
}

extension CoreDataDataSource: EpgDataSource {
    func saveAll(epgEntries: [EpgEntry]?) async throws {
        try deleteAllEntities(entityType: EpgEntryEntity.self)

        try epgEntries?.forEach { epgEntry in
            let channelEntity = EpgEntryEntity(context: container.viewContext)

            channelEntity.channelId = epgEntry.channelId
            channelEntity.title = epgEntry.title
            channelEntity.summary = epgEntry.summary
            channelEntity.start = epgEntry.start
            channelEntity.stop = epgEntry.stop

            try saveContext()
        }

    }

    func getEntries(channelId: String) async throws -> [EpgEntry] {
        let request = EpgEntryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "channelId == %@", channelId)

        return try container.viewContext
            .fetch(request)
            .compactMap { epgEntity in
                EpgEntry(entity: epgEntity)
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

extension EpgEntry {
    init?(entity: EpgEntryEntity) {
        guard let channeldId = entity.channelId, let title = entity.title, let start = entity.start, let stop = entity.stop else {
            return nil
        }

        self.init(channelId: channeldId, title: title, summary: entity.summary, start: start, stop: stop)
    }
}
