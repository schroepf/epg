struct AppState: ReduxState {
    var channelsState = ChannelsState(channels: nil)
    var channelDetailsState: [String: ChannelDetailsState] = .init()
}
