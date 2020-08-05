Class {
	#name : #EP2Layout,
	#superclass : #Object,
	#instVars : [
		'remote',
		'slots'
	],
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'remote-objects-relationship' }
EP2Layout class >> defaultRemoteObjectClass [
	^ EP2Remote
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
	"(instSpec = 0) ifTrue: [ ^ EP2EmptyLayout ]."
	(instSpec = 1) ifTrue: [ ^ EP2FixedLayout ].
	(instSpec = 7) ifTrue: [ ^ EP2ImmediateLayout ].
	(instSpec = 3) ifTrue: [ ^ EP2ObjectLayout ].	
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

{ #category : #'accessing - slots' }
EP2Layout >> addSlot: aSlot [ 
	self backend addSlot: aSlot to: self 
]

{ #category : #'accessing - slots' }
EP2Layout >> allInstVars [
	^ (self remote basicClass allSlots select: #isInstanceVariableSlot)
		collect: [ :slot | slot name -> (slot read: self remote) ]
]

{ #category : #'accessing - slots' }
EP2Layout >> allVariables [
	^ self remote basicClass allSlots collect: [ :slot | slot read: self remote ]
]

{ #category : #accessing }
EP2Layout >> at: index [
	^ self backend object: self at: index
]

{ #category : #accessing }
EP2Layout >> at: index put: anObject [

	self backend object: self at: index put: anObject
]

{ #category : #'accessing-pvt' }
EP2Layout >> backend [ 
	^ self remote backend
]

{ #category : #accessing }
EP2Layout >> defaultSlots [
	^ OrderedCollection new
]

{ #category : #'gt-extension' }
EP2Layout >> gtInspectorIn: composite [
	"self remote isRoleMetaclass ifTrue: [ self haltOnce. ]."
	^ composite table
		title: self remote asString;
		display: [ "{ 'self' -> self remote asString },  "
			(remote isRemoteClass and: [ remote isRoleMetaclass ])  
				ifTrue: [ { } ] 
				ifFalse: [ remote basicClass allSlots ] ];
		column: 'Variable' evaluated: [:slot | slot name ];
		column: 'Value' evaluated: [ :slot | (remote readSlotNamed: slot name) asRemoteObjectCasted  ];
		send: [ :slot | slot ifNotNil: [(remote readSlotNamed: slot name) asRemoteObjectCasted ] ]
]

{ #category : #accessing }
EP2Layout >> initialize [ 
	super initialize.
	slots := self defaultSlots
]

{ #category : #accessing }
EP2Layout >> instanceVariableAtIndex: index [
	^ (self backend object: self instVarAt: index) asRemoteObject
]

{ #category : #accessing }
EP2Layout >> instanceVariableAtIndex: index put: anObject [
	self backend object: self instVarAt: index put: anObject
]

{ #category : #'accessing-instVars' }
EP2Layout >> instanceVariableNamed: aString [ 
	^ (self remote basicClass slotNamed: aString) read: self 
]

{ #category : #'testing-types' }
EP2Layout >> isBitsLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isByteLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isCompiledMethodLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isEmptyLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isEphemeronLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isFixedLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isImmediateLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isLayout [

	^true
]

{ #category : #'testing-types' }
EP2Layout >> isObjectLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isPointerLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isVariableLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isWeakLayout [

	^ false
]

{ #category : #'testing-types' }
EP2Layout >> isWordLayout [

	^ false
]

{ #category : #utils }
EP2Layout >> localObjectAsRemoteObject: anObject [ 
	^ self remote mirror backend localObjectAsRemoteObject: anObject
]

{ #category : #'accessing-pvt' }
EP2Layout >> objectSpace [
	^ self remote mirror backend objectSpace
]

{ #category : #'accessing-pvt' }
EP2Layout >> remote [
	^ remote 
]

{ #category : #'accessing-pvt' }
EP2Layout >> remote: anEPRemoteObject [
	remote := anEPRemoteObject
]

{ #category : #accessing }
EP2Layout >> slotNamed: aString [
	^ (self allSlots select: [ :slot | slot name = aString ]) anyOne
]

{ #category : #'accessing - slots' }
EP2Layout >> slotsDo: aBlock [
	self backend slotsFor: self remote do: aBlock
]

{ #category : #'accessing-pvt' }
EP2Layout >> target [ 
	^ self remote mirror target
]

{ #category : #'vm-tests' }
EP2Layout >> testRemote [
	^ true
]
