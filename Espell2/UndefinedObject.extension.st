Extension { #name : #UndefinedObject }

{ #category : #'*Espell2' }
UndefinedObject >> asRemoteObject [
	^ nil
]

{ #category : #'*Espell2' }
UndefinedObject >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ anEP2ObjectSpace nilObject
]
