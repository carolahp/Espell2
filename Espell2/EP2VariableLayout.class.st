Class {
	#name : #EP2VariableLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #accessing }
EP2VariableLayout class >> at: anIndex put: anEP2Mirror [ 
	self mirror backend object: self mirror target address at: anIndex put: anEP2Mirror target address
]

{ #category : #'gt-extension' }
EP2VariableLayout >> gtInspectorIn: composite [
	"self remote isRoleMetaclass ifTrue: [ self haltOnce. ]."
	^ composite table
		title: self remote asString;
		display: [ "{ 'self' -> self remote asString },  "
			(remote isRemoteClass and: [ remote isRoleMetaclass ])  
				ifTrue: [ { } ] 
				ifFalse: [ remote allSlots ] ];
		column: 'Variable' evaluated: [:slot | slot name ];
		column: 'Value' evaluated: [ :slot | remote readSlotNamed: slot name  ];
		send: [ :slot | self remote readSlotNamed: slot name ]
]

{ #category : #testing }
EP2VariableLayout >> isVariableLayout [

	^ true
]

{ #category : #testing }
EP2VariableLayout >> layoutName [

	^ #VariableLayout
]

{ #category : #accessing }
EP2VariableLayout >> readSlotNamed: aName [
	^ (remote slotNamed: aName) read: self 
]

{ #category : #'queries-slots' }
EP2VariableLayout >> slotsDo: aBlock [
	| newSlot |
	1 to: remote basicSize do: [ :index | 
		newSlot := EP2IndexedSlot new 
			definingClass: remote basicClass; 
			index: index;
			name: index asString;
			yourself.
		aBlock value: newSlot
		]
	
]
