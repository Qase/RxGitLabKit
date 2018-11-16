import Foundation
public struct Identities: Codable {
	public let provider: String?
	public let externUID: String?

	enum CodingKeys: String, CodingKey {
		case provider
		case externUID = "extern_uid"
	}

  public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		provider = try values.decodeIfPresent(String.self, forKey: .provider)
		externUID = try values.decodeIfPresent(String.self, forKey: .externUID)
	}

}
