Class {
	#name : #EP2BitsLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'remote-objects-relationship' }
EP2BitsLayout class >> acceptsNewSlots [
	^ false
]

{ #category : #'testing-types' }
EP2BitsLayout >> isBitsLayout [

	^ true
]

{ #category : #'testing-types' }
EP2BitsLayout >> isVariableLayout [

	^ true
]

{ #category : #accessing }
EP2BitsLayout >> layoutName [

	^ #BitsLayout
]
