Extension { #name : #Float }

{ #category : #'*Espell2' }
Float >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 

	^anEP2ObjectSpace fromLocalFloat: self
]
