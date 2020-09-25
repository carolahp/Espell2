Extension { #name : #Association }

{ #category : #'*Espell2' }
Association >> asRemoteObjectInObjectSpace: anEPObjectSpace [ 
	^ anEPObjectSpace 
		newAssociationWithKey: (self key asRemoteObjectInObjectSpace: anEPObjectSpace ) 
		andValue: (self value asRemoteObjectInObjectSpace: anEPObjectSpace)
]
