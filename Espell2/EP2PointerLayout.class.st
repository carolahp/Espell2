Class {
	#name : #EP2PointerLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2PointerLayout class >> on: anEP2RemoteObject [
	^ self new 
		remote: anEP2RemoteObject;
		yourself
]

{ #category : #'testing-types' }
EP2PointerLayout >> isPointerLayout [

	^ true
]

{ #category : #accessing }
EP2PointerLayout >> layoutName [

	^ #PointerLayout
]
