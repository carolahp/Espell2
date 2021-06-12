Class {
	#name : #EP2RemoteSemaphore,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteSemaphore class >> layoutClass [
	^ EP2FixedLayout
]

{ #category : #constants }
EP2RemoteSemaphore class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteSemaphore class >> modelInstVarNames [
	^ #(firstLink lastLink excessSignals)
]

{ #category : #constants }
EP2RemoteSemaphore class >> role [
	^ 'Semaphore'
]
