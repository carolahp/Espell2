Class {
	#name : #EP2FixedLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'testing-types' }
EP2FixedLayout >> isFixedLayout [

	^ true
]

{ #category : #accessing }
EP2FixedLayout >> layoutName [

	^ #FixedLayout
]

{ #category : #exporting }
EP2FixedLayout >> mcType [

	^ #normal 
]
