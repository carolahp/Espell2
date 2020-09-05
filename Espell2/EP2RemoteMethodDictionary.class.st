Class {
	#name : #EP2RemoteMethodDictionary,
	#superclass : #EP2RemoteDictionary,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteMethodDictionary class >> layoutClass [
	^ EP2MethodDictionaryLayout 
]

{ #category : #constants }
EP2RemoteMethodDictionary class >> modelInstSpec [
	^ 3
]

{ #category : #constants }
EP2RemoteMethodDictionary class >> newWithBackend: anEP2Backend size: nElements [
	| dict array tally |
	self assert: nElements isPowerOfTwo.
	
	dict := (anEP2Backend basicNewOn: anEP2Backend methodDictionaryClass withSize: nElements) asRemoteMethodDictionary.
	array := EP2RemoteArray newWithSize: nElements withBackend: anEP2Backend.
	tally := anEP2Backend fromLocalInteger: 0.
	dict array: array.
	dict tally: tally.
	
	^ dict
	
]

{ #category : #constants }
EP2RemoteMethodDictionary class >> role [ 
	^ 'MethodDictionary'
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> arrayWithoutNils [
	^ ( self array allVariables 
			collectWithIndex: [ :var :index | (self basicAt: index) asRemoteObjectCasted -> var ])
			reject: [ :assoc | 
					(assoc key) isNilObject and: [
					(assoc value) isNilObject] ]
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> associations [
	| assocs |
	self tally = 0 ifTrue: [^ self].
	assocs := #() asOrderedCollection .
	1 to: self basicSize do:
		[:i | | key |
		key := (self basicAt: i).
		key isNilObject ifFalse:
			[ assocs add: (EP2RemoteAssociation newWithBackend: self backend key: key value: (self array at: i))]].
	^ assocs
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> associations: aBlock [ 
	self tally = 0 ifTrue: [^ self].
	1 to: self basicSize do:
		[:i | (self basicAt: i) isNilObject ifFalse:
			[ :key | self halt. aBlock value: (EP2RemoteAssociation newWithBackend: self backend key: key value: (self array at: i))]]
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> at: key ifAbsent: aBlock [

	| index |
	index := self findElementOrNil: key.
	(self basicAt: index) isNilObject ifTrue: [ ^ aBlock value ].
	^ self array at: index
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> at: key put: value [
	"Set the value at key to be value."
	| index keySymbol |
	keySymbol := (key asRemoteObjectInObjectSpace: self objectSpace) asRemoteByteSymbol.
	index := self findElementOrNil: keySymbol.
	(self basicAt: index) 
		isNilObject ifTrue: 
			[self tally: self tally + 1.
			self basicAt: index put: keySymbol].
	self array at: index put: value.
	self fullCheck.
	^ value
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> basicAt: index [
	^ self layout basicAt: index
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> basicAt: index put: value [
	^ self layout basicAt: index put: value
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> do: aBlock [ 
	self tally asLocalSmallInteger = 0 ifTrue: [^ self].
	1 to: self basicSize do:
		[:i | (self array at: i) ifNotNil: [ :value | aBlock value: value]]
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> grow [ 
	| newSelf |
	newSelf := self class newWithBackend: self backend size: self basicSize * 2.
	1 to: self basicSize do:
		[:i | | key |
		key := self basicAt: i.
		key isNotNilObject 
			ifTrue: [ newSelf at: key put: (self array at: i)]].
	self becomeInto: newSelf
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> gtInspector2RawIn: composite [
	<gtInspectorPresentationOrder: 2>
	^ composite table
		title: '*Raw*';
		display: [ (self slots collect: [ :slot | slot name -> (slot read: self) ])
				,
					{(#tally -> self tally).
					(#array -> self array)} ];
		column: 'Index' evaluated: [ :assoc | assoc key asString ];
		column: 'Value' evaluated: [ :assoc | assoc value asString ];
		send: [ :assoc | assoc value ]
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> gtInspectorIn: composite [
	^ composite table
		title: '*a Remote Method Dictionary*';
		display: [ self arrayWithoutNils ];
		column: 'Key' evaluated: [ :assoc | assoc key asString ];
		column: 'Value' evaluated: [ :assoc | assoc value asString ];
		send: [ :assoc | assoc value ifNotNil: [ :val | val asRemoteObjectCasted ] ]
]

{ #category : #accessing }
EP2RemoteMethodDictionary >> keys [
	^ self array
]

{ #category : #printing }
EP2RemoteMethodDictionary >> printElementsOn: aStream [ 
	aStream nextPut: $*.
	aStream nextPut: $(.
	self size > 100
		ifTrue: [aStream nextPutAll: 'size '.
			self size printOn: aStream]
		ifFalse: [((self allVariables) reject: [ :each | each isNilObject ])
				do: [:key | aStream print: key;
						 nextPutAll: '->';				
						 print: (self at: key);
						 space]].
	aStream nextPut: $).
	aStream nextPut: $*.
	
]

{ #category : #printing }
EP2RemoteMethodDictionary >> printOn: aStream [ 
	"Append a sequence of characters that identify the receiver to aStream."

	self printElementsOn: aStream
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> scanFor: aRemoteObject [
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| element start finish object |
	object := aRemoteObject asRemoteObjectInObjectSpace: self backend objectSpace.
	finish := self array size.
	start := (object remoteBasicIdentityHash \\ finish) + 1.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element := self basicAt: index) isNilObject or: [element = object])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element := self basicAt: index) isNilObject or: [element = object])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> size [
	"Answer how many elements the receiver contains."

	| tally |
	tally := 0.
	self do: [:each | tally := tally + 1].
	^ tally
]

{ #category : #'vm-tests' }
EP2RemoteMethodDictionary >> test [
	self
		assert:
			self basicClass instSpec
				= EP2RemoteMethodDictionary modelInstSpec
		description: 'Incorrect format of method dictionary: Wrong instSpec of its class'.
	self
		assert: self tally asLocalSmallInteger
		equals: self arrayWithoutNils size
]
