Class {
	#name : #EP2RemoteArray,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #printing }
EP2RemoteArray >> allVariables [
	| vars |
	vars := #() asOrderedCollection.
	1 to: self basicSize do: [ :index |
		vars add: (self at: index) ].
	^ vars asArray
]

{ #category : #accessing }
EP2RemoteArray >> layoutClass [
	^ EP2VariableLayout
]

{ #category : #printing }
EP2RemoteArray >> printOn: aStream [
	aStream nextPutAll: '*a ';
		nextPutAll: self basicClass classNameFromAnyOrigin, ' [';
		nextPutAll: self basicSize asString;
		nextPutAll:' items]*'
]

{ #category : #'accessing-slots' }
EP2RemoteArray >> slotNamed: aString [ 
	^ (self allSlots select: [ :slot | slot name = aString ]) anyOne
]

{ #category : #'accessing-slots' }
EP2RemoteArray >> slots [
	| allSlots |
	allSlots := OrderedCollection new.
	self slotsDo: [ :each | allSlots add: each].
	^ allSlots asArray
]

{ #category : #'accessing-slots' }
EP2RemoteArray >> slotsDo: aBlock [
	| newSlot |
	1 to: self basicSize do: [ :index | 
		newSlot := EP2IndexedSlot new 
			definingClass: self basicClass; 
			index: index;
			name: index asString;
			yourself.
		aBlock value: newSlot
		]
	
]
