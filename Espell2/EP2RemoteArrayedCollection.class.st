Class {
	#name : #EP2RemoteArrayedCollection,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteArrayedCollection class >> layoutClass [
	^ EP2FixedLayout 
]

{ #category : #constants }
EP2RemoteArrayedCollection class >> modelInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemoteArrayedCollection class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteArrayedCollection class >> role [
	^ nil 
	"^ 'ArrayedCollection'"
]
