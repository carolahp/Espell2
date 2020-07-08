Extension { #name : #LargeNegativeInteger }

{ #category : #'*Espell2' }
LargeNegativeInteger >> asRemoteObjectInObjectSpace: anObjectSpace [
	
	^ anObjectSpace fromLocalNegativeInteger: self
]
