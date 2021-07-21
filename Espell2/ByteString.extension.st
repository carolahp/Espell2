Extension { #name : #ByteString }

{ #category : #'*Espell2' }
ByteString >> asRemoteObjectInObjectSpace: anEPObjectSpace [ 
	^ anEPObjectSpace fromLocalByteString: self
]
