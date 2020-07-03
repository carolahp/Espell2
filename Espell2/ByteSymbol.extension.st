Extension { #name : #ByteSymbol }

{ #category : #'*Espell2' }
ByteSymbol >> asRemoteObjectInObjectSpace: anObjectSpace [

	^anObjectSpace fromLocalByteSymbol: self
]
