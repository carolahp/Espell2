Class {
	#name : #EP2RemoteArray,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'instance creation' }
EP2RemoteArray class >> newWithSize: anInteger withBackend: anEP2Backend [ 
	^ anEP2Backend basicNewOn: anEP2Backend arrayClass withSize: anInteger
]

{ #category : #printing }
EP2RemoteArray >> allVariables [
	| vars |
	vars := #() asOrderedCollection.
	1 to: self basicSize do: [ :index |
		vars add: (self at: index) ].
	^ vars asArray
]

{ #category : #'high-level-messages' }
EP2RemoteArray >> asDictionary [
	^ EP2RemoteDictionary newFrom: self
]

{ #category : #'high-level-messages' }
EP2RemoteArray >> associationsDo: aBlockClosure [ 
	self do: aBlockClosure
]

{ #category : #'high-level-messages' }
EP2RemoteArray >> do: aBlock [ 
	"Evaluate a Block on non nil elements of the receiver"
	| dep |
	1 to: self basicSize do:[:i|
		(dep := self at: i) isNilObject ifFalse:[aBlock value: dep]].
]

{ #category : #accessing }
EP2RemoteArray >> layoutClass [
	^ EP2VariableLayout
]

{ #category : #printing }
EP2RemoteArray >> printOn: aStream [
	self isNilObject ifTrue: [ ^ self mirror asRemoteNil printOn: aStream ].
	
	aStream nextPutAll: '*#( '.
	1 to: self basicSize do: [:i | aStream nextPutAll: (self at:i) asString, ' '].
	aStream nextPutAll:')*'
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
