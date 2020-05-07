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
	([anotherMirror isEP2Mirror] on:Exception do: [ false ]) ifFalse: [ ^ false ].
	
	^ self pointsToSameObject: anotherMirror
]

{ #category : #'converting-local' }
EP2Mirror >> asLocalSmallInteger [

	^ backend integerValueOf: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteArray [
	^ EP2RemoteArray on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteAssociation [
	^ EP2RemoteAssociation on: self 
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteClass [ 
	^ EP2RemoteClass on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteEmptyObject [
	^ EP2RemoteEmptyObject on: self
]

{ #category : #'converting-high-level' }
EP2Mirror >> asRemoteObject [
	"gets the corresponding layout according to my instSpec and then uses it to create a remoteObject with the correct type"
	| layoutClass remoteObjectClass |
	layoutClass := EP2Layout layoutClassForInstSpec: self instSpec.
	remoteObjectClass := layoutClass defaultRemoteObjectClass.
	^ remoteObjectClass on: self
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
	^ (backend mirrorOn: self target basicClassHandle) asRemoteClass
]

{ #category : #'accessing-header' }
EP2Mirror >> classIndex [
	^ self target classIndex
]

{ #category : #'accessing-header' }
EP2Mirror >> instSpec [
	^ [self basicClass instSpec] on: Error do: [ 0 ]
]

{ #category : #testing }
EP2Mirror >> isEP2Mirror [
	^ true
]

{ #category : #testing }
EP2Mirror >> isSmallInteger [
	^ target isSmallInteger
]

{ #category : #comparing }
EP2Mirror >> pointsToSameObject: aRemoteObjectOrMirror [
	^self target = aRemoteObjectOrMirror target
]

{ #category : #printing }
EP2Mirror >> printOn: aStream [
	aStream 
		nextPutAll: 'aMirror [ ';
		nextPutAll: self target address asString;
		nextPutAll: ' ]'
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
