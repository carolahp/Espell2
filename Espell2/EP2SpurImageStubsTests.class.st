Class {
	#name : #EP2SpurImageStubsTests,
	#superclass : #EP2SpurImageTests,
	#category : #'Espell2-Image'
}

{ #category : #tests }
EP2SpurImageStubsTests >> testTrue [ 
	self assert: image trueObject testStub
]
