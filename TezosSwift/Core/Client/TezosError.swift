import Foundation

/// Error when interacting with RPC
public enum RPCReason {
    /// Generic Error
    case generic(message: String)
    /// Unknown Error
    case unknown(message: String)
    /// RPC Call resulted in no data
    case noData
    /// Sent wrong RPC format
    case unexpectedRequestFormat(message: String)
    /// Node URL was invalid
    case invalidNode
    /// Generic response error
    case responseError(code: Int, message: String)
}

extension RPCReason: Decodable {
    private enum CodingKeys: String, CodingKey {
        case kind
        case error
    }

    private enum Kind: String, Decodable {
        case generic
    }

    public init(from decoder: Decoder) throws {
        var unkeyedContainer = try decoder.unkeyedContainer()
        let container = try unkeyedContainer.nestedContainer(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)
        let message = try container.decodeIfPresent(String.self, forKey: .error)

        switch kind {
        case .generic:
            self = .generic(message: message ?? "")
        }
    }
}

public enum DecryptionReason {
    /// Tried to decode unsupported Tezos type
    case unsupportedTezosType
    /// Unable to decode response
    case responseError(decodingError: Error)
    /// Unknown decryption error
    case unknown
}

public enum EncryptionReason {
	/// No payload to encode
	case noPayload
	/// Unable to encode request
	case requestError(encodingError: Error)
	/// Unknown encryption error
	case unknown
}

/// Errors when converting Swift parameters to Tezos data structure
public enum ParameterReason {
    /// At least one value in Michelson or type has to be non-nil
    case orError
}

public enum InjectReason {
    /// Could not decode metadata in order to successfully inject operation
    case missingMetadata
    /// Error during creation JSON signed bytes
    case jsonSigningFailed
    /// Error during forging operation
    case forgeError
    /// Not enough gas
    case gasExhaustion
    /// Unknown inject error
    case unknown(message: String)
}

/// Error emitted during preapply
public enum PreapplyReason {
    /// Error emitted by preapply operation
    case operationError(_ error: PreapplyError)
    /// Unable to assign to any known error
    case unknown
}

/// Tezos Swift Error
public enum TezosError: Error {
    /// Unable to assign to any known error
    case unknown(message: String)
    /// Error when sending operation
    case rpcFailure(reason: RPCReason)
    /// Error during preapplying operation
    case preapplyError(reason: PreapplyReason)
    /// Error during process of applying operation
    case injectError(reason: InjectReason)
    /// Error while trying to parse Swift types to Tezos types
    case parameterError(reason: ParameterReason)
    /// Error when decoding Tezos response data
    case decryptionFailed(reason: DecryptionReason)
    /// Error when encrypting data
    case encryptionFailed(reason: EncryptionReason)
	/// Error when canceling operation
	case canceled
}

extension TezosError: ErrorConvertible {
	public static func error(from error: Error) -> TezosError {
		return .unknown(message: error.localizedDescription)
	}
}

extension TezosError: CancelProtocol {
	public static let cancel: TezosError = .canceled
}
