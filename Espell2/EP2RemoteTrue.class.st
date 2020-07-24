Class {
	#name : #EP2RemoteTrue,
	#superclass : #EP2RemoteBoolean,
	#category : #'Espell2-Kernel'
}

{ #category : #'high-level-message' }
EP2RemoteTrue >> ifFalse: aBlockClosure [ 
	^nil
]

{ #category : #'high-level-message' }
EP2RemoteTrue >> ifTrue: aBlockClosure [ 
	^aBlockClosure value
]

{ #category : #accessing }
EP2RemoteTrue >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #printing }
EP2RemoteTrue >> printOn: aStream [
	^ aStream nextPutAll: '*true*'
]

{ #category : #tests }
EP2RemoteTrue >> testStub [
	self assert: (mirror backend basicSizeOf: mirror) equals: 0.
	self assert: self basicClass format asLocalSmallInteger equals: 0
]
