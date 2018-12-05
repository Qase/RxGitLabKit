import Foundation

public struct Identities: Codable {
	public let provider: String?
	public let externUID: String?

	enum CodingKeys: String, CodingKey {
		case provider
		case externUID = "extern_uid"
	}
}
