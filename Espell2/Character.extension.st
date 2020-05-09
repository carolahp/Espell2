Extension { #name : #Character }

{ #category : #'*Espell2' }
Character >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ anEP2ObjectSpace fromLocalCharacter: self
]
