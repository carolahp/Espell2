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
	^ composite table
		title: self remote asRemoteObjectCasted asString;
		display: [ 
			(remote isRemoteClass and: [ remote isRoleMetaclass ])  
				ifTrue: [ { } ] 
				ifFalse: [ remote allVariables collectWithIndex: [ :var :index | index -> var ] ] ];
		column: 'Index' evaluated: [:assoc | assoc key ];
		column: 'Value' evaluated: [ :assoc | assoc value asRemoteObjectCasted ];
		send: [ :assoc | assoc value asRemoteObjectCasted]
]

{ #category : #testing }
EP2VariableLayout >> isVariableLayout [

	^ true
]

{ #category : #testing }
EP2VariableLayout >> layoutName [

	^ #VariableLayout
]
