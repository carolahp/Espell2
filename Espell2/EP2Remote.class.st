Class {
	#name : #EP2Remote,
	#superclass : #Object,
	#instVars : [
		'mirror',
		'layout'
	],
	#category : #'Espell2-Kernel'
}

{ #category : #'instance creation' }
EP2Remote class >> on: anEPMirror [ 
	
	^ self new
		mirror: anEPMirror;
		yourself
]

{ #category : #constants }
EP2Remote class >> remoteInstSpec [
	"Answer the instance specification part of the format that defines what kind of object
	 an instance of the receiver is.  The formats are
			0	= 0 sized objects (UndefinedObject True False et al)
			1	= non-indexable objects with inst vars (Point et al)
			2	= indexable objects with no inst vars (Array et al)
			3	= indexable objects with inst vars (MethodContext AdditionalMethodState et al)
			4	= weak indexable objects with inst vars (WeakArray et al)
			5	= weak non-indexable objects with inst vars (ephemerons) (Ephemeron)
			6	= unused
			7	= immediates (SmallInteger, Character)
			8	= unused
			9	= 64-bit indexable
		10-11	= 32-bit indexable (Bitmap)
		12-15	= 16-bit indexable
		16-23	= 8-bit indexable
		24-31	= compiled methods (CompiledMethod)"
	self subclassResponsibility
]

{ #category : #constants }
EP2Remote class >> role [ 
	self subclassResponsibility 
]

{ #category : #'accessing-instVars' }
EP2Remote >> allInstVars [
	^ #()
]

{ #category : #'accessing-variables' }
EP2Remote >> allVariables [
	^ { }
]

{ #category : #converting }
EP2Remote >> asRemoteBlock [
	^ self mirror asRemoteBlock
]

{ #category : #converting }
EP2Remote >> asRemoteFalse [
	^ self mirror asRemoteFalse
]

{ #category : #converting }
EP2Remote >> asRemoteObject [
	^ self 
]

{ #category : #converting }
EP2Remote >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ self 
]

{ #category : #convertion }
EP2Remote >> asRemoteProcess [
	^ EP2RemoteProcess on: self mirror
]

{ #category : #converting }
EP2Remote >> asRemoteSmallInteger [
	^ EP2RemoteSmallInteger on: self mirror
]

{ #category : #converting }
EP2Remote >> asRemoteTrue [
	^ self mirror asRemoteTrue
]

{ #category : #'accessing-pvt' }
EP2Remote >> backend [
	^ mirror backend
]

{ #category : #'high-level-message' }
EP2Remote >> basicClass [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
EP2Remote >> becomeInto: anEP2Remote [ 
	^ self backend become: self into: anEP2Remote 
]

{ #category : #converting }
EP2Remote >> classDefinition [
	^ nil
]

{ #category : #evaluating }
EP2Remote >> evaluateCode: aString withTemps: aCollection [ 
	^ self backend builder bootstrapInterpreter 
		evaluateCode: aString withTemps: aCollection 

]

{ #category : #'executing primitives' }
EP2Remote >> executePrimitiveMethod: aCompiledMethod withArguments: arguments [
	| result |
	result := self mirror executePrimitiveMethod: aCompiledMethod withArguments: arguments.
	result hasFailed ifFalse: [ result value: result value asRemoteObject ].
	^ result
]

{ #category : #'gt-inspector' }
EP2Remote >> gtInspectorIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ self layout gtInspectorIn: composite
]

{ #category : #'as yet unclassified' }
EP2Remote >> instanceVariableNamed: aString [ 
	^ nil
]

{ #category : #testing }
EP2Remote >> isClassMirror [
	^ false
]

{ #category : #testing }
EP2Remote >> isEP2Mirror [
	^ false
]

{ #category : #testing }
EP2Remote >> isEP2Remote [
	^ true
]

{ #category : #testing }
EP2Remote >> isNilObject [
	^ self backend nilObject = self 
]

{ #category : #testing }
EP2Remote >> isRemoteClass [
	^ false
]

{ #category : #testing }
EP2Remote >> isSmallInteger [
	^ self mirror isSmallInteger
]

{ #category : #accessing }
EP2Remote >> layout [ 
	^ layout ifNil: [ layout := self layoutClass on: self ]
]

{ #category : #accessing }
EP2Remote >> layoutClass [
	" generic layout "
	^ EP2Layout
]

{ #category : #accessing }
EP2Remote >> mirror [
	^ mirror
]

{ #category : #accessing }
EP2Remote >> mirror: anEP2Mirror [
	mirror := anEP2Mirror
]

{ #category : #'executing primitives' }
EP2Remote >> nextObject [
	^ self mirror nextObject asRemoteObject
]

{ #category : #printing }
EP2Remote >> printOn: aStream [
	aStream 
		nextPutAll: 'aRemote [ ';
		nextPutAll: self target asString;
		nextPutAll: ' ]'
]

{ #category : #'accessing-slots' }
EP2Remote >> readSlotNamed: aName [
	^ (self basicClass slotNamed: aName) read: self 
]

{ #category : #'high-level-messages' }
EP2Remote >> remoteBasicIdentityHash [
	| result |
	
	result := self backend executePrimitiveNumber: self backend primitiveBasicIdentityHashNumber on: self withArguments: #().
	result hasFailed 
		ifTrue: [ ^ self error: 'Impossible to apply primitive basicIdentityHash' ].
	^ result value asLocalSmallInteger
]

{ #category : #'high-level-message' }
EP2Remote >> remoteIdentityHash [
	"identityHash of the remote object in the remote kernel"
	^ (self remoteBasicIdentityHash bitShift: 18)
]

{ #category : #accessing }
EP2Remote >> target [ 
	^ mirror target
]

{ #category : #'accessing-slots' }
EP2Remote >> writeSlotNamed: aName value: anObject [
	^ (self basicClass slotNamed: aName) 
		write: (self layout localObjectAsRemoteObject: anObject) 
		to: self
]
