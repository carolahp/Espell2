Extension { #name : #Dictionary }

{ #category : #'*Espell2' }
Dictionary >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ anEP2ObjectSpace newRemoteDictionaryFrom: self
]
