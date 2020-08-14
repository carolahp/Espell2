Class {
	#name : #EP2VariableLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'accessing-variables' }
EP2VariableLayout >> allVariables [
	| vars |
	vars := #() asOrderedCollection.
	self remote slotsDo: [ :slot | vars add: (slot read: self remote) ].
	^ vars
]

{ #category : #'gt-extension' }
EP2VariableLayout >> gtInspectorIn: composite [
	^ composite table
		title: self remote asRemoteObjectCasted asString;
		display: [ 
			(remote isRemoteClass and: [ remote isRoleMetaclass ])  
				ifTrue: [ { } ] 
				ifFalse: [ remote asRemoteObjectCasted allVariables collectWithIndex: [ :var :index | index -> var ] ] ];
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
