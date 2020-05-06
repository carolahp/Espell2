Extension { #name : #Integer }

{ #category : #'*Espell2' }
Integer >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ (anEP2ObjectSpace fromLocalInteger: self) asRemoteSmallInteger
]
