struct SetChannelDetails: Action {
    let channel: Channel?
    let currentEpgEntry: EpgEntry?
    let epgData: [EpgEntry]?
}
