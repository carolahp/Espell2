Class {
	#name : #EP2ExternalObjectHandle,
	#superclass : #EP2Handle,
	#instVars : [
		'object'
	],
	#category : #'Espell2-Handles'
}

{ #category : #compatibility }
EP2ExternalObjectHandle >> address [
	^ backend nilObject target address
]

{ #category : #casting }
EP2ExternalObjectHandle >> asCastedRemoteClass [
	^ self object ep2RemoteClass 
]

{ #category : #converting }
EP2ExternalObjectHandle >> asClassIndexHandle [
	^ (backend systemDefinition classWithRole: self object role) remote
		target asClassIndexHandle
]

{ #category : #casting }
EP2ExternalObjectHandle >> asRemoteClass [
	object isClass
		ifFalse: [ self error: 'casting non class object as class' ].
	^ backend remoteClassOn: (backend mirrorOn: self)
]

{ #category : #accessing }
EP2ExternalObjectHandle >> basicClassHandle [
	
	^ backend handleOnExternalObject: object class
]

{ #category : #accessing }
EP2ExternalObjectHandle >> basicRemoteClassHandle [
	
	^ backend handleOnExternalObject: object class
	
]

{ #category : #accessing }
EP2ExternalObjectHandle >> basicSize [ 
	^ object basicSize
]

{ #category : #'high-level-message' }
EP2ExternalObjectHandle >> instSpec [
	"asking inst spec of external object (like DASTBlock?)" 
	 self shouldNotImplement 
]

{ #category : #testing }
EP2ExternalObjectHandle >> isAddressHandle [
	self shouldBeImplemented.
]

{ #category : #testing }
EP2ExternalObjectHandle >> isEPDASTBlockMirror [
	"this should be called only from high level remote objects"
	^ object isKindOf: DASTBlock
]

{ #category : #accessing }
EP2ExternalObjectHandle >> isExternalHandle [
	^ true
]

{ #category : #testing }
EP2ExternalObjectHandle >> isNilObject [
	^ false
]

{ #category : #accessing }
EP2ExternalObjectHandle >> isSmallInteger [
	^ false
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
