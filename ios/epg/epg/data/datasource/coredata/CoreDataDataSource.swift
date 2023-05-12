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
    func getAll() async throws -> [ChannelItem] {
        return try await viewContext.perform {
            let request = ChannelEntity.fetchRequest()
            request.sortDescriptors = [
                .init(SortDescriptor(\ChannelEntity.sortOrder, order: .forward))
            ]

            let channelEntities = try self.viewContext
                .fetch(request)

            return try channelEntities.compactMap { channelEntity in
                guard let channel = Channel(entity: channelEntity) else {
                    return nil
                }

                return try self.viewContext
                    .fetchEpgEntry(for: channel.id, at: Date.now)
                    .map { epgEntity in
                        ChannelItem(
                            id: channel.id,
                            isFavorite: channelEntity.favorite,
                            channel: channel,
                            currentEpg: EpgEntry(entity: epgEntity)
                        )
                    }

            }
        }
    }

    func saveAll(channels: [ChannelItem]?) async throws {
        let context = backgroundContext
        try await context.perform {
            try context.deleteAllEntities(entityType: ChannelEntity.self)

            try channels?.enumerated().forEach { index, channelItem in
                let channelEntity = ChannelEntity(context: context)

                channelEntity.id = channelItem.id
                channelEntity.name = channelItem.channel.name
                channelEntity.iconUrl = channelItem.channel.icon?.url

                channelEntity.sortOrder = Int32(index)
                channelEntity.favorite = channelItem.isFavorite

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

extension EpgEntryEntity {
    static func fetchRequest(channelId: String, date: Date) -> NSFetchRequest<EpgEntryEntity> {
        let request = Self.fetchRequest()
        request.predicate = NSPredicate(format: "(channelId == %@) AND (start <= %@) AND (stop >= %@)", channelId, date as CVarArg, date as CVarArg)
        return request
    }
}

extension NSManagedObjectContext {
    func fetchEpgEntry(for channelId: String, at date: Date) throws -> EpgEntryEntity? {
        try fetch(EpgEntryEntity.fetchRequest(channelId: channelId, date: date)).first
    }

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
