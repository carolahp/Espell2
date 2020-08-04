Class {
	#name : #EP2RemotePointer,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemotePointer class >> modelInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemotePointer class >> role [ 
	self subclassResponsibility
]

{ #category : #constants }
EP2RemotePointer class >> unmappedInstVarIndex [
	^ 'unmapped'
	
]

{ #category : #comparing }
EP2RemotePointer >> = anotherRemote [
	([anotherRemote isEP2Remote ] on:Exception do: [ false ]) ifFalse: [ ^ false ].
	^ self pointsToSameObject: anotherRemote
]

{ #category : #'accessing-instVars' }
EP2RemotePointer >> allInstVars [
	^ (self basicClass allSlots select: #isInstanceVariableSlot) collect: [ :slot | slot name -> (slot read: self) ]
]

{ #category : #'accessing-variables' }
EP2RemotePointer >> allVariables [
	^ self basicClass allSlots collect: [ :slot | slot read: self ]
]

{ #category : #converting }
EP2RemotePointer >> asClassDefinition [
	^ nil
]

{ #category : #converting }
EP2RemotePointer >> asContextMirror [
	^ self asRemoteContext asContextMirror
]

{ #category : #'converting loca' }
EP2RemotePointer >> asLocalSmallInteger [
	^ self mirror asLocalSmallInteger
]

{ #category : #'converting-local' }
EP2RemotePointer >> asLocalString [
	^ self asRemoteByteString asLocalString
]

{ #category : #'converting-local' }
EP2RemotePointer >> asSmallInteger [
	^ self asRemoteSmallInteger asSmallInteger 
]

{ #category : #accessing }
EP2RemotePointer >> at: index [
	^ (self layout at: index) asRemoteObject
]

{ #category : #accessing }
EP2RemotePointer >> at: index put: aReference [
	self layout at: index put: aReference
]

{ #category : #accessing }
EP2RemotePointer >> basicSize [
	
	^ self backend basicSizeOf: self
]

{ #category : #'accessing-instVars' }
EP2RemotePointer >> instanceVariableAtIndex: index [
	(index == self class unmappedInstVarIndex) ifTrue: [ ^self backend nilObject ].
	^ self layout instanceVariableAtIndex: index
]

{ #category : #'accessing-instVars' }
EP2RemotePointer >> instanceVariableAtIndex: index put: anObject [
	(index == self class unmappedInstVarIndex) ifTrue: [ self error: 'Unmapped Inst Var writting attempt' ].
	self layout instanceVariableAtIndex: index put: anObject
]

{ #category : #'accessing-instVars' }
EP2RemotePointer >> instanceVariableNamed: aString [ 
	^ self layout instanceVariableNamed: aString
]

{ #category : #testing }
EP2RemotePointer >> isExternalObject [
	^ self target isExternalHandle
]

{ #category : #comparing }
EP2RemotePointer >> pointsToSameObject: aRemoteObjectOrMirror [
	^self target = aRemoteObjectOrMirror target
]

{ #category : #printing }
EP2RemotePointer >> printOn: aStream [
	|selfcasted|
	selfcasted := self asRemoteObjectCasted.
	(selfcasted class = self class) 
	ifTrue: [ aStream 
		nextPutAll: 'aRemote [ ';
		nextPutAll: self target asString;
		nextPutAll: ' ]' ]
	ifFalse: [ selfcasted printOn: aStream ]
	
]

{ #category : #'public-api' }
EP2RemotePointer >> setClass: aRemoteClass [
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
EP2RemotePointer >> setHashBitsTo: anInteger [ 
	self mirror setHashBitsTo: anInteger
]

{ #category : #accessing }
EP2RemotePointer >> size [
	
	^ self basicSize
]

{ #category : #'accessing-pvt' }
EP2RemotePointer >> systemDefinition [
	^ mirror backend systemDefinition
]

{ #category : #'accessing-mirror' }
EP2RemotePointer >> target: anEP2SimulatorClassTableHandle [ 
	self mirror target: anEP2SimulatorClassTableHandle
]
