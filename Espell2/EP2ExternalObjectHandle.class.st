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
EP2ExternalObjectHandle >> object [
	^ object
]

{ #category : #accessing }
EP2ExternalObjectHandle >> object: anASTBlockClosure [ 
	object := anASTBlockClosure
]

{ #category : #printing }
EP2ExternalObjectHandle >> printOn: aStream [
	aStream nextPutAll: self object asString
]

{ #category : #accessing }
EP2ExternalObjectHandle >> species [
	^ EP2ExternalObjectHandle 
]
