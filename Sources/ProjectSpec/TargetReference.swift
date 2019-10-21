import Foundation
import JSONUtilities

public struct TargetReference: Hashable {
    public var name: String
    public var location: Location

    public enum Location: Hashable {
        case local
        case project(String)
    }

    public init(name: String, location: Location) {
        self.name = name
        self.location = location
    }
}

extension TargetReference {
    public init(string: String) throws {
        let paths = string.split(separator: "/")
        guard paths.count <= 2 && !paths.isEmpty else {
            throw SpecParsingError.invalidTargetReference(string)
        }
        switch paths.count {
        case 2:
            location = .project(String(paths[0]))
            name = String(paths[1])
        case 1:
            location = .local
            name = String(paths[0])
        default: fatalError("unreachable")
        }
    }

    public static func local(_ name: String) -> TargetReference {
        return TargetReference(name: name, location: .local)
    }
}

extension TargetReference: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        try! self.init(string: value)
    }
}

extension TargetReference: CustomStringConvertible {
    public var reference: String {
        switch location {
        case .local: return name
        case .project(let projectPath):
            return "\(projectPath)/\(name)"
        }
    }

    public var description: String {
        return reference
    }
}
