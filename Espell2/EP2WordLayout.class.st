Class {
	#name : #EP2WordLayout,
	#superclass : #EP2BitsLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #testing }
EP2WordLayout >> isWordLayout [

	^ true
]

{ #category : #accessing }
EP2WordLayout >> layoutName [

	^ #WordLayout
]

{ #category : #exporting }
EP2WordLayout >> mcType [

	^ #words 
]
