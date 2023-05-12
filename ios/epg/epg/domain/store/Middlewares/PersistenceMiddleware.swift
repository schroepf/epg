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
                let mappedChannels = await withTaskGroup(of: ChannelItem.self) { group in
                    channels.forEach { channel in
                        group.addTask {
                            let epg = try? await epgRepository.getEpgEntry(channelId: channel.id, at: Date.now)
                            return ChannelItem(id: channel.id, channel: channel, currentEpg: epg)
                        }
                    }

                    return await group.reduce(into: [ChannelItem]()) { result, item in result += [item] }
                }
                dispatch(ChannelsDomain.Action.setChannels(channels: mappedChannels))
            }


        case let ChannelsDomain.Action.onChannelsEdited(channels):
            Task {
                try await channelRepository.updateChannels(channels: channels)
                dispatch(ChannelsDomain.Action.fetchAllChannels)
            }

        case let ChannelDetailsDomain.Action.fetchChannelDetails(channelId):
            Task {
                let selectedChannel = try await channelRepository.getChannel(channelId: channelId)

                guard let selectedChannel else {
                    dispatch(ChannelDetailsDomain.Action.setChannelDetails(channel: nil, currentEpgEntry: nil, epgData: nil))
                    return
                }
                
                let epgData = try await epgRepository.getEpgDataByChannel(channelId: selectedChannel.id)
                let currentEpgEntry = try await epgRepository.getEpgEntry(channelId: selectedChannel.id, at: Date())
                dispatch(ChannelDetailsDomain.Action.setChannelDetails(channel: selectedChannel, currentEpgEntry: currentEpgEntry, epgData: epgData))
            }

        default:
            break
        }
    }
}
