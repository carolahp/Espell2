Class {
	#name : #EP2ExternalLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'accessing-instVars' }
EP2ExternalLayout >> instanceVariableAtIndex: index [
	^ (remote target object instVarAt: index) asRemoteObjectInObjectSpace: self objectSpace
]

{ #category : #'accessing-instVars' }
EP2ExternalLayout >> instanceVariableAtIndex: index put: anObject [
	remote target object instVarAt: index put: (self backend localObjectAsRemoteObject: anObject)
]

{ #category : #'accessing-instVars' }
EP2ExternalLayout >> instanceVariableNamed: aString [ 

	^ (remote target object instVarNamed: aString) asRemoteObjectInObjectSpace: self objectSpace
]
