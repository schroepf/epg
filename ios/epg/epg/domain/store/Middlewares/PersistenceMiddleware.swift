import Foundation

func persistenceMiddleware(
    channelRepository: ChannelRepository,
    epgRepository: EpgRepository
) -> Middleware<AppDomain.State> {
    return { state, action, dispatch in
        switch action {
        case let AppDomain.Action.saveEpgData(epg):
            Task {
                do {
                    try await channelRepository.updateChannels(channels: epg?.channels)
                    print("Channels saved to DB: \(epg?.channels.count ?? 0)")
                    try await epgRepository.updateEpgData(epgEntries: epg?.epgEntries)
                    print("EpgEntries saved to DB: \(epg?.epgEntries.count ?? 0)")
                } catch {
                    fatalError(error.localizedDescription)
                }
            }

        case ChannelsDomain.Action.fetchAllChannels:
            Task {
                let channels = try await channelRepository.getAllChannels()
                dispatch(ChannelsDomain.Action.setChannels(channels: channels))
            }


        case let ChannelsDomain.Action.onChannelsEdited(channels):
            Task {
                try await channelRepository.updateChannels(channels: channels)
                dispatch(ChannelsDomain.Action.fetchAllChannels)
            }

        default:
            break
        }
    }
}
