Class {
	#name : #EP2WeakLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'testing-types' }
EP2WeakLayout >> isVariableLayout [

	^ true
]

{ #category : #'testing-types' }
EP2WeakLayout >> isWeakLayout [

	^ true
]

{ #category : #accessing }
EP2WeakLayout >> layoutName [

	^ #EphemeronLayout
]
