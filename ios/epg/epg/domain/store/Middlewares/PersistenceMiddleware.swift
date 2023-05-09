import Foundation

func persistenceMiddleware(epgRepository: ChannelRepository) -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
        case let action as SaveEpgData:
            Task {
                do {
                    try await epgRepository.updateChannels(channels: action.epg?.channels)
                } catch {
                    fatalError(error.localizedDescription)
                }
            }

        case _ as LoadChannels:
            Task {
                let channels = await epgRepository.getAllChannels()
                dispatch(SetChannels(result: channels))
            }

        case let action as LoadChannelDetails:
            Task {
                let selectedChannel = await epgRepository.getAllChannels()
                    .valueOrNil?
                    .first { $0.id == action.channelId }
                dispatch(SetChannelDetails(channel: selectedChannel))
            }

        default:
            break
        }
    }
}

