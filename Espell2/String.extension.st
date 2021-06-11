Extension { #name : #String }

{ #category : #'*Espell2' }
String >> asPBInstructionFor: aLanguageModel [
	^ PBInstruction newFromString: self for: aLanguageModel
]
