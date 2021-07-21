"
I am a proxy for handling objects during the bootstrap process. 
InstVars:
- Backend: an instance of EP2Backend, who works as a high level interface to use the VMMaker to handle memory
- Handler: an instance of EP2SimulatorHandle. Notice that there exist internal and external handles. Internal handlers deal with objects installed in the generated Object Memory, while external handles deal with local Pharo objects used by during the AST interpretation of instructions. 
"
Class {
	#name : #EP2Mirror,
	#superclass : #Object,
	#instVars : [
		'target',
		'backend'
	],
	#category : #'Espell2-LowLevel-mirrors'
}

{ #category : #'intance creation' }
EP2Mirror class >> on: anEP2SimulatorHandle from: anEP2Backend [ 
	^ self new
		target: anEP2SimulatorHandle;
		backend: anEP2Backend;
		yourself
]

{ #category : #comparing }
EP2Mirror >> = anotherMirror [
	([anotherMirror isEP2Mirror ] on:Exception do: [ false ]) ifFalse: [ ^ false ].
	
	^ self pointsToSameObject: anotherMirror
]

{ #category : #convert }
EP2Mirror >> asCastedRemoteClass [
	^ self target asCastedRemoteClass 
]

{ #category : #'converting-external-mirror' }
EP2Mirror >> asDASTBlockMirror [

	^ backend mirrorOn: self target
]

{ #category : #'remote conversion' }
EP2Mirror >> asExternalContext [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2ExternalContext on: self
]

{ #category : #'converting-local' }
EP2Mirror >> asLocalSmallInteger [

	^ backend integerValueOf: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteArray [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteArray on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteAssociation [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteAssociation on: self 
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteBlock [ 
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteBlockClosure on: self
]

{ #category : #'transforming-remote' }
EP2Mirror >> asRemoteBoolean [
	self isTrueObject ifTrue: [ ^ self asRemoteTrue ].
	self isFalseObject ifTrue: [ ^ self asRemoteFalse ].
	self error: 'not a boolean'
	
]

{ #category : #converting }
EP2Mirror >> asRemoteByteArray [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteByteArray on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteByteString [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteByteString on: self
]

{ #category : #converting }
EP2Mirror >> asRemoteByteSymbol [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteByteSymbol on: self
]

{ #category : #converting }
EP2Mirror >> asRemoteCharacter [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteCharacter on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteClass [ 
	^ self target asRemoteClass
]

{ #category : #'converting -high level' }
EP2Mirror >> asRemoteCompiledMethod [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteCompiledMethod on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteContext [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteContext on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteDictionary [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteDictionary on: self
]

{ #category : #converting }
EP2Mirror >> asRemoteFalse [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteFalse on: self
]

{ #category : #transforming }
EP2Mirror >> asRemoteMetaclass [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteMetaclass on: self
]

{ #category : #'converting remote' }
EP2Mirror >> asRemoteMethodDictionary [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteMethodDictionary on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteNil [
	^ EP2RemoteUndefinedObject on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteObject [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2Remote on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteObjectCasted [
	"gets the corresponding layout according to my instSpec and then uses it to create a remoteObject with the correct type"
	| basicClass templateClass |
	self isNilObject
		ifTrue: [ ^ self asRemoteNil ].
	self isTrueObject
		ifTrue: [ ^ self asRemoteTrue ].
	self isFalseObject
		ifTrue: [ ^ self asRemoteFalse ].
		
	basicClass := self basicRemoteClass.
	templateClass := basicClass asCastedRemoteClass.
	^ templateClass on: self
]

{ #category : #'as yet unclassified' }
EP2Mirror >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ self asRemoteObject
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteProcess [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteProcess on: self
]

{ #category : #'converting-local' }
EP2Mirror >> asRemoteScheduler [ 
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteProcessorScheduler on: self 
]

{ #category : #converting }
EP2Mirror >> asRemoteSmallInteger [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteSmallInteger on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteStub [
	| remoteObjectClass |
	remoteObjectClass := EP2Layout defaultRemoteObjectClass.
	^ remoteObjectClass on: self
	
]

{ #category : #converting }
EP2Mirror >> asRemoteSystemDictionary [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteSystemDictionary on: self
]

{ #category : #converting }
EP2Mirror >> asRemoteTrue [
	self isNilObject ifTrue: [^ backend nilObject ].
	^ EP2RemoteTrue on: self
]

{ #category : #'from remote to local' }
EP2Mirror >> asSmallInteger [
	^ self asLocalSmallInteger
]

{ #category : #accessing }
EP2Mirror >> backend [
	^ backend
]

{ #category : #accessing }
EP2Mirror >> backend: anEP2Backend [ 
	backend := anEP2Backend
]

{ #category : #'accessing-header' }
EP2Mirror >> basicClass [
	| classOrNil |
	"it can return a class installed in the kernel or an external class"
	classOrNil := backend mirrorOn: self target basicClassHandle.
	^ classOrNil isNilObject 
		ifTrue:  [ classOrNil asRemoteNil ] 
		ifFalse: [ classOrNil asRemoteClass ] 
]

{ #category : #comparing }
EP2Mirror >> basicIdentityHash [
	^ backend basicIdentityHashOf: self
"
	| result |
	result := self backend
		executePrimitiveNumber: self backend primitiveBasicIdentityHashNumber
		on: self
		withArguments: #().
	result hasFailed
		ifTrue: [ ^ self error: 'Impossible to apply primitive basicIdentityHash' ].
	^ result value asLocalSmallInteger"
]

{ #category : #'accessing-header' }
EP2Mirror >> basicRemoteClass [
	| classOrNil |
	"always returns a class that is installed in the kernel"
	classOrNil := backend mirrorOn: self target basicRemoteClassHandle.
	^ classOrNil isNilObject 
		ifTrue:  [ classOrNil asRemoteNil ] 
		ifFalse: [ classOrNil asRemoteClass ] 
]

{ #category : #'accessing-header' }
EP2Mirror >> basicSize [ 
	
	^ [self target basicSize] 
		on: Error 
		do: [ (self backend isImmediate: self) 
					ifTrue: [ ^ 0 ] 
					ifFalse: [self error: 'Impossible to get object''s size']]
]

{ #category : #'accessing-header' }
EP2Mirror >> classIndex [
	^ self target classIndex
]

{ #category : #'accessing - compiler' }
EP2Mirror >> compiler [
	^ self backend objectSpace crossCompiler
]

{ #category : #'executing primitives' }
EP2Mirror >> executePrimitiveMethod: aCompiledMethod withArguments: arguments [

	| result |
	result := self backend
			executePrimitiveMethod: aCompiledMethod
			on: self
			withArguments: (arguments collect: #mirror).
	
	self assert: self backend stackIsEmpty. 
	^ result
]

{ #category : #comparing }
EP2Mirror >> hash [

	^ self identityHash
]

{ #category : #comparing }
EP2Mirror >> identityHash [
	
	^ self isSmallInteger
		ifTrue: [ self target asSmallInteger hashMultiply ]
		ifFalse: [ self basicIdentityHash bitShift: 8 ]
]

{ #category : #'accessing-header' }
EP2Mirror >> instSpec [
	^ self target instSpec
]

{ #category : #'accessing-high-level' }
EP2Mirror >> instanceVariableAtIndex: anInteger [ 
	^ self asRemoteObject instanceVariableAtIndex: anInteger
]

{ #category : #testing }
EP2Mirror >> isEP2Mirror [
	^ true
]

{ #category : #testing }
EP2Mirror >> isEP2Remote [
	^ false
]

{ #category : #testing }
EP2Mirror >> isEPDASTBlockMirror [
	^ self target isEPDASTBlockMirror 
]

{ #category : #testing }
EP2Mirror >> isFalseObject [
	^ self backend falseObject mirror = self
]

{ #category : #testing }
EP2Mirror >> isNilObject [
	^ self target isNilObject
]

{ #category : #testing }
EP2Mirror >> isNotNilObject [
	^ self isNilObject not
]

{ #category : #testing }
EP2Mirror >> isSmallInteger [
	^ target isSmallInteger
]

{ #category : #testing }
EP2Mirror >> isTrueObject [
	^ self backend trueObject mirror = self
]

{ #category : #converting }
EP2Mirror >> mirror [
	^ self 
]

{ #category : #'executing primitives' }
EP2Mirror >> nextObject [
	| nextAddress addressHandle |
	nextAddress := self backend objectMemory objectAfter: self target address.
	addressHandle := EP2AddressHandle new 
		address: nextAddress; 
		backend: self backend; 
		yourself.
 
	^ self class 
		on: addressHandle
		from: self backend
]

{ #category : #comparing }
EP2Mirror >> pointsToSameObject: aRemoteObjectOrMirror [
	^self target = aRemoteObjectOrMirror target
]

{ #category : #printing }
EP2Mirror >> printOn: aStream [
	aStream 
		nextPutAll: 'aMirror [ ';
		nextPutAll: self target asString;
		nextPutAll: ' ]'
]

{ #category : #hash }
EP2Mirror >> remoteRawHashBits [
	^ self backend simulator objectMemory rawHashBitsOf: self target address
]

{ #category : #'accessing-header' }
EP2Mirror >> setHashBitsTo: anInteger [ 
	self backend simulator objectMemory setHashBitsOf: self target address to: anInteger
]

{ #category : #accessing }
EP2Mirror >> target [
	^ target
]

{ #category : #accessing }
EP2Mirror >> target: anEP2SimulatorHandle [ 
	target := anEP2SimulatorHandle
]
