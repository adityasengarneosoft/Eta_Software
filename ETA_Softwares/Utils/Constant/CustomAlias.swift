 

import Foundation
typealias AnyDict = [String: Any]
typealias AnyDictString = [String: String]
typealias emptyCompletionHandler = (Bool)->()
typealias completionHandler = ()->()
var userListDict: UserList?
var pList = [PostList]()
typealias NoemptyCompletionHandler = (UserList)->()
typealias LocalPostemptyCompletionHandler = ([PostList])->()
typealias PostListDetailsCompletionHandler = (PostDetails)->()
