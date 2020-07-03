Class {
	#name : #EP2RemoteObject,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteObject class >> unmappedInstVarIndex [
	^ 'unmapped'
	
]

{ #category : #comparing }
EP2RemoteObject >> = anotherRemote [
	([anotherRemote isEP2Remote ] on:Exception do: [ false ]) ifFalse: [ ^ false ].
	^ self pointsToSameObject: anotherRemote
]

{ #category : #'accessing-instVars' }
EP2RemoteObject >> allInstVars [
	^ (self basicClass allSlots select: #isInstanceVariableSlot) collect: [ :slot | slot name -> (slot read: self) ]
]

{ #category : #'accessing-variables' }
EP2RemoteObject >> allVariables [
	^ self basicClass allSlots collect: [ :slot | slot read: self ]
]

{ #category : #converting }
EP2RemoteObject >> asClassDefinition [
	^ nil
]

{ #category : #converting }
EP2RemoteObject >> asRemoteArray [
	^ EP2RemoteArray on: self mirror
]

{ #category : #converting }
EP2RemoteObject >> asRemoteAssociation [
	^ self mirror asRemoteAssociation
]

{ #category : #converting }
EP2RemoteObject >> asRemoteByteString [
	^ EP2RemoteByteString on: self mirror 
]

{ #category : #converting }
EP2RemoteObject >> asRemoteClass [
	^ EP2RemoteClass on: self mirror
]

{ #category : #converting }
EP2RemoteObject >> asRemoteCompiledMethod [
	^ EP2RemoteCompiledMethod on: self mirror
]

{ #category : #converting }
EP2RemoteObject >> asRemoteDictionary [
	^ self mirror asRemoteDictionary
]

{ #category : #converting }
EP2RemoteObject >> asRemoteNil [
	^ EP2RemoteNil on: self mirror
]

{ #category : #accessing }
EP2RemoteObject >> at: index [
	^ (self layout at: index) asRemoteObject
]

{ #category : #accessing }
EP2RemoteObject >> at: index put: aReference [
	self layout at: index put: aReference
]

{ #category : #'high-level-message' }
EP2RemoteObject >> basicClass [ 
	^ self mirror basicClass
]

{ #category : #accessing }
EP2RemoteObject >> basicSize [
	
	^ self backend basicSizeOf: self
]

{ #category : #'accessing-instVars' }
EP2RemoteObject >> instanceVariableAtIndex: index [
	(index == self class unmappedInstVarIndex) ifTrue: [ ^self backend nilObject ].
	^ self layout instanceVariableAtIndex: index
]

{ #category : #'accessing-instVars' }
EP2RemoteObject >> instanceVariableAtIndex: index put: anObject [
	(index == self class unmappedInstVarIndex) ifTrue: [ self error: 'Unmapped Inst Var writting attempt' ].
	self layout instanceVariableAtIndex: index put: anObject
]

{ #category : #'accessing-instVars' }
EP2RemoteObject >> instanceVariableNamed: aString [ 
	^ self layout instanceVariableNamed: aString
]

{ #category : #comparing }
EP2RemoteObject >> pointsToSameObject: aRemoteObjectOrMirror [
	^self target = aRemoteObjectOrMirror target
]

{ #category : #'public-api' }
EP2RemoteObject >> setClass: aRemoteClass [
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
EP2RemoteObject >> setHashBitsTo: anInteger [ 
	self mirror setHashBitsTo: anInteger
]

{ #category : #accessing }
EP2RemoteObject >> size [
	
	^ self basicSize
]

{ #category : #'accessing-pvt' }
EP2RemoteObject >> systemDefinition [
	^ mirror backend systemDefinition
]

{ #category : #'accessing-mirror' }
EP2RemoteObject >> target: anEP2SimulatorClassTableHandle [ 
	self mirror target: anEP2SimulatorClassTableHandle
]
