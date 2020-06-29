Class {
	#name : #EP2RemoteBlock,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #accessing }
EP2RemoteBlock >> basicSize [
	^ 0
]

{ #category : #accessing }
EP2RemoteBlock >> layoutClass [ 
	^ EP2BlockLayout 
]

{ #category : #accessing }
EP2RemoteBlock >> printOn: aStream [
	aStream 
		nextPutAll: '*';
		nextPutAll: self sourceCode;
		nextPutAll: '*'
]

{ #category : #'high-level-message' }
EP2RemoteBlock >> sourceCode [
	^ self target object sourceCode
]
