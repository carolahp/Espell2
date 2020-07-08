Extension { #name : #LargePositiveInteger }

{ #category : #'*Espell2' }
LargePositiveInteger >> asLiteralInObjectSpace: anObjectSpace [
	
	^ anObjectSpace fromLocalPositiveInteger: self
]
