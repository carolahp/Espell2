Class {
	#name : #EP2RemoteEmpty,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteEmpty class >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #constants }
EP2RemoteEmpty class >> modelInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemoteEmpty class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteEmpty class >> role [ 
	^ 'ProtoObject'
]
