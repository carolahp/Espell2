Class {
	#name : #EP2VariableLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Layouts'
}

{ #category : #accessing }
EP2VariableLayout class >> at: anIndex put: anEP2Mirror [ 
	self mirror backend object: self mirror target address at: anIndex put: anEP2Mirror target address
]

{ #category : #accessing }
EP2VariableLayout >> at: anIndex [

	^ self backend object: self mirror target at: anIndex
]

{ #category : #accessing }
EP2VariableLayout >> at: anIndex put: anEP2Mirror [
	^ self backend 
		object: mirror target address 
		at: anIndex 
		put: anEP2Mirror target address
]
