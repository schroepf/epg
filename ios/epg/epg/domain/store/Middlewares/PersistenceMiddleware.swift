import Foundation

func persistenceMiddleware(epgRepository: ChannelRepository) -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
        case let action as SaveEpgData:
            Task {
                await epgRepository.updateChannels(channels: action.epg?.channels)
            }

        case _ as LoadChannels:
            Task {
                let channels = await epgRepository.getAllChannels()
                dispatch(SetChannels(result: channels))
            }
        default:
            break
        }
    }
}
