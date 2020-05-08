Class {
	#name : #EP2PointerLayout,
	#superclass : #EP2Layout,
	#instVars : [
		'slots'
	],
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2PointerLayout class >> on: anEP2RemoteObject [
	^ self new 
		remote: anEP2RemoteObject;
		yourself
]

{ #category : #'queries-slots' }
EP2PointerLayout >> allSlots [ 

	^ self slots
]

{ #category : #'queries-slots' }
EP2PointerLayout >> defaultSlots [

	^ OrderedCollection new
]

{ #category : #initializing }
EP2PointerLayout >> initialize [

	super initialize.
	slots := self defaultSlots.


]

{ #category : #testing }
EP2PointerLayout >> isPointerLayout [

	^ true
]

{ #category : #accessing }
EP2PointerLayout >> layoutName [

	^ #PointerLayout
]

{ #category : #'queries-slots' }
EP2PointerLayout >> slots [

	| allSlots |
	allSlots := OrderedCollection new.
	self slotsDo: [ :each | allSlots add: each].
	^ allSlots asArray
]

{ #category : #'queries-slots' }
EP2PointerLayout >> slotsDo: aBlock [
	self backend slotsFor: self remote do: aBlock
]
