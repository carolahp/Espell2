Class {
	#name : #EP2VariableLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #accessing }
EP2VariableLayout class >> at: anIndex put: anEP2Mirror [ 
	self mirror backend object: self mirror target address at: anIndex put: anEP2Mirror target address
]

{ #category : #testing }
EP2VariableLayout >> isVariableLayout [

	^ true
]

{ #category : #testing }
EP2VariableLayout >> layoutName [

	^ #VariableLayout
]
