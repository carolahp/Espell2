Class {
	#name : #EP2RemoteFalse,
	#superclass : #EP2RemoteBoolean,
	#category : #'Espell2-Kernel'
}

{ #category : #controlling }
EP2RemoteFalse >> ifFalse: aBlockClosure [ 
	^aBlockClosure value
]

{ #category : #controlling }
EP2RemoteFalse >> ifTrue: aBlockClosure [ 
	^nil
]

{ #category : #accessing }
EP2RemoteFalse >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #printing }
EP2RemoteFalse >> printOn: aStream [
	^ aStream nextPutAll: '*false*'
]
