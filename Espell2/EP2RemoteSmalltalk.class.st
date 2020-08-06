Class {
	#name : #EP2RemoteSmalltalk,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteSmalltalk class >> allInstVarNames [ 
	^  #(#globals)
]

{ #category : #constants }
EP2RemoteSmalltalk class >> layoutClass [ 
	^ EP2FixedLayout 
]

{ #category : #constants }
EP2RemoteSmalltalk class >> role [ 
	^ 'Smalltalk'
]
