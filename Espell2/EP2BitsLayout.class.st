Class {
	#name : #EP2BitsLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #testing }
EP2BitsLayout >> isBitsLayout [

	^ true
]

{ #category : #testing }
EP2BitsLayout >> isVariableLayout [

	^ true
]

{ #category : #testing }
EP2BitsLayout >> layoutName [

	^ #BitsLayout
]
