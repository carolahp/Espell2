Class {
	#name : #EP2ExternalObjectHandle,
	#superclass : #EP2Handle,
	#instVars : [
		'object'
	],
	#category : #'Espell2-LowLevel-mirrors'
}

{ #category : #accessing }
EP2ExternalObjectHandle >> basicClassHandle [
	
	^ backend handleOnExternalObject: object class
]

{ #category : #accessing }
EP2ExternalObjectHandle >> object: anASTBlockClosure [ 
	object := anASTBlockClosure
]

{ #category : #accessing }
EP2ExternalObjectHandle >> species [
	^ EP2ExternalObjectHandle 
]
