Extension { #name : #RGSlot }

{ #category : #'*Espell2' }
RGSlot >> asEP2Slot [
	
	^ self class ep2SlotClass new 
		name: self name;
		yourself
]

{ #category : #'*Espell2' }
RGSlot class >> ep2SlotClass [
	self subclassResponsibility 
]

{ #category : #'*Espell2' }
RGSlot >> index [ 
	^ self parent parent allSlots indexOf: self
]
