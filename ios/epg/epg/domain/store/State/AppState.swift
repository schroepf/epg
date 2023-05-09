struct AppState: ReduxState {
    var channelsState = ChannelsState(channels: nil)
    var channelDetailsState = ChannelDetailsState(channel: nil)
}
