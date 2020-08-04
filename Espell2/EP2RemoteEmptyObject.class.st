Class {
	#name : #EP2RemoteEmptyObject,
	#superclass : #EP2RemotePointer,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteEmptyObject class >> modelInstSpec [
	^ 0
]

{ #category : #'instance creation' }
EP2RemoteEmptyObject class >> on: anEPMirror [
	
	^ self new
		mirror: anEPMirror;
		yourself
]

{ #category : #constants }
EP2RemoteEmptyObject class >> role [ 
	^ ''
]

{ #category : #test }
EP2RemoteEmptyObject >> test [
	self assert: (mirror backend basicSizeOf: mirror) equals: 0.
	self assert: self basicClass format asLocalSmallInteger equals: 0
]

{ #category : #tests }
EP2RemoteEmptyObject >> testStub [
	self test
]
