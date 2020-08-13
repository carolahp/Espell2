Class {
	#name : #EP2RemoteContext,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #instanciation }
EP2RemoteContext class >> createContextForMethod: aRemoteCompiledMethod inObjectSpace: anObjectSpace [ 
	| contextClassMirror newContext |
	contextClassMirror := anObjectSpace backend contextClass asClassMirror.
	newContext := (contextClassMirror basicNew: aRemoteCompiledMethod frameSize) asContextMirror.
	newContext sender: anObjectSpace nilObject.
	newContext receiver: anObjectSpace nilObject.
	newContext method: aRemoteCompiledMethod.
	newContext closure: anObjectSpace nilObject.
	newContext startpc: aRemoteCompiledMethod initialPC.
	newContext stackPointer: 0.
	newContext initializeTemporaryVariables.
	^newContext
]

{ #category : #constants }
EP2RemoteContext class >> modelInstSpec [
	^ 3
]

{ #category : #constants }
EP2RemoteContext class >> modelInstVarNames [ 
	^  #(#sender #pc #stackp #method #closureOrNil #receiver)
]

{ #category : #constants }
EP2RemoteContext class >> role [ 
	^ 'Context'
]

{ #category : #converting }
EP2RemoteContext >> asContextMirror [
	^ self 
]

{ #category : #accessing }
EP2RemoteContext >> closure: aRemoteObject [ 
	self instanceVariableAtIndex: self contextClosureOrNilIndex put: aRemoteObject 
]

{ #category : #'inst-var mapping' }
EP2RemoteContext >> contextClosureOrNilIndex [
	^ (self systemDefinition instanceVariableMapping contextClosureOrNilIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'inst-var mapping' }
EP2RemoteContext >> contextMethodIndex [
	^ (self systemDefinition instanceVariableMapping contextMethodIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'inst-var mapping' }
EP2RemoteContext >> contextPcIndex [
	^ (self systemDefinition instanceVariableMapping contextPcIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'inst-var mapping' }
EP2RemoteContext >> contextReceiverIndex [
	^ (self systemDefinition instanceVariableMapping contextReceiverIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'inst-var mapping' }
EP2RemoteContext >> contextSenderIndex [
	^ (self systemDefinition instanceVariableMapping contextSenderIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'inst-var mapping' }
EP2RemoteContext >> contextStackpIndex [
	^ (self systemDefinition instanceVariableMapping contextStackpIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #initializing }
EP2RemoteContext >> initializeTemporaryVariables [
	"This will push in the context's stack a nil for each of the temporary variables of the method. Both the primitive and the code that follows are in theory doing the same."
	self primitiveInitializeTempsInStack.
	1 to: self method numberOfTemps do: [ :i |
		self tempAt: i put: self backend nilObject.
	].
]

{ #category : #accessing }
EP2RemoteContext >> method [
	^ (self instanceVariableAtIndex: self contextMethodIndex) asRemoteCompiledMethod
]

{ #category : #accessing }
EP2RemoteContext >> method: anEP2RemoteCompiledMethod [ 
	self instanceVariableAtIndex: self contextMethodIndex put: anEP2RemoteCompiledMethod
]

{ #category : #'initializing temps' }
EP2RemoteContext >> primitiveInitializeTempsInStack [
	self backend initializeTempsInStackOfContext: self
]

{ #category : #accessing }
EP2RemoteContext >> receiver: aRemoteObject [
	self instanceVariableAtIndex: self contextReceiverIndex put: aRemoteObject
]

{ #category : #accessing }
EP2RemoteContext >> sender: aRemoteObject [
	self instanceVariableAtIndex: self contextSenderIndex put: aRemoteObject
]

{ #category : #accesssing }
EP2RemoteContext >> stackPointer: anInteger [ 
	self instanceVariableAtIndex: self contextStackpIndex put: anInteger
]

{ #category : #accessing }
EP2RemoteContext >> startpc: anInteger [
	self instanceVariableAtIndex: self contextPcIndex put: anInteger
]
