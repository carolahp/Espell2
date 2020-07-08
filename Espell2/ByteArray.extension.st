Extension { #name : #ByteArray }

{ #category : #'*Espell2' }
ByteArray >> asRemoteObjectInObjectSpace: anObjectSpace [
	self halt: 'next call should ask for implementation in objectspace'.
	^anObjectSpace fromLocalByteArray: self
]
