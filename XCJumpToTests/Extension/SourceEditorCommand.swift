//
//  SourceEditorCommand.swift
//  Extension
//
//  Created by Yoshitaka Seki on 2017/12/03.
//  Copyright © 2017年 takasek. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    struct MyError: CustomNSError {
        let message: String
        var errorUserInfo: [String : Any] {
            return [NSLocalizedDescriptionKey: message]
        }
    }
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let connection = NSXPCConnection(serviceName: "io.github.takasek.XCJumpToTests.XcodeHelper")
        connection.remoteObjectInterface = NSXPCInterface(with: XcodeHelperProtocol.self)
        connection.resume()
        defer { connection.invalidate() }

        let xcode = connection.remoteObjectProxy as! XcodeHelperProtocol

        let semaphore = DispatchSemaphore(value: 0)

        var error: MyError? = nil
        xcode.jumpToTests { (errorMessage) in
            error = errorMessage.flatMap(MyError.init(message:))
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + 10)

        completionHandler(error)
    }
    
}
