Class {
	#name : #EP2RemoteObject,
	#superclass : #Object,
	#instVars : [
		'mirror',
		'layout'
	],
	#category : #'Espell2-HighLevel-remoteObjects'
}

{ #category : #'instance creation' }
EP2RemoteObject class >> on: anEPMirror [ 
	
	^ self new
		mirror: anEPMirror;
		yourself
]

{ #category : #comparing }
EP2RemoteObject >> = anotherObject [
	^ self mirror = anotherObject
]

{ #category : #converting }
EP2RemoteObject >> asRemoteArray [
	^ EP2RemoteArray on: self mirror
]

{ #category : #converting }
EP2RemoteObject >> asRemoteClass [
	^ EP2RemoteClass on: self mirror
]

{ #category : #converting }
EP2RemoteObject >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ self 
]

{ #category : #accessing }
EP2RemoteObject >> at: index [
	^ self layout at: index
]

{ #category : #accessing }
EP2RemoteObject >> at: index put: aReference [
	self layout at: index put: aReference
]

{ #category : #'accessing-pvt' }
EP2RemoteObject >> backend [
	^ mirror backend
]

{ #category : #'high-level-message' }
EP2RemoteObject >> basicClass [
	^ self mirror basicClass
]

{ #category : #accessing }
EP2RemoteObject >> basicSize [
	
	^ self backend basicSizeOf: self
]

{ #category : #accessing }
EP2RemoteObject >> instanceVariableAtIndex: index [
	^ self layout instanceVariableAtIndex: index
]

{ #category : #accessing }
EP2RemoteObject >> instanceVariableAtIndex: index put: aReference [
	self layout instanceVariableAtIndex: index put: aReference
]

{ #category : #testing }
EP2RemoteObject >> isSmallInteger [
	^ self mirror isSmallInteger
]

{ #category : #accessing }
EP2RemoteObject >> layout [ 
	^ layout ifNil: [ layout := self layoutClass on: self mirror ]
]

{ #category : #accessing }
EP2RemoteObject >> layoutClass [
	" generic layout "
	^ EP2Layout
]

{ #category : #accessing }
EP2RemoteObject >> mirror [
	^ mirror
]

{ #category : #accessing }
EP2RemoteObject >> mirror: anEP2Mirror [
	mirror := anEP2Mirror
]

{ #category : #printing }
EP2RemoteObject >> printOn: aStream [
	aStream 
		nextPutAll: 'aRemote [ ';
		nextPutAll: self target address asString;
		nextPutAll: ' ]'
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

{ #category : #accessing }
EP2RemoteObject >> target [ 
	^ mirror target
]

{ #category : #'accessing-mirror' }
EP2RemoteObject >> target: anEP2SimulatorClassTableHandle [ 
	self mirror target: anEP2SimulatorClassTableHandle
]
