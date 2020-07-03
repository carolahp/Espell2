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

{ #category : #'accessing-instVars' }
EP2Remote >> allInstVars [
	^ #()
]

{ #category : #'accessing-variables' }
EP2Remote >> allVariables [
	^ { }
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
