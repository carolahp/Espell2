Class {
	#name : #EP2FixedLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Layouts'
}

{ #category : #'accessing-instVars' }
EP2FixedLayout >> instanceVariableAtIndex: index [

	^ self target instanceVariableAtIndex: index
]

{ #category : #accessing }
EP2FixedLayout >> instanceVariableAtIndex: index put: aReference [
	self backend 
		object: self target address 
		instVarAt: index 
		put: (aReference asRemoteObjectInObjectSpace: self objectSpace) target address
]
