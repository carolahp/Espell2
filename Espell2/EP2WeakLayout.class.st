Class {
	#name : #EP2WeakLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'testing slots' }
EP2WeakLayout class >> acceptsNewSlots [
	^ false
]

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

{ #category : #exporting }
EP2WeakLayout >> mcType [

	^ #weak 
]
