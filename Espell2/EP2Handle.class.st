"
I am used by EP2Mirrors to hold the reference to the object they point at.
"
Class {
	#name : #EP2Handle,
	#superclass : #Object,
	#instVars : [
		'backend'
	],
	#category : #'Espell2-Handles'
}

{ #category : #casting }
EP2Handle >> asCastedRemoteClass [
	^ self object ep2RemoteClass
]

{ #category : #casting }
EP2Handle >> asRemoteClass [
	self subclassResponsibility 
]

{ #category : #accessing }
EP2Handle >> backend: anEP2SimulatorBackend [ 
	backend := anEP2SimulatorBackend
]

{ #category : #'accessing-header' }
EP2Handle >> basicClassHandle [
	self subclassResponsibility
]

{ #category : #'high-level-message' }
EP2Handle >> instSpec [
	self subclassResponsibility
]

{ #category : #testing }
EP2Handle >> isEPDASTBlockMirror [
	self subclassResponsibility 
]

{ #category : #accessing }
EP2Handle >> isExternalHandle [
	self subclassResponsibility 
]

{ #category : #accessing }
EP2Handle >> isSmallInteger [ 
	self subclassResponsibility 
]

{ #category : #accessing }
EP2Handle >> species [ 
	self subclassResponsibility 
]
