Class {
	#name : #EP2RemoteMessage,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteMessage class >> layoutClass [ 
	^ EP2FixedLayout 
]

{ #category : #constants }
EP2RemoteMessage class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteMessage class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteMessage class >> role [ 
	^ 'Message'
]
