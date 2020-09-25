Extension { #name : #Array }

{ #category : #'*Espell2' }
Array >> asRemoteObjectInObjectSpace: anEPObjectSpace [ 
	^ anEPObjectSpace 
			newRemoteArrayWithAll: (self collect: [ :each | each asRemoteObjectInObjectSpace: anEPObjectSpace ])
]
