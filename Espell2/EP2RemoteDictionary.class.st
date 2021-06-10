Class {
	#name : #EP2RemoteDictionary,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteDictionary class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteDictionary class >> modelInstVarNames [ 
	^ #(#tally #array)
]

{ #category : #'instance creation' }
EP2RemoteDictionary class >> newFrom: aDict [ 
	"Answer an instance of me containing the same associations as aDict.
	 Error if any key appears twice."
	| newDictionary |
	newDictionary := self newWithBackend: aDict backend size: aDict size.
	aDict associationsDo:
		[:x |
		(newDictionary includesKey: x asRemoteAssociation key)
			ifTrue: [self error: 'Duplicate key: ', x key printString]
			ifFalse: [newDictionary add: x]].
	^ newDictionary

"	NewDictionary newFrom: {1->#a. 2->#b. 3->#c}
	{1->#a. 2->#b. 3->#c} as: NewDictionary
	NewDictionary newFrom: {1->#a. 2->#b. 1->#c}
	{1->#a. 2->#b. 1->#c} as: NewDictionary
"
]

{ #category : #'instance creation' }
EP2RemoteDictionary class >> newWithBackend: anEP2Backend [
	^ self newWithBackend: anEP2Backend size: 4
]

{ #category : #'instance creation' }
EP2RemoteDictionary class >> newWithBackend: anEP2Backend size: nElements [
	| dict array tally initialSize |
	initialSize :=  (nElements + 1) * 4 // 3.
	
	dict := (anEP2Backend basicNewOn: anEP2Backend dictionaryClass) asRemoteDictionary.
	array := EP2RemoteArray newWithSize: initialSize withBackend: anEP2Backend.
	tally := anEP2Backend fromLocalInteger: 0.
	dict array: array.
	dict tally: tally.
	
	^ dict
	
]

{ #category : #constants }
EP2RemoteDictionary class >> role [
	^ 'Dictionary'
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> add: anEP2RemoteObject [
	| index element assoc |
	assoc := anEP2RemoteObject asRemoteAssociation.
	index := self findElementOrNil: assoc key.
	element := (self array at: index) asRemoteAssociation.
	element isNilObject
		ifTrue: [ self atNewIndex: index put: assoc ]
		ifFalse: [ element value: assoc value ].
	^ assoc
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> array [
	^ (self instanceVariableAtIndex: self dictionaryArrayIndex) asRemoteArray
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> array: anEP2RemoteObject [ 
	(self instanceVariableAtIndex: self dictionaryArrayIndex put: anEP2RemoteObject asRemoteArray) 
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> asRemoteDictionary [
	^ self
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> asRemoteObjectCasted [
	^ self
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> associationAt: key [ 
	^ self associationAt: key ifAbsent: [ self error: 'key not found in dictionary' ]
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> associationAt: key ifAbsent: aBlock [ 
	
	^ (self array at: (self findElementOrNil: key))
		ifNil: [ aBlock value ]
		ifNotNil: [ :assoc | assoc ]
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> associations [ 
	^ (self array allVariables 
				reject: [ :item | item isNilObject ])
				collect: [ :item | item asRemoteAssociation ] 
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> associationsDo: aBlockClosure [ 
	self associations do: [:assoc | aBlockClosure value: assoc].
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> at: key [
	"Answer the value associated with the key."

	^ self at: key 
		ifAbsent: [ EP2RemoteKeyNotFound new key: key; signal ]
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> at: key ifAbsent: aBlock [
	| index assoc |
	index := self findElementOrNil: key.
	assoc := self array at: index.
	assoc isNilObject
		ifTrue: [ ^ aBlock value ].
	^ assoc asRemoteAssociation value
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> at: key put: anObject [
	"Set the value at key to be anObject.  If key is not found, create a new
	entry for key and set is value to anObject. Answer anObject."

	| index element |
	index := self findElementOrNil: key.
	element := (self array at: index) asRemoteAssociation.
	element isNilObject
		ifTrue:
			[ self atNewIndex: index put: (EP2RemoteAssociation newWithBackend: mirror backend key: key value: anObject) ]
		ifFalse: [ element value: anObject ].
	^ anObject
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> atNewIndex: index put: anEP2RemoteAssociation [ 
	self array at: index put: anEP2RemoteAssociation.
	self tally: self tally + 1.
	self fullCheck
]

{ #category : #binding }
EP2RemoteDictionary >> bindingOf: aSymbol [
	^self associationAt: aSymbol ifAbsent:[nil]
]

{ #category : #'instVars-mapping' }
EP2RemoteDictionary >> dictionaryArrayIndex [ 
	^ (self systemDefinition instanceVariableMapping dictionaryArrayIndex) ifNil: [ self error: 'undefined index for array inst var in Dictionary' ]
]

{ #category : #'instVars-mapping' }
EP2RemoteDictionary >> dictionaryTallyIndex [ 
	^ (self systemDefinition instanceVariableMapping dictionaryTallyIndex) ifNil: [ self error: 'undefined index for tally inst var in Dictionary' ]
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> findElementOrNil: anObject [
	"Answer the index of a first slot containing either a nil (indicating an empty slot) or an element that matches the given object. Answer the index of that slot or zero. Fail if neither a match nor an empty slot is found."

	| index |
	index := self scanFor: anObject.
	index > 0
		ifTrue: [ ^ index ].	"Bad scene.  Neither have we found a matching element
	nor even an empty slot.  No hashed set is ever supposed to get
	completely full."
	self error: 'There is no free space in this set!'
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> fullCheck [
	"Keep array at least 1/4 free for decent hash behavior"

	self array size - self tally asLocalSmallInteger < (self array size // 4 max: 1)
		ifTrue: [ self grow ]
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> grow [
	"Grow the elements array and reinsert the old elements."

	| oldElements newSize |
	oldElements := self array.
	newSize := self array size + (self array size max: 2).
	self array: (EP2RemoteArray newWithSize: newSize withBackend: mirror backend).
	self tally: 0.
	oldElements
		do: [ :each | 
			each isNilObject
				ifFalse: [ self noCheckAdd: each ] ]
]

{ #category : #'gt-inspector' }
EP2RemoteDictionary >> gtInspectorIn: composite [
	^ composite table
		title: self asString;
		display: [ self associations ];
		column: 'Key' evaluated: [:assoc | assoc key asRemoteObjectCasted ];
		column: 'Value' evaluated: [ :assoc | assoc value asRemoteObjectCasted ];
		send: [ :assoc | assoc value ]
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> includesKey: anEP2RemoteObject [ 

	^ (self array at: (self scanFor: anEP2RemoteObject)) isNilObject not
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> initialize [ 
	super initialize.
	
]

{ #category : #'high-level-messages' }
EP2RemoteDictionary >> noCheckAdd: anEP2RemoteObject [
	"Must be defined separately for Dictionary because (self findElementOrNil:) expects a key, not an association.  9/7/96 tk"

	self array at: (self findElementOrNil: anEP2RemoteObject asRemoteAssociation key) put: anEP2RemoteObject.
	self tally: self tally + 1
]

{ #category : #printing }
EP2RemoteDictionary >> printOn: aStream [
	aStream nextPutAll: '*a ';
		nextPutAll: self basicClass classNameFromAnyOrigin.
	
	"if array is nil, the dictionary is not initialized yet"
	(self array isNilObject or: self tally isNilObject)
		ifFalse: [
			aStream 
				nextPutAll: '[', self tally asString;
				nextPutAll: 'items]('.
			1 to: self tally asLocalSmallInteger 
			  do: [:i | aStream nextPutAll: (self associations at:i) asString, ' '].
			aStream nextPutAll:')*']
		ifTrue: [ 
				aStream nextPutAll: '[uninitialized]' ]
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> scanFor: aRemoteObject [
	| element start finish object |
	object := aRemoteObject asRemoteObjectInObjectSpace: self backend objectSpace.
	start := object remoteIdentityHash \\ self array size + 1.
	finish := self array size.	"Search from (hash mod size) to the end."
	start to: finish do: [ :index | 
		element := (self array at: index) asRemoteAssociation.
		(element isNilObject or: [ element key = object ])
			ifTrue: [ ^ index ] ].	"Search from 1 to where we started."
	1 to: start - 1 do: [ :index | 
		((element := (self array at: index) asRemoteAssociation) isNilObject or: [ element key = object ])
			ifTrue: [ ^ index ] ].
	^ 0	"No match AND no empty slot"
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> tally [
	^ (self instanceVariableAtIndex: self dictionaryTallyIndex) asRemoteSmallInteger
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> tally: anEP2RemoteSmallInteger [ 
	(self 
		instanceVariableAtIndex: self dictionaryTallyIndex 
		put: (anEP2RemoteSmallInteger asRemoteObjectInObjectSpace: self backend objectSpace) asRemoteSmallInteger) 
]
