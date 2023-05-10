struct ChannelDetailsState: ReduxState {
    let channel: Channel?
    let currentEpgEntry: EpgEntry?
    let epgData: [EpgEntry]?
}
