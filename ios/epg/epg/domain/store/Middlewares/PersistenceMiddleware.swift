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
                let channels = await channelRepository.getAllChannels()
                dispatch(SetChannels(result: channels))
            }

        case let action as LoadChannelDetails:
            Task {
                // TODO: Use .getChannel(channelId: String) instead!
                // TODO: let channelrepository throw errors instead
                let selectedChannel = await channelRepository.getAllChannels()
                    .valueOrNil?
                    .first { $0.id == action.channelId }

                guard let selectedChannel else {
                    dispatch(SetChannelDetails(channel: nil, epgData: nil))
                    return
                }
                
                let epgData = await epgRepository.getEpgDataByChannel(channelId: selectedChannel.id)
                dispatch(SetChannelDetails(channel: selectedChannel, epgData: epgData.valueOrNil))
            }

        default:
            break
        }
    }
}

