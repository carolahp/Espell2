Class {
	#name : #EP2VariableLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'accessing-variables' }
EP2VariableLayout >> allSlots [ 
	^ self object slots
]

{ #category : #'accessing-variables' }
EP2VariableLayout >> allVariables [
	| vars |
	vars := #() asOrderedCollection.
	self object slotsDo: [ :slot | vars add: (slot read: self object) ].
	^ vars
]

{ #category : #'gt-extension' }
EP2VariableLayout >> gtInspectorIn: composite [
	^ composite table
		title: self object asRemoteObjectCasted asString;
		display: [ 
			(object isRemoteClass and: [ object isRoleMetaclass ])  
				ifTrue: [ { } ] 
				ifFalse: [ object asRemoteObjectCasted allVariables collectWithIndex: [ :var :index | index -> var ] ] ];
		column: 'Index' evaluated: [:assoc | assoc key ];
		column: 'Value' evaluated: [ :assoc | assoc value asRemoteObjectCasted ];
		send: [ :assoc | assoc value ifNotNil: [ :val | val asRemoteObjectCasted ] ]
]

{ #category : #'testing-types' }
EP2VariableLayout >> isVariableLayout [

	^ true
]

{ #category : #accessing }
EP2VariableLayout >> layoutName [

	^ #VariableLayout
]

{ #category : #exporting }
EP2VariableLayout >> mcType [

	^ #variable 
]
