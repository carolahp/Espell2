Class {
	#name : #EP2Layout,
	#superclass : #Object,
	#instVars : [
		'remote'
	],
	#category : #'Espell2-Kernel-Layouts'
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

{ #category : #'mapping-instSpec-class' }
EP2Layout class >> layoutClassForClass: aRemoteClass [
	| instSpec | 
	instSpec := aRemoteClass isNilObject 
		ifTrue: [ 0 ]
		ifFalse: [ aRemoteClass instSpec ].
	^ self layoutClassForInstSpec: instSpec 
]

{ #category : #'instance creation' }
EP2Layout class >> layoutClassForInstSpec: instSpec [
	(instSpec = 1) ifTrue: [ ^ EP2FixedLayout ].
	(instSpec = 7) ifTrue: [ ^ EP2ImmediateLayout ].
	(instSpec = 3) ifTrue: [ ^ self halt."EP2VariableWithInstVarsLayout" ].	
	(instSpec = 2) ifTrue: [ ^ EP2VariableLayout ].
	(instSpec = 16) ifTrue: [ ^ EP2ByteLayout ].
	(instSpec = 24) ifTrue: [ ^ EP2CompiledMethodLayout ].
	
	^ EP2Layout
]

{ #category : #'instance creation' }
EP2Layout class >> on: anEP2Remote [
	^ (self layoutClassForClass: anEP2Remote basicClass ) new 
		remote: anEP2Remote;
		yourself
]

{ #category : #accessing }
EP2Layout >> allSlots [ 
	^ {}
]

{ #category : #accessing }
EP2Layout >> at: index [
	^ self backend object: self at: index
]

{ #category : #accessing }
EP2Layout >> at: index put: anObject [
	self backend object: self at: index put: (self backend localObjectAsRemoteObject: anObject)
]

{ #category : #'accessing-pvt' }
EP2Layout >> backend [ 
	^ self remote mirror backend
]

{ #category : #'gt-extension' }
EP2Layout >> gtInspectorIn: composite [
	"self remote isRoleMetaclass ifTrue: [ self haltOnce. ]."
	^ composite table
		title: self remote asString;
		display: [ "{ 'self' -> self remote asString },  "
			(remote isRemoteClass and: [ remote isRoleMetaclass ])  
				ifTrue: [ { } ] 
				ifFalse: [ remote allSlots ] ];
		column: 'Variable' evaluated: [:slot | slot name ];
		column: 'Value' evaluated: [ :slot | self remote readSlotNamed: slot name  ];
		send: #value
]

{ #category : #accessing }
EP2Layout >> instVarNames [
	^ (self allSlots select: #isInstanceVariableSlot) collect: #name
]

{ #category : #accessing }
EP2Layout >> instanceVariableAtIndex: index [
	^ self backend object: self instVarAt: index
]

{ #category : #accessing }
EP2Layout >> instanceVariableAtIndex: index put: anObject [
	self backend object: self instVarAt: index put: (self backend localObjectAsRemoteObject: anObject)
]

{ #category : #'accessing-instVars' }
EP2Layout >> instanceVariableNamed: aString [ 
	^ (self allSlots collect: [ :slot | slot name = aString. self haltOnce. ]) ifEmpty: [ nil ]
]

{ #category : #testing }
EP2Layout >> isBitsLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isByteLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isCompiledMethodLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isEmptyLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isEphemeronLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isFixedLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isImmediateLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isLayout [

	^true
]

{ #category : #testing }
EP2Layout >> isObjectLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isPointerLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isVariableLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isWeakLayout [

	^ false
]

{ #category : #testing }
EP2Layout >> isWordLayout [

	^ false
]

{ #category : #utils }
EP2Layout >> localObjectAsRemoteObject: anObject [ 
	^ self remote mirror backend localObjectAsRemoteObject: anObject
]

{ #category : #'accessing-pvt' }
EP2Layout >> objectSpace [
	^ self mirror backend objectSpace
]

{ #category : #'accessing-pvt' }
EP2Layout >> remote [
	^ remote 
]

{ #category : #'accessing-pvt' }
EP2Layout >> remote: anEPRemoteObject [
	remote := anEPRemoteObject
]

{ #category : #'accessing-pvt' }
EP2Layout >> target [ 
	^ self remote mirror target
]
