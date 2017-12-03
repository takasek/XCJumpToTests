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
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.

        let connection = NSXPCConnection(serviceName: "io.github.takasek.XCJumpToTests.XcodeHelper")
        connection.remoteObjectInterface = NSXPCInterface(with: XcodeHelperProtocol.self)
        connection.resume()
        let xcode = connection.remoteObjectProxy as! XcodeHelperProtocol

        let semaphore = DispatchSemaphore(value: 0)
        xcode.upperCaseString("aaaa") { (str) in
            invocation.buffer.lines.add(str!)
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + 10)
        
        completionHandler(nil)
    }
    
}
