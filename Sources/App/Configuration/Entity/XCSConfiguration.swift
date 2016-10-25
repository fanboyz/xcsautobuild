
struct XCSConfiguration: Equatable {
    let host: String
    let userName: String
    let password: String
}

func ==(lhs: XCSConfiguration, rhs: XCSConfiguration) -> Bool {
    return lhs.host == rhs.host
        && lhs.userName == rhs.userName
        && lhs.password == rhs.password
}
