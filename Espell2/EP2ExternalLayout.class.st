Class {
	#name : #EP2ExternalLayout,
	#superclass : #EP2VariableWithInstVarsLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #testing }
EP2ExternalLayout class >> isExternal [
	^ true
]

{ #category : #'accessing-instVars' }
EP2ExternalLayout >> instanceVariableAtIndex: index [
	^ (object target object instVarAt: index) asRemoteObjectInObjectSpace: self objectSpace
]

{ #category : #'accessing-instVars' }
EP2ExternalLayout >> instanceVariableAtIndex: index put: anObject [
	object target object instVarAt: index put: (self backend localObjectAsRemoteObject: anObject)
]

{ #category : #'accessing-instVars' }
EP2ExternalLayout >> instanceVariableNamed: aString [ 

	^ (object target object instVarNamed: aString) asRemoteObjectInObjectSpace: self objectSpace
]
