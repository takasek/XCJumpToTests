#!/usr/bin/osascript

use AppleScript version "2.4" # Yosemite or later
use scripting additions
use framework "Foundation"

on run
	tell application "Xcode"
		# Xcodeで表示中のファイルの情報を取得
		set projectPath to path of active workspace document
		set projectFolder to characters 1 thru -((offset of "/" in (reverse of items of projectPath as string)) + 1) of projectPath as string
		# display dialog projectFolder
		set sourceName to (get name of window 1)
		# display dialog sourceName
		
		# Hoge.swift ⇄ HogeTests.swift のトグル変換
		set w1 to ".swift"
		set w2 to "Tests.swift"
		if sourceName contains w2 then
			set destinationName to (my replaceThis:(w2 & ".*") inString:sourceName usingThis:w1)
		else
			set destinationName to (my replaceThis:(w1 & ".*") inString:sourceName usingThis:w2)
		end if
		# display dialog destinationName
		
		# ファイルパスを探して開く
		set command to "/usr/bin/mdfind -onlyin " & quoted form of projectFolder & " -name " & quoted form of destinationName
		# display dialog command
		set destinationPath to do shell script command
		if length of destinationPath > 0 then
			open destinationPath
		else
			display dialog "the file" & quoted form of destinationName & " not found."
		end if
	end tell
end run

# 正規表現置換
on replaceThis:thePattern inString:theString usingThis:theTemplate
	set theNSString to current application's NSString's stringWithString:theString
	set theOptions to (current application's NSRegularExpressionDotMatchesLineSeparators as integer) + (current application's NSRegularExpressionAnchorsMatchLines as integer)
	set theRegEx to current application's NSRegularExpression's regularExpressionWithPattern:thePattern options:theOptions |error|:(missing value)
	set theResult to theRegEx's stringByReplacingMatchesInString:theNSString options:0 range:{location:0, |length|:theNSString's |length|()} withTemplate:theTemplate
	return theResult as text
end replaceThis:inString:usingThis:
