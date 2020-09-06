Class {
	#name : #EP2RemoteSmallInteger,
	#superclass : #EP2RemoteInteger,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteSmallInteger class >> layoutClass [ 
	^ EP2ImmediateLayout 
]

{ #category : #constants }
EP2RemoteSmallInteger class >> modelInstSpec [
	^ 7
]

{ #category : #constants }
EP2RemoteSmallInteger class >> modelInstVarNames [
	^ #()
]

{ #category : #'instance creation' }
EP2RemoteSmallInteger class >> on: anEP2SimulatorAddressHandle from: anEP2Backend [ 
	^ self on: (EP2Mirror on: anEP2SimulatorAddressHandle from: anEP2Backend)
]

{ #category : #'bootstrap roles' }
EP2RemoteSmallInteger class >> role [ 
	^ 'SmallInteger'
]

{ #category : #'high-level-messages' }
EP2RemoteSmallInteger >> + aRemoteInteger [  
	^ (self 
		executePrimitiveNumber: mirror backend primitiveAddSmallIntegerNumber 
		withArguments: { aRemoteInteger }) asRemoteSmallInteger
]

{ #category : #'high-level-messages' }
EP2RemoteSmallInteger >> <= aRemoteInteger [ 
	^ (self 
		executePrimitiveNumber: mirror backend primitiveLessOrEqualsNumber 
		withArguments: { aRemoteInteger }) asRemoteBoolean
]

{ #category : #'high-level-messages' }
EP2RemoteSmallInteger >> >= anRemoteInteger [ 
	^ (self 
		executePrimitiveNumber: mirror backend primitiveGreaterOrEqualsNumber  
		withArguments: { anRemoteInteger }) asRemoteBoolean
]

{ #category : #'high-level-messages' }
EP2RemoteSmallInteger >> \\ aRemoteInteger [ 
	^ (self 
		executePrimitiveNumber: mirror backend primitiveModNumber 
		withArguments: { aRemoteInteger }) asRemoteSmallInteger
]

{ #category : #'converting-to-local' }
EP2RemoteSmallInteger >> asLocalLiteral [
	^ self asLocalSmallInteger
]

{ #category : #converting }
EP2RemoteSmallInteger >> asLocalSmallInteger [
	^ self mirror asLocalSmallInteger
]

{ #category : #converting }
EP2RemoteSmallInteger >> asRemoteSmallInteger [
	^ self 
]

{ #category : #'converting-local' }
EP2RemoteSmallInteger >> asSmallInteger [
	^ self asLocalSmallInteger 
]

{ #category : #accessing }
EP2RemoteSmallInteger >> at: index [
	self shouldNotImplement 
]

{ #category : #accessing }
EP2RemoteSmallInteger >> at: index put: value [
	self shouldNotImplement 
]

{ #category : #'high-level-message' }
EP2RemoteSmallInteger >> basicSize [
	^ 0
]

{ #category : #'high-level-messages' }
EP2RemoteSmallInteger >> executePrimitiveNumber: anInteger withArguments: aCollection [
	| result arguments |
	arguments := aCollection collect: [:each | each asRemoteObjectInObjectSpace: mirror backend objectSpace].
	result := mirror backend executePrimitiveNumber: anInteger on: self withArguments: arguments.
	result hasFailed ifTrue: [ ^ self error: 'Primitive has failed' ].
	^ result value  
]

{ #category : #'accessing-instVars' }
EP2RemoteSmallInteger >> instanceVariableAtIndex: index [
	self shouldNotImplement 
]

{ #category : #'accessing-instVars' }
EP2RemoteSmallInteger >> instanceVariableAtIndex: index put: anObject [
	self shouldNotImplement 
]

{ #category : #'accessing-instVars' }
EP2RemoteSmallInteger >> instanceVariableNamed: aString [ 
	self shouldNotImplement 
]

{ #category : #printing }
EP2RemoteSmallInteger >> printOn: aStream [
	aStream nextPutAll: '*', self asLocalSmallInteger asString, '*'
]

{ #category : #'high-level-messages' }
EP2RemoteSmallInteger >> remoteTo: stop do: aBlock [
	| nextValue block |
	
	
	nextValue := self.
	[nextValue <= stop]
		remoteWhileTrue: 
			[aBlock value: nextValue.
			nextValue := nextValue + 1]
]

{ #category : #'high-level-messages' }
EP2RemoteSmallInteger >> to: stop do: aBlock [
	| nextValue |
	self halt.
	nextValue := self.
	[nextValue <= stop]
		remoteWhileTrue: 
			[aBlock value: nextValue.
			nextValue := nextValue + 1]
]
