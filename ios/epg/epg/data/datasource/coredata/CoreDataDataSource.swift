import Foundation
import CoreData

class CoreDataDataSource {
    private let container: NSPersistentContainer

    private lazy var viewContext: NSManagedObjectContext = container.viewContext
    private lazy var backgroundContext: NSManagedObjectContext = container.newBackgroundContext()

    init(){
        container = NSPersistentContainer(name: "EpgModel")
        container.loadPersistentStores { description, error in

            if error != nil {
                fatalError("Cannot Load Core Data Model")
            }
        }
    }
}

extension CoreDataDataSource: ChannelDataSource {
    func getAll() async throws -> [Channel] {
        return try await viewContext.perform {
            let request = ChannelEntity.fetchRequest()

            return try self.viewContext
                .fetch(request)
                .compactMap { channelEntity in
                    Channel(entity: channelEntity)
                }
        }
    }

    func getChannel(channelId: String) async throws -> Channel? {
        return try await viewContext.perform {
            let request = ChannelEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", channelId)

            return try self.viewContext
                .fetch(request)
                .compactMap { channelEntity in
                    Channel(entity: channelEntity)
                }
                .first
        }
    }

    func saveAll(channels: [Channel]?) async throws {
        let context = backgroundContext
        try await context.perform {
            try context.deleteAllEntities(entityType: ChannelEntity.self)

            try channels?.forEach { channel in
                let channelEntity = ChannelEntity(context: context)

                channelEntity.id = channel.id
                channelEntity.name = channel.name
                channelEntity.iconUrl = channel.icon?.url

                try context.saveIfNeeded()
            }
        }
    }
}

extension CoreDataDataSource: EpgDataSource {
    func saveAll(epgEntries: [EpgEntry]?) async throws {
        let context = backgroundContext

        try await context.perform {
            try context.deleteAllEntities(entityType: EpgEntryEntity.self)

            try epgEntries?.forEach { epgEntry in
                let channelEntity = EpgEntryEntity(context: context)

                channelEntity.channelId = epgEntry.channelId
                channelEntity.title = epgEntry.title
                channelEntity.summary = epgEntry.summary
                channelEntity.start = epgEntry.start
                channelEntity.stop = epgEntry.stop
                channelEntity.artworkUrl = epgEntry.artwork?.url

                try context.saveIfNeeded()
            }
        }
    }

    func getEntries(channelId: String) async throws -> [EpgEntry] {
        return try await viewContext.perform {
            let request = EpgEntryEntity.fetchRequest()
            request.predicate = NSPredicate(format: "channelId == %@", channelId)

            return try self.viewContext
                .fetch(request)
                .compactMap { epgEntity in
                    EpgEntry(entity: epgEntity)
                }
        }
    }

    func getEntry(channelId: String, at date: Date) async throws -> EpgEntry? {
        return try await viewContext.perform {
            let request = EpgEntryEntity.fetchRequest()
            request.predicate = NSPredicate(format: "(channelId == %@) AND (start <= %@) AND (stop >= %@)", channelId, date as CVarArg, date as CVarArg)

            return try self.viewContext
                .fetch(request)
                .compactMap { epgEntity in
                    EpgEntry(entity: epgEntity)
                }
                .first
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

        self.init(
            channelId: channeldId,
            title: title,
            summary: entity.summary,
            start: start,
            stop: stop,
            artwork: entity.artworkUrl.map { .init(url: $0) }
        )
    }
}

extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        guard hasChanges else {
            return
        }

        try save()
    }

    func deleteAllEntities(entityType: NSManagedObject.Type) throws {
        let fetchRequest: NSFetchRequest<any NSFetchRequestResult> = entityType.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try execute(batchDeleteRequest)
        try saveIfNeeded()
    }
}
