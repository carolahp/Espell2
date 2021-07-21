Extension { #name : #BlockClosure }

{ #category : #'*Espell2' }
BlockClosure >> asPBInstructionFor: aLanguageModel [
	^ PBInstruction newFromBlock: self for: aLanguageModel
]
