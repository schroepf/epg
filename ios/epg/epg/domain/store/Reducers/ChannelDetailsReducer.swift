func channelDetailsReducer(state: [String: ChannelDetailsState], action: Action) -> [String: ChannelDetailsState] {
    switch action {
    case let action as SetChannelDetails:
        guard let channelId = action.channel?.id else {
            return state
        }

        var result = state
        result[channelId] = ChannelDetailsState(channel: action.channel, epgData: action.epgData)
        return result
    default:
        return state
    }
}
