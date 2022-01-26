"
I hold references to objects installed in the bootstrapped Object Memory, and which can be accessed only by their address in memory
"
Class {
	#name : #EP2AddressHandle,
	#superclass : #EP2InternalObjectHandle,
	#instVars : [
		'address'
	],
	#category : #'Espell2-Handles'
}

{ #category : #comparing }
EP2AddressHandle >> = aHandle [

	^ self species = aHandle species
		and: [ self address == aHandle address ]
]

{ #category : #accessing }
EP2AddressHandle >> address [
	^ address
]

{ #category : #accessing }
EP2AddressHandle >> address: anInteger [ 
	address := anInteger
]

{ #category : #casting }
EP2AddressHandle >> asCastedRemoteClass [
	| basicClass layoutClass |
	basicClass := (backend mirrorOn: self) asRemoteClass.
	"(basicClass
		inheritsFrom: (backend systemDefinition classWithRole: #Metaclass) remote)
		ifTrue: [ ^ EP2RemoteMetaclass ]."
	basicClass isNilObject
		ifFalse: [ 
			basicClass asClassDefinition isMeta
				ifTrue: [^ EP2RemoteMetaclass ].
	
			basicClass asLocalClass
				ifNotNil: [ :localClass | 
					basicClass
						= (backend systemDefinition classClass) remote
						ifTrue: [ ^ EP2RemoteMetaclass ].
					localClass = EP2RemoteMetaclass
						ifTrue: [ ^ EP2RemoteClass ].
					^ localClass ] ].
	
	layoutClass := self isSmallInteger
		ifTrue: [ EP2ImmediateLayout ]
		ifFalse: [ EP2Layout layoutClassForInstSpec: basicClass instSpec ].
	^ layoutClass defaultRemoteObjectClass
]

{ #category : #converting }
EP2AddressHandle >> asClassIndexHandle [

	| hash |
	hash := (backend rawHashOf: address).
	hash > 0 ifFalse: [ ^ self ].
	^ backend handleOnClassIndex: hash.
]

{ #category : #casting }
EP2AddressHandle >> asRemoteClass [
	self isNilObject
		ifTrue: [ ^ backend nilObject ].
	^ backend remoteClassOn: (backend mirrorOn: self)
]

{ #category : #'accessing-header' }
EP2AddressHandle >> basicClassHandle [
	^ backend handleOnAddress: (backend classOf: self)
]

{ #category : #'accessing-header' }
EP2AddressHandle >> classIndex [ 
	^ backend objectMemory classIndexOf: self address  
]

{ #category : #testing }
EP2AddressHandle >> isEPDASTBlockMirror [
	^ false
]

{ #category : #printing }
EP2AddressHandle >> printOn: aStream [
	aStream 
		nextPutAll: 'handle[';
		nextPutAll: self address asString;
		nextPutAll: ']'
]
