Class {
	#name : #EP2FixedLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #testing }
EP2FixedLayout >> isFixedLayout [

	^ true
]

{ #category : #testing }
EP2FixedLayout >> layoutName [

	^ #FixedLayout
]
