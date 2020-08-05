Class {
	#name : #EP2RemoteBoolean,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteBoolean class >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #constants }
EP2RemoteBoolean class >> modelInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemoteBoolean class >> role [ 
	^ 'Boolean'
]

{ #category : #testing }
EP2RemoteBoolean >> isTrueObject [
	self subclassResponsibility 
]
