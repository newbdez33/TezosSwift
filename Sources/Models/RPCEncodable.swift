//
//  RPCEncodable.swift
//  TezosSwift
//
//  Created by Marek Fořt on 11/26/18.
//  Copyright © 2018 Keefer Taylor. All rights reserved.
//

import Foundation

protocol RPCEncodable: Encodable {
    func encodeRPC<K: CodingKey>(in container: inout KeyedEncodingContainer<K>, forKey key: KeyedEncodingContainer<K>.Key) throws
    func encodeRPC<T: UnkeyedEncodingContainer>(in container: inout T) throws
}

extension Array: RPCEncodable where Element: Encodable {
    func encodeRPC<K: CodingKey>(in container: inout KeyedEncodingContainer<K>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        var nestedContainer = container.nestedUnkeyedContainer(forKey: key)
        try forEach { try nestedContainer.encodeRPC($0) }
    }

    func encodeRPC<T: UnkeyedEncodingContainer>(in container: inout T) throws {
        var nestedContainer = container.nestedUnkeyedContainer()
        try forEach { try nestedContainer.encodeRPC($0) }
    }
}

extension Set: RPCEncodable where Element: Encodable {
    func encodeRPC<K: CodingKey>(in container: inout KeyedEncodingContainer<K>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        var nestedContainer = container.nestedUnkeyedContainer(forKey: key)
        try forEach { try nestedContainer.encodeRPC($0) }
    }

    func encodeRPC<T: UnkeyedEncodingContainer>(in container: inout T) throws {
        var nestedContainer = container.nestedUnkeyedContainer()
        try forEach { try nestedContainer.encodeRPC($0) }
    }
}

extension Int: RPCEncodable {
    func encodeRPC<K: CodingKey>(in container: inout KeyedEncodingContainer<K>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self, forKey: key)
        try nestedContainer.encode("\(self)", forKey: .int)
    }

    func encodeRPC<T: UnkeyedEncodingContainer>(in container: inout T) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self)
        try nestedContainer.encode("\(self)", forKey: .int)
    }
}

extension UInt: RPCEncodable {
    func encodeRPC<K: CodingKey>(in container: inout KeyedEncodingContainer<K>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self, forKey: key)
        try nestedContainer.encode("\(self)", forKey: .int)
    }

    func encodeRPC<T: UnkeyedEncodingContainer>(in container: inout T) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self)
        try nestedContainer.encode("\(self)", forKey: .int)
    }
}

extension String: RPCEncodable {
    func encodeRPC<K: CodingKey>(in container: inout KeyedEncodingContainer<K>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self, forKey: key)
        try nestedContainer.encode(self, forKey: .string)
    }

    func encodeRPC<T: UnkeyedEncodingContainer>(in container: inout T) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self)
        try nestedContainer.encode(self, forKey: .string)
    }
}

extension Bool: RPCEncodable {
    func encodeRPC<K: CodingKey>(in container: inout KeyedEncodingContainer<K>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self, forKey: key)
        try nestedContainer.encode("\(self)".capitalized, forKey: .prim)
    }

    func encodeRPC<T: UnkeyedEncodingContainer>(in container: inout T) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self)
        try nestedContainer.encode("\(self)".capitalized, forKey: .prim)
    }
}

extension Data: RPCEncodable {
    func encodeRPC<K: CodingKey>(in container: inout KeyedEncodingContainer<K>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self, forKey: key)
        try nestedContainer.encode(self, forKey: .bytes)
    }

    func encodeRPC<T: UnkeyedEncodingContainer>(in container: inout T) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self)
        try nestedContainer.encode(self, forKey: .bytes)
    }
}

extension Optional: RPCEncodable where Wrapped: RPCEncodable {
    func encodeRPC<K: CodingKey>(in container: inout KeyedEncodingContainer<K>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        var nestedContainer = container.nestedContainer(keyedBy: StorageKeys.self, forKey: key)
        switch self {
        case .none:
            try nestedContainer.encode("None", forKey: .prim)
        case .some(let value):
            try nestedContainer.encode("Some", forKey: .prim)
            var argsContainer = nestedContainer.nestedUnkeyedContainer(forKey: .args)
            try argsContainer.encodeRPC(value)
        }
    }

    func encodeRPC<T: UnkeyedEncodingContainer>(in container: inout T) throws {

    }
}

extension KeyedEncodingContainer {
    mutating func encodeRPC<T: Encodable>(_ value: T, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let unwrappedValue = value as? RPCEncodable {
            try unwrappedValue.encodeRPC(in: &self, forKey: key)
        } else {
            try encode(value, forKey: key)
        }
    }
}

extension UnkeyedEncodingContainer {
    func encodingError(_ value: Any) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Encoding failed")
        return EncodingError.invalidValue(value, context)
    }

    // TODO: Encode if present when params optionals!
    mutating func encodeRPC<T: Encodable>(_ value: T) throws {
        if let unwrappedValue = value as? RPCEncodable {
            try unwrappedValue.encodeRPC(in: &self)
        } else {
            try encode(value)
        }
    }
}
