Class {
	#name : #EP2Remote,
	#superclass : #Object,
	#instVars : [
		'mirror',
		'layout'
	],
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2Remote class >> index2InClassTable [
	^ nil
]

{ #category : #constants }
EP2Remote class >> indexInClassTable [
	^ nil
]

{ #category : #constants }
EP2Remote class >> indexInSpecialObjectsArray [
	^ nil
]

{ #category : #constants }
EP2Remote class >> layoutClass [
	" generic layout "
	^ EP2ObjectLayout
]

{ #category : #constants }
EP2Remote class >> modelAcceptsExtraInstVars [
	"the user can add instance variables beside after those specified in EP2Remote >> modelInstVarNames"
	^true
]

{ #category : #constants }
EP2Remote class >> modelAllInstVarNames [
	" I am the root of the remote objects hierarchy "
	^ (self = EP2Remote)
		ifTrue: [ self modelInstVarNames ] 
		ifFalse: [ self superclass modelAllInstVarNames, self modelInstVarNames ]
]

{ #category : #constants }
EP2Remote class >> modelInstSpec [
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
	^ 0
]

{ #category : #constants }
EP2Remote class >> modelInstVarNames [
	^ #()
]

{ #category : #'instance creation' }
EP2Remote class >> on: anEPMirror [ 
	| class |
	class := anEPMirror isNilObject 
		ifTrue: [ EP2RemoteUndefinedObject ]
		ifFalse: [ self ].
	^ class new
		mirror: anEPMirror;
		yourself
]

{ #category : #constants }
EP2Remote class >> role [ 
	^ nil
]

{ #category : #constants }
EP2Remote class >> unmappedInstVarIndex [
	^ 'unmapped'
	
]

{ #category : #comparing }
EP2Remote >> = anotherRemote [
	([anotherRemote isEP2Remote ] on:Exception do: [ false ]) ifFalse: [ ^ false ].
	^ self pointsToSameObject: anotherRemote
]

{ #category : #'accessing-instVars' }
EP2Remote >> allInstVars [
	^ self layout allInstVars
]

{ #category : #'accessing-variables' }
EP2Remote >> allVariables [
	^ self layout allVariables
]

{ #category : #converting }
EP2Remote >> asClassDefinition [
	^ nil
]

{ #category : #converting }
EP2Remote >> asContextMirror [
	^ self asRemoteContext asContextMirror
]

{ #category : #converting }
EP2Remote >> asExternalContext [
	^ self mirror asExternalContext
]

{ #category : #converting }
EP2Remote >> asLocalByteSymbol [
	^self backend fromRemoteByteSymbol: self mirror 
]

{ #category : #'converting loca' }
EP2Remote >> asLocalSmallInteger [
	^ self mirror asLocalSmallInteger
]

{ #category : #'converting-local' }
EP2Remote >> asLocalString [
	^ self asRemoteByteString asLocalString
]

{ #category : #converting }
EP2Remote >> asRemoteArray [
	^ EP2RemoteArray on: self mirror
]

{ #category : #converting }
EP2Remote >> asRemoteAssociation [
	^ self mirror asRemoteAssociation
]

{ #category : #converting }
EP2Remote >> asRemoteBlock [
	^ self mirror asRemoteBlock
]

{ #category : #converting }
EP2Remote >> asRemoteByteArray [
	^ self mirror asRemoteByteArray
]

{ #category : #converting }
EP2Remote >> asRemoteByteString [
	^ self mirror asRemoteByteString
]

{ #category : #converting }
EP2Remote >> asRemoteByteSymbol [
	^ self mirror asRemoteByteSymbol
]

{ #category : #converting }
EP2Remote >> asRemoteCharacter [
	^ self mirror asRemoteCharacter
]

{ #category : #converting }
EP2Remote >> asRemoteClass [
	^ self mirror asRemoteClass
]

{ #category : #converting }
EP2Remote >> asRemoteCompiledMethod [
	^ self mirror asRemoteCompiledMethod
]

{ #category : #converting }
EP2Remote >> asRemoteContext [
	^ self mirror asRemoteContext
]

{ #category : #converting }
EP2Remote >> asRemoteDictionary [
	^ self mirror asRemoteDictionary
]

{ #category : #converting }
EP2Remote >> asRemoteFalse [
	^ self mirror asRemoteFalse
]

{ #category : #converting }
EP2Remote >> asRemoteMetaclass [
	^self mirror asRemoteMetaclass 
]

{ #category : #'convert remote' }
EP2Remote >> asRemoteMethodDictionary [
	^ self mirror asRemoteMethodDictionary 
]

{ #category : #converting }
EP2Remote >> asRemoteNil [
	^ self mirror asRemoteNil
]

{ #category : #converting }
EP2Remote >> asRemoteObject [
	^ self 
]

{ #category : #converting }
EP2Remote >> asRemoteObjectCasted [
	^ self mirror asRemoteObjectCasted
]

{ #category : #converting }
EP2Remote >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ self 
]

{ #category : #converting }
EP2Remote >> asRemoteProcess [
	^ self mirror asRemoteProcess
]

{ #category : #converting }
EP2Remote >> asRemoteScheduler [
	^ self mirror asRemoteScheduler 
]

{ #category : #converting }
EP2Remote >> asRemoteSmallInteger [
	^ self mirror asRemoteSmallInteger
]

{ #category : #converting }
EP2Remote >> asRemoteSystemDictionary [
	^ self mirror asRemoteSystemDictionary 
]

{ #category : #converting }
EP2Remote >> asRemoteTrue [
	^ self mirror asRemoteTrue
]

{ #category : #'converting-local' }
EP2Remote >> asSmallInteger [
	^ self asRemoteSmallInteger asSmallInteger
]

{ #category : #testing }
EP2Remote >> assert: actual equals: expected [
	self
		assert: actual = expected
		description: [ String streamContents: [:stream |
			stream
				nextPutAll: 'Assertion failed. Got ';
				nextPutAll: actual fullPrintString;
				nextPutAll: ' instead of ';
				nextPutAll: expected fullPrintString;
				nextPutAll: '.'] ]
]

{ #category : #accessing }
EP2Remote >> at: index [
	^ (self layout at: index) asRemoteObject
]

{ #category : #accessing }
EP2Remote >> at: index put: aReference [
	self layout at: index put: aReference
]

{ #category : #'accessing-pvt' }
EP2Remote >> backend [
	^ mirror backend
]

{ #category : #'accessing-variables' }
EP2Remote >> basicAt: index [
	^ self layout basicAt: index
]

{ #category : #'high-level-message' }
EP2Remote >> basicClass [
	"^ self backend builder classNamed: self class role"
	^ self mirror basicClass
]

{ #category : #accessing }
EP2Remote >> basicSize [
	
	^ self backend basicSizeOf: self
]

{ #category : #'become api' }
EP2Remote >> becomeInto: anEP2Remote [ 
	^ self backend become: self into: anEP2Remote 
]

{ #category : #converting }
EP2Remote >> classDefinition [
	self halt.
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

{ #category : #testing }
EP2Remote >> ifNilObject: ifNilBlock [
	^ self isNilObject
		ifTrue: [ ifNilBlock cull: self ]
		ifFalse: [ self ]
]

{ #category : #testing }
EP2Remote >> ifNotNilObject: ifNotNilBlock [
	^ self isNilObject
		ifTrue: [ self ]
		ifFalse: [ ifNotNilBlock cull: self ]
]

{ #category : #'accessing-instVars' }
EP2Remote >> instanceVariableAtIndex: index [
	(index == self class unmappedInstVarIndex) ifTrue: [ ^self backend nilObject ].
	^ self layout instanceVariableAtIndex: index
]

{ #category : #'accessing-instVars' }
EP2Remote >> instanceVariableAtIndex: index put: anObject [
	(index == self class unmappedInstVarIndex) ifTrue: [ self error: 'Unmapped Inst Var writting attempt' ].
	self layout instanceVariableAtIndex: index put: anObject
]

{ #category : #'accessing-instVars' }
EP2Remote >> instanceVariableNamed: aString [ 
	^ self layout instanceVariableNamed: aString
]

{ #category : #'accessing-instVars' }
EP2Remote >> instanceVariableNamed: aString put: anObject [
	^ self layout instanceVariableNamed: aString put: anObject
]

{ #category : #testing }
EP2Remote >> isClassMirror [
	^ false
]

{ #category : #testing }
EP2Remote >> isEP2Mirror [
	^ true
]

{ #category : #testing }
EP2Remote >> isEP2Remote [
	^ true
]

{ #category : #testing }
EP2Remote >> isExternalObject [
	^ self target isExternalHandle
]

{ #category : #testing }
EP2Remote >> isNilObject [
	^ self mirror isNilObject
]

{ #category : #testing }
EP2Remote >> isNotNilObject [
	^ self isNilObject not 
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
	^ self class layoutClass
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

{ #category : #'accessing backend' }
EP2Remote >> objectSpace [
	^ mirror backend objectSpace
]

{ #category : #comparing }
EP2Remote >> pointsToSameObject: aRemoteObjectOrMirror [
	^self target = aRemoteObjectOrMirror target
]

{ #category : #printing }
EP2Remote >> printOn: aStream [
	|selfcasted|
	selfcasted := self asRemoteObjectCasted.
	(selfcasted class = self class) 
	ifTrue: [ 
		aStream 
			nextPutAll: 'aRemote [ ';
			nextPutAll: self target asString;
			nextPutAll: ' ]' ]
	ifFalse: [ selfcasted printOn: aStream ]
	
]

{ #category : #'accessing-slots' }
EP2Remote >> readSlotNamed: aName [
	
	self deprecated: 'use Slot>>read: instead'.
	^ (self basicClass slotNamed: aName) read: self 
]

{ #category : #'high-level-messages' }
EP2Remote >> remoteBasicIdentityHash [
	^ self mirror basicIdentityHash.
	
]

{ #category : #'high-level-message' }
EP2Remote >> remoteIdentityHash [
	"identityHash of the remote object in the remote kernel"
	^ (self remoteBasicIdentityHash bitShift: 8)
]

{ #category : #hash }
EP2Remote >> remoteRawHashBits [
	^ self mirror remoteRawHashBits
]

{ #category : #'public-api' }
EP2Remote >> setClass: aRemoteClass [
	[
		self backend classHandle: self target setTo: aRemoteClass target
	] on: PrimitiveFailed do: [ 
		(aRemoteClass format ~= self basicClass format) ifTrue: [ 
			self error: ('format of instance {1} of format {2} should match class format: {3} ' 
				format: { self printString . self basicClass format . aRemoteClass format asString })
		].
	]
]

{ #category : #'accessing-header' }
EP2Remote >> setHashBitsTo: anInteger [ 
	
	self mirror setHashBitsTo: anInteger
]

{ #category : #accessing }
EP2Remote >> size [
	
	^ self basicSize
]

{ #category : #'accessing-slots' }
EP2Remote >> slots [
	^ self layout slots
]

{ #category : #'accessing-slots' }
EP2Remote >> slotsDo: aBlock [ 
	self layout slotsDo: aBlock
]

{ #category : #'accessing-pvt' }
EP2Remote >> systemDefinition [
	^ mirror backend systemDefinition
]

{ #category : #accessing }
EP2Remote >> target [ 
	^ mirror target
]

{ #category : #'accessing-mirror' }
EP2Remote >> target: anEP2SimulatorClassTableHandle [ 
	self mirror target: anEP2SimulatorClassTableHandle
]

{ #category : #'vm-tests' }
EP2Remote >> test [
	^ self layout testRemote
]

{ #category : #'accessing-slots' }
EP2Remote >> writeSlotNamed: aName value: anObject [
	^ (self basicClass slotNamed: aName) 
		write: (self layout localObjectAsRemoteObject: anObject) 
		to: self
]
