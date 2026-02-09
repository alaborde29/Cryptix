import Foundation

/// Errors that can occur during network operations
enum NetworkError: LocalizedError {
    case noConnection
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case encodingError(Error)
    case timeout
    case serverError(String)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No internet connection. Please check your network settings."
        case .invalidURL:
            return "Invalid URL. Please try again."
        case .invalidResponse:
            return "Invalid response from server."
        case .httpError(let statusCode):
            return "Server error (Code: \(statusCode))"
        case .decodingError:
            return "Failed to process server response."
        case .encodingError:
            return "Failed to prepare request."
        case .timeout:
            return "Request timed out. Please try again."
        case .serverError(let message):
            return message
        case .unknown:
            return "An unexpected error occurred."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .noConnection:
            return "Check your WiFi or cellular connection and try again."
        case .timeout:
            return "The server is taking too long to respond. Try again later."
        case .httpError(let statusCode) where statusCode >= 500:
            return "The server is experiencing issues. Please try again later."
        case .httpError:
            return "There was a problem with your request. Please try again."
        default:
            return "Please try again later."
        }
    }

    var isRetryable: Bool {
        switch self {
        case .noConnection, .timeout:
            return true
        case .httpError(let code) where code >= 500:
            return true
        default:
            return false
        }
    }
}
