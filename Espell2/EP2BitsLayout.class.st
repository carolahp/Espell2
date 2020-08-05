Class {
	#name : #EP2BitsLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

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
