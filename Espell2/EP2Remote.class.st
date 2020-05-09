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

{ #category : #converting }
EP2Remote >> asRemoteObject [
	^ self
]

{ #category : #converting }
EP2Remote >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ self 
]

{ #category : #'accessing-pvt' }
EP2Remote >> backend [
	^ mirror backend
]

{ #category : #'high-level-message' }
EP2Remote >> basicClass [
	self subclassResponsibility 
]

{ #category : #converting }
EP2Remote >> classDefinition [
	^ nil
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
	<gtInspectorPresentationOrder: 2>
	^ self layout gtInspectorIn: composite
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

{ #category : #accessing }
EP2Remote >> target [ 
	^ mirror target
]
