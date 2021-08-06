Class {
	#name : #EP2RemoteArray,
	#superclass : #EP2RemoteArrayedCollection,
	#category : #'Espell2-Kernel'
}

{ #category : #'instance creation' }
EP2RemoteArray class >> index2InClassTable [
	^ 16
]

{ #category : #'instance creation' }
EP2RemoteArray class >> indexInClassTable [
	^ 51
]

{ #category : #'instance creation' }
EP2RemoteArray class >> indexInSpecialObjectsArray [ 
	^ 8
]

{ #category : #constants }
EP2RemoteArray class >> layoutClass [
	^ EP2VariableLayout
]

{ #category : #constants }
EP2RemoteArray class >> modelInstSpec [
	^ 2
]

{ #category : #'instance creation' }
EP2RemoteArray class >> modelInstVarNames [
	^ #()
]

{ #category : #'instance creation' }
EP2RemoteArray class >> newWithSize: anInteger withBackend: anEP2Backend [ 
	^ anEP2Backend basicNewOn: anEP2Backend arrayClass withSize: anInteger
]

{ #category : #'instance creation' }
EP2RemoteArray class >> role [ 
	^ #Array
]

{ #category : #'high-level-messages' }
EP2RemoteArray >> asDictionary [
	^ EP2RemoteDictionary newFrom: self
]

{ #category : #converting }
EP2RemoteArray >> asRemoteArray [
	^ self
]

{ #category : #converting }
EP2RemoteArray >> asRemoteObjectCasted [
	^ self
]

{ #category : #'high-level-messages' }
EP2RemoteArray >> associationsDo: aBlockClosure [ 
	self do: aBlockClosure
]

{ #category : #'high-level-messages' }
EP2RemoteArray >> collect: aBlock [
	"Evaluate aBlock with each of the remote receiver's elements as the argument.
	Collect the resulting values into a local collection"

	| newCollection |
	newCollection := self class
		newWithSize: self basicSize
		withBackend: self backend.
	self
		doWithIndex: [ :each :index | newCollection at: index put: (aBlock value: each) ].
	^ newCollection asRemoteArray
]

{ #category : #'high-level-messages' }
EP2RemoteArray >> do: aBlock [ 
	"Evaluate a Block on non nil elements of the receiver"
	| dep |
	1 to: self basicSize do:[:i|
		(dep := self at: i) isNilObject ifFalse:[aBlock value: dep]].
]

{ #category : #'high-level-messages' }
EP2RemoteArray >> doWithIndex: aBlock [ 
	"Evaluate a Block on non nil elements of the receiver"
	| each |
	1 to: self basicSize do: [:i|
		each := self at: i.
		aBlock value: each value: i]
]

{ #category : #'high-level-messages' }
EP2RemoteArray >> localCollect: aBlock [ 
	"Evaluate aBlock with each of the remote receiver's elements as the argument.
	Collect the resulting values into a local collection"
	| newCollection |
	newCollection := #() asOrderedCollection.
	self do: [ :each | newCollection add: (aBlock value: each) ].
	^ newCollection 
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
