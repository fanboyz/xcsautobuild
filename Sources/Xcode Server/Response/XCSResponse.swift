
struct XCSResponse<ResponseType> {
    let data: ResponseType
    let statusCode: Int
    
    var isSuccess: Bool {
        return (200...299).contains(statusCode)
    }
}
