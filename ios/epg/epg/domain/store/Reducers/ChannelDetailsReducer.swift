func channelDetailsReducer(state: ChannelDetailsState, action: Action) -> ChannelDetailsState {
    switch action {
    case let action as SetChannelDetails:
        return ChannelDetailsState(channel: action.channel, epgData: action.epgData)
    default:
        return state
    }
}
