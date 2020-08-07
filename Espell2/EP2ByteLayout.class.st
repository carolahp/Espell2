Class {
	#name : #EP2ByteLayout,
	#superclass : #EP2BitsLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'remote-objects-relationship' }
EP2ByteLayout class >> defaultRemoteObjectClass [
	^ EP2RemoteByteString
]

{ #category : #'accessing - slots' }
EP2ByteLayout >> allVariables [
	| vars |
	vars := #() asOrderedCollection.
	self remote slotsDo: [ :slot | vars add: (slot read: self remote) ].
	^ vars
]

{ #category : #'gt-extension' }
EP2ByteLayout >> gtInspectorRawIn: composite [
	^ composite table
		title: [ '*Raw*' ];
		display: [ self remote slots ];
		column: 'Variable'
			evaluated: [:slot | slot name ];
		column: 'Value'
			evaluated: [:slot | (slot read: self remote) asRemoteObjectCasted];
		send: [:slot | (slot read: self remote) asRemoteObjectCasted].
]

{ #category : #'testing-types' }
EP2ByteLayout >> isByteLayout [

	^ true
]

{ #category : #accessing }
EP2ByteLayout >> layoutName [

	^ #ByteLayout
]
