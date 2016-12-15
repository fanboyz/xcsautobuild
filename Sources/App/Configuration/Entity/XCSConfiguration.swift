
struct XCSConfiguration: Equatable {
    var host: String
    var userName: String
    var password: String
}

func ==(lhs: XCSConfiguration, rhs: XCSConfiguration) -> Bool {
    return lhs.host == rhs.host
        && lhs.userName == rhs.userName
        && lhs.password == rhs.password
}
