Class {
	#name : #EP2RemoteSmalltalkImage,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteSmalltalkImage class >> layoutClass [ 
	^ EP2FixedLayout 
]

{ #category : #constants }
EP2RemoteSmalltalkImage class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteSmalltalkImage class >> modelInstVarNames [ 
	^  #(#globals)
]

{ #category : #constants }
EP2RemoteSmalltalkImage class >> role [ 
	^ 'SmalltalkImage'
]
