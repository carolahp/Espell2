Class {
	#name : #EP2PointerLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2PointerLayout class >> on: anEP2RemoteObject [
	^ self new 
		object: anEP2RemoteObject;
		yourself
]

{ #category : #'accessing instance variables' }
EP2PointerLayout >> instVarNames [
	^ self slots collect: #name
]

{ #category : #'testing-types' }
EP2PointerLayout >> isPointerLayout [

	^ true
]

{ #category : #accessing }
EP2PointerLayout >> layoutName [

	^ #PointerLayout
]

{ #category : #'accessing slots' }
EP2PointerLayout >> removeSlot: aString [ 
	super removeSlot: aString.
	self halt.
	self slots remove: (self slotNamed: aString)
]

{ #category : #slots }
EP2PointerLayout >> slotAt: anInteger [ 
	^ self allSlots at: anInteger
]
