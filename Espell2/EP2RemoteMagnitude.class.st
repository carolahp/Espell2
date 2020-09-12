Class {
	#name : #EP2RemoteMagnitude,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteMagnitude class >> layoutClass [ 
	^ EP2FixedLayout 
]

{ #category : #constants }
EP2RemoteMagnitude class >> modelInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemoteMagnitude class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteMagnitude class >> role [ 
	^ 'Magnitude'
]

{ #category : #converting }
EP2RemoteMagnitude >> asRemoteObjectCasted [
	^ self
]
