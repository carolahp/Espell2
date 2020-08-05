Class {
	#name : #EP2RemoteLargePositiveInteger,
	#superclass : #EP2RemoteInteger,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteLargePositiveInteger class >> layoutClass [ 
	^ EP2ByteLayout 
]

{ #category : #constants }
EP2RemoteLargePositiveInteger class >> role [ 
	^ 'LargePositiveInteger'
]
