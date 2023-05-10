import Foundation

func persistenceMiddleware(
    channelRepository: ChannelRepository,
    epgRepository: EpgRepository
) -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
        case let action as SaveEpgData:
            Task {
                do {
                    let epg = action.epg
                    try await channelRepository.updateChannels(channels: epg?.channels)
                    print("Channels saved to DB: \(epg?.channels.count ?? 0)")
                    try await epgRepository.updateEpgData(epgEntries: epg?.epgEntries)
                    print("EpgEntries saved to DB: \(epg?.epgEntries.count ?? 0)")
                } catch {
                    fatalError(error.localizedDescription)
                }
            }

        case _ as LoadChannels:
            Task {
                let channels = try await channelRepository.getAllChannels()
                dispatch(SetChannels(result: channels))
            }

        case let action as LoadChannelDetails:
            Task {
                let selectedChannel = try await channelRepository.getChannel(channelId: action.channelId)

                guard let selectedChannel else {
                    dispatch(SetChannelDetails(channel: nil, currentEpgEntry: nil, epgData: nil))
                    return
                }
                
                let epgData = try await epgRepository.getEpgDataByChannel(channelId: selectedChannel.id)
                let currentEpgEntry = try await epgRepository.getEpgEntry(channelId: selectedChannel.id, at: Date())
                dispatch(SetChannelDetails(channel: selectedChannel, currentEpgEntry: currentEpgEntry, epgData: epgData))
            }

        default:
            break
        }
    }
}

