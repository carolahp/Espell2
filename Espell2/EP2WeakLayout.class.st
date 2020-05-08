Class {
	#name : #EP2WeakLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #testing }
EP2WeakLayout >> isVariableLayout [

	^ true
]

{ #category : #testing }
EP2WeakLayout >> isWeakLayout [

	^ true
]

{ #category : #testing }
EP2WeakLayout >> layoutName [

	^ #EphemeronLayout
]
