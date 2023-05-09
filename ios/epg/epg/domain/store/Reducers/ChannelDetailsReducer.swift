func channelDetailsReducer(state: ChannelDetailsState, action: Action) -> ChannelDetailsState {
    switch action {
    case let action as SetChannelDetails:
        return ChannelDetailsState(channel: action.channel)
    default:
        return state
    }
}
