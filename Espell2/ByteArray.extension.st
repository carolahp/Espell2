Extension { #name : #ByteArray }

{ #category : #'*Espell2' }
ByteArray >> asRemoteObjectInObjectSpace: anObjectSpace [
	^anObjectSpace fromLocalByteArray: self
]
