Class {
	#name : #EP2Layout,
	#superclass : #Object,
	#instVars : [
		'object',
		'slots'
	],
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'instance variables' }
EP2Layout class >> addSlot: aName [
	self error: 'You should call this method from the instance side. Instantiate a layout using the message EP2Layout >> on:'
]

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
	(instSpec between: 10 and: 11) ifTrue: [ ^ EP2WordLayout ].
	(instSpec between: 12 and: 15) ifTrue: [ self halt. ].
	(instSpec between: 16 and: 23) ifTrue: [ ^ EP2ByteLayout ].
	(instSpec = 24) ifTrue: [ ^ EP2CompiledMethodLayout ].
	
	^ EP2Layout
]

{ #category : #'instance creation' }
EP2Layout class >> on: anEP2Remote [
	^ (self layoutClassForClass: anEP2Remote basicClass ) new 
		object: anEP2Remote;
		yourself
]

{ #category : #'accessing - slots' }
EP2Layout >> addSlot: aSlot [ 
	self backend addSlot: aSlot to: self object
]

{ #category : #slots }
EP2Layout >> addSlot: aName index: anInteger [ 
	self backend addSlot: aName index: anInteger to: self object
]

{ #category : #'accessing - slots' }
EP2Layout >> allInstVars [
	^ (self object basicClass allSlots select: #isInstanceVariableSlot)
		collect: [ :slot | slot name -> (slot read: self object) ]
]

{ #category : #'testing-types' }
EP2Layout >> allSlots [
	^ ((self object superclass isNil
		or: [ self object superclass isNilObject ])
		or: [ self object superclass = self object ])
		ifTrue: [ self object slots ]
		ifFalse: [ self object superclass allSlots , self object slots ]
]

{ #category : #'accessing - slots' }
EP2Layout >> allVariables [
	^ self object basicClass allSlots collect: [ :slot | slot read: self object ]
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
	^ self object backend
]

{ #category : #accessing }
EP2Layout >> defaultSlots [
	^ OrderedCollection new
]

{ #category : #'gt-extension' }
EP2Layout >> gtInspectorIn: composite [
	"self object isRoleMetaclass ifTrue: [ self haltOnce. ]."

	^ composite table
		title: object asString;
		display: [ 
			{ 'self' -> object },
			(object basicClass allSlots
				collect:
					[ :slot | slot name -> (object readSlotNamed: slot name) asRemoteObjectCasted ]) ];
		column: 'Variable' evaluated: [ :assoc | assoc key ];
		column: 'Value' evaluated: [ :assoc | assoc value ];
		send: [ :assoc | 
			assoc
				ifNotNil: [ assoc value ] ]
]

{ #category : #accessing }
EP2Layout >> initialize [ 
	super initialize.
	slots := self defaultSlots
]

{ #category : #'accessing header' }
EP2Layout >> instSpec [
	"NEW:
	 0 = 0 sized objects (UndefinedObject True False et al)
	 1 = non-indexable objects with inst vars (Point et al)
	 2 = indexable objects with no inst vars (Array et al)
	 3 = indexable objects with inst vars (MethodContext AdditionalMethodState et al)
	 4 = weak indexable objects with inst vars (WeakArray et al)
	 5 = weak non-indexable objects with inst vars (ephemerons) (Ephemeron)
	 6 = reserved
	 7 = forwarder format (also immediate class format)
	 9          64-bit indexable
	 10 - 11 32-bit indexable
	 12 - 15 16-bit indexable
	 16 - 23 byte indexable
	 24 - 31 compiled method"
	(object isCompiledMethod) ifTrue: [ ^ 24 ].
	(object isBytes) ifTrue: [ ^ 16 ].
	(object isWords) ifTrue: [ ^ 10 ].
	(object isEphemeron) ifTrue: [ ^ 5 ].
	(object instSize = 0 and: [ object isVariable not ]) ifTrue: [ ^ 0 ].
	(object instSize > 0 and: [ object isVariable not ]) ifTrue: [ ^ 1 ].
	(object instSize = 0 and: [ object isVariable     ]) ifTrue: [ ^ 2 ].
	(object instSize > 0 and: [ object isVariable     ]) ifTrue: [ ^ 3 ].
	(object instSize > 0 and: [ object isVariable and: [ object isWeak ] ]) ifTrue: [ ^ 4 ].
	(object instSize > 0 and: [ object isVariable not and: [ object isWeak ] ]) ifTrue: [ ^ 5 ].
	self error: 'illegal old format'
]

{ #category : #'accessing instance variables' }
EP2Layout >> instVarNames [
	^#()
]

{ #category : #accessing }
EP2Layout >> instanceVariableAtIndex: index [
	^ self backend object: self instVarAt: index
]

{ #category : #accessing }
EP2Layout >> instanceVariableAtIndex: index put: anObject [
	self backend object: self instVarAt: index put: anObject
]

{ #category : #'accessing-instVars' }
EP2Layout >> instanceVariableNamed: aString [ 
	^ (self object basicClass slotNamed: aString) read: self 
]

{ #category : #'accessing instance variables' }
EP2Layout >> instanceVariableNamed: aString put: aCollection [ 
	^ (self object basicClass slotNamed: aString) write: aCollection to: object
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
	"we assume backend is Espell backend (to the kernel)" 
	^ self backend localObjectAsRemoteObject: anObject
]

{ #category : #'testing-types' }
EP2Layout >> mcType [

	^ #normal 
]

{ #category : #'accessing-pvt' }
EP2Layout >> object [
	^ object 
]

{ #category : #'accessing-pvt' }
EP2Layout >> object: anEPRemoteObject [
	object := anEPRemoteObject
]

{ #category : #'accessing-pvt' }
EP2Layout >> objectSpace [
	^ self backend objectSpace
]

{ #category : #accessing }
EP2Layout >> parent [
	^ object
]

{ #category : #slots }
EP2Layout >> pvtAddSlot: aSlot [
	(slots includes: aSlot)
		ifFalse: [ slots add: aSlot ]
]

{ #category : #slots }
EP2Layout >> pvtRemoveSlot: aSlot [
	(slots includes: aSlot)
		ifTrue: [ slots remove: aSlot ]
		ifFalse: [ SlotNotFound signal: 'Trying to remove an unexistent slot' ]
]

{ #category : #slots }
EP2Layout >> pvtSlots [
	^ slots
]

{ #category : #accessing }
EP2Layout >> slotNamed: aString [
	^ (self allSlots select: [ :slot | slot name = aString ]) anyOne
]

{ #category : #'accessing - slots' }
EP2Layout >> slots [
	| result |
	result := #() asOrderedCollection.
	self slotsDo: [ :slot |  result add: slot ].
	^ result
]

{ #category : #'accessing - slots' }
EP2Layout >> slotsDo: aBlock [
	self backend slotsFor: self object do: aBlock
]

{ #category : #'accessing-pvt' }
EP2Layout >> target [ 
	^ self object mirror target
]

{ #category : #'vm-tests' }
EP2Layout >> testRemote [
	^ true
]
