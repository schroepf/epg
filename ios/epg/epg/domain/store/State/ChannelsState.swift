struct ChannelsState: ReduxState {
    let channels: [Channel]?

    func apply(result: Result<[Channel], ChannelError>) -> Self {
        switch result {
        case .success(let channels):
            return ChannelsState(channels: channels)
        case .failure(let error):
            print("Consuming error: \(error)")
            return self
        }
    }
}
