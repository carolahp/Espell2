Class {
	#name : #EP2ExternalContextLayout,
	#superclass : #EP2ExternalLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'accessing - slots' }
EP2ExternalContextLayout >> allInstVars [
	
	^ (self object target object basicClass allSlots)
		collect: [ :slot | self object target object instVarNamed: slot name ]
]

{ #category : #'accessing - slots' }
EP2ExternalContextLayout >> gtInspectorIn: composite [
	^ composite text
		title: self object asExternalContext asString;
		display: [ '*', self object asExternalContext asString , '*' ]
]

{ #category : #'accessing - slots' }
EP2ExternalContextLayout >> instanceVariableNamed: aString [ 

	^ (object target object instVarNamed: aString) asRemoteObjectInObjectSpace: self objectSpace
]
