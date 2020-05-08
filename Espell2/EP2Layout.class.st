Class {
	#name : #EP2Layout,
	#superclass : #Object,
	#instVars : [
		'mirror'
	],
	#category : #'Espell2-Layouts'
}

{ #category : #'remote-objects-relationship' }
EP2Layout class >> defaultRemoteObjectClass [
	^ EP2RemoteObject 
]

{ #category : #'remote-objects-relationship' }
EP2Layout class >> defaultRemoteObjectOn: anEP2Mirror [ 
	self shouldBeImplemented.
]

{ #category : #'gt-inspector' }
EP2Layout class >> gtInspectorLayoutOfMirror: mirror in: composite [
	^ composite table
		title: 'a *', mirror basicClass classNameFromAnyOrigin, '*';
		display: [ { 'self' -> mirror asString } ];
		send: #value
]

{ #category : #'instance creation' }
EP2Layout class >> layoutClassForInstSpec: instSpec [
	(instSpec = 1) ifTrue: [ ^ EP2FixedLayout ].
	(instSpec = 7) ifTrue: [ ^ EP2ImmediateLayout ].
	(instSpec = 3) ifTrue: [ ^ EP2VariableWithInstVarsLayout ].	
	(instSpec = 2) ifTrue: [ ^ EP2VariableLayout ].
	(instSpec = 16) ifTrue: [ ^ EP2ByteLayout ].
	(instSpec = 24) ifTrue: [ ^ EP2CompiledMethodLayout ].
	
	^ EP2Layout
]

{ #category : #'instance creation' }
EP2Layout class >> on: anEP2Mirror [
	^ (self layoutClassForInstSpec: anEP2Mirror instSpec) new 
		mirror: anEP2Mirror;
		yourself
]

{ #category : #accessing }
EP2Layout >> backend [ 
	^ self mirror backend
]

{ #category : #accessing }
EP2Layout >> mirror [
	^ mirror
]

{ #category : #accessing }
EP2Layout >> mirror: anEP2Mirror [ 
	mirror := anEP2Mirror
]

{ #category : #accessing }
EP2Layout >> objectSpace [
	^ self mirror backend objectSpace
]

{ #category : #accessing }
EP2Layout >> target [ 
	^ mirror target
]
