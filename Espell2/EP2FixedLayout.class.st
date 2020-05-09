Class {
	#name : #EP2FixedLayout,
	#superclass : #EP2PointerLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'gt-extension' }
EP2FixedLayout >> gtClassInspectorIn: composite [
	self flag: 'ToDo'
]

{ #category : #testing }
EP2FixedLayout >> isFixedLayout [

	^ true
]

{ #category : #testing }
EP2FixedLayout >> layoutName [

	^ #FixedLayout
]
