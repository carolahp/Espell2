Class {
	#name : #EP2FixedLayout,
	#superclass : #EP2PointerLayout,
	#instVars : [
		'grades'
	],
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'testing-types' }
EP2FixedLayout >> allSlots [
	^ (self object superclass isNil
		or: [ self object superclass isNilObject ])
		ifTrue: [ self object slots ]
		ifFalse: [ self object superclass allSlots , self object slots ]
]

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
