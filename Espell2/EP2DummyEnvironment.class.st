Class {
	#name : #EP2DummyEnvironment,
	#superclass : #Object,
	#instVars : [
		'objectSpace'
	],
	#category : #'Espell2-Compiler-Bindings'
}

{ #category : #'instance creation' }
EP2DummyEnvironment class >> on: anEPObjectSpace [ 
	
	^ self new
		objectSpace: anEPObjectSpace;
		yourself
]

{ #category : #accessing }
EP2DummyEnvironment >> at: aString ifAbsent: aBlockClosure [
	"always evaluate the block because the dummy environment is always empty" 
	^ aBlockClosure value
]

{ #category : #binding }
EP2DummyEnvironment >> bindingOf: aName [

	^ EP2GlobalBinding new
		name: aName;
		objectSpace: objectSpace;
		yourself
]

{ #category : #accessing }
EP2DummyEnvironment >> objectSpace: anEPObjectSpace [ 

	objectSpace := anEPObjectSpace
]
