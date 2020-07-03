Extension { #name : #SmallInteger }

{ #category : #'*Espell2' }
SmallInteger >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ (anEP2ObjectSpace fromLocalInteger: self) asRemoteSmallInteger
]
