Class {
	#name : #EP2RemoteClass,
	#superclass : #EP2RemoteObject,
	#instVars : [
		'slots'
	],
	#category : #'Espell2-Kernel'
}

{ #category : #accessing }
EP2RemoteClass >> addressDefinitionMap [
	^ self backend objectSpace interpreter codeProvider classLoader addressDefinitionMap
]

{ #category : #'accessing-instVars' }
EP2RemoteClass >> allInstVars [
	^ (self allSlots select: #isInstanceVariableSlot) collect: [ :slot | slot name -> (slot read: self) ]
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> allSlots [ 
	^ self slots
]

{ #category : #converting }
EP2RemoteClass >> asClassDefinition [
	^ [self addressDefinitionMap at: self target address ] on: KeyNotFound do: [ nil ]
]

{ #category : #accessing }
EP2RemoteClass >> asLocalClass [
	"it returns the EP2Remote class that corresponds with this class.
	For example: Association asLocalClass will return EP2RemoteAssociation.
	We use this to instantiate the correct class for each remote object we fetch from the remote object memory"
	"^ self addressLocalClassMap 
		at: self mirror target address 
		ifAbsentPut: [" | definition role localClassOrNil |
			definition := self addressDefinitionMap at: self mirror target address.
			"if I am a metaclass, my instances can be represented as instances of EP2RemoteMetaclass"
			definition isMetaclass ifTrue: [^ EP2RemoteMetaclass].
			role := self backend systemDefinition roleOfClass: definition.
			localClassOrNil := Smalltalk classNamed: 'EP2Remote', role asString.
		^	localClassOrNil
		"]"
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> basicNew [
	
	^ self backend basicNewOn: self 
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> basicNew: aSize [ 

	^ self backend basicNewOn: self withSize: aSize
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classFormatIndex [
	^ (self systemDefinition instanceVariableMapping classFormatIndex) ifNil: [ self error: 'undefined index for format inst var in Class' ]
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> className [
	| remoteName |
	remoteName := [self instanceVariableAtIndex: self classNameIndex] on: SubscriptOutOfBounds do: [ ^ nil ].
	remoteName isNilObject ifTrue: [^nil].
	^ self backend fromRemoteByteSymbol: remoteName
]

{ #category : #accessing }
EP2RemoteClass >> classNameFromAnyOrigin [
	^ self className 
		ifNil: [ self asClassDefinition 
					ifNil: [ 'error (', self mirror asString,')' ] 
					ifNotNil: [:classDef | classDef name] ]
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classNameIndex [
	^ (self systemDefinition instanceVariableMapping classNameIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> classPool [
	^ self instanceVariableAtIndex: self classPoolIndex
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> classPool: anObject [ 
	
	^ self instanceVariableAtIndex: self classPoolIndex put: anObject
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classPoolIndex [
	^ (self backend systemDefinition instanceVariableMapping classPoolIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classSharedPoolsIndex [
	^ (self systemDefinition instanceVariableMapping classSharedPoolsIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> classSide [
	^ self basicClass
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classSuperclassIndex [
	^ (self systemDefinition instanceVariableMapping classSuperclassIndex) ifNil: [ self error: 'undefined index for superclass inst var in Class' ]
]

{ #category : #'accessing-header' }
EP2RemoteClass >> compactClassIndex [
	^ self backend compactClassIndexOf: self
	
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> defaultSlots [

	^ OrderedCollection new
]

{ #category : #'accessing-header' }
EP2RemoteClass >> format [
	^self layout instanceVariableAtIndex: self classFormatIndex 
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> format: anInteger [
	^self layout instanceVariableAtIndex: self classFormatIndex put: anInteger
]

{ #category : #initialize }
EP2RemoteClass >> initialize [ 
	super initialize.
	slots := self defaultSlots.
]

{ #category : #binding }
EP2RemoteClass >> innerBindingOf: aSymbol [ 
	(self classPool isNilObject) ifFalse: [ self halt ].
	(self sharedPool isNilObject) ifFalse: [ self halt ].
	self flag: 'superclass is nil for all stubs, check this later'.
	(self superclass isNilObject) ifFalse:  [^ self superclass innerBindingOf: aSymbol].
	^ nil
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> instSpec [ 
	^ self backend instSpecOfClass: self mirror
]

{ #category : #'accessing-instVars' }
EP2RemoteClass >> instVarNames [
	^ (self allSlots select: #isInstanceVariableSlot) collect: #name
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> instanceFixedSize [
	
	^ self backend instanceFixedSizeOf: self
]

{ #category : #testing }
EP2RemoteClass >> isBitsClass [

	^ self backend isBitsClass: self
	
]

{ #category : #testing }
EP2RemoteClass >> isRemoteClass [
	^ true
]

{ #category : #testing }
EP2RemoteClass >> isRoleMetaclass [
	^ self backend isRoleMetaclass: self
]

{ #category : #testing }
EP2RemoteClass >> isStub [
	self flag: 'find a more stable way to check this'.
	^ (self format isSmallInteger 
		and: [ self superclass isNilObject ])
		and: [ ([self classPool] on: AssertionFailure do: [ 42 ]) == 42 ]
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> layoutClass [
	" generic layout "
	^ EP2FixedLayout
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> name: aString [ 

	self instanceVariableAtIndex: self classNameIndex put: aString asSymbol
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> new [
	^ self basicNew mirror asRemoteObject
]

{ #category : #printing }
EP2RemoteClass >> printOn: aStream [
	aStream 
		nextPutAll: '*';
		nextPutAll: self classNameFromAnyOrigin;
		nextPutAll: '*'
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> sharedPool [
	^ self instanceVariableAtIndex: self classSharedPoolsIndex 
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> slotNamed: aString [ 
	^ (self allSlots select: [ :slot | slot name = aString ]) anyOne
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> slots [
	| allSlots |
	allSlots := OrderedCollection new.
	self slotsDo: [ :each | allSlots add: each].
	^ allSlots asArray
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> slotsDo: aBlock [
	self backend slotsFor: self do: aBlock
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> superclass [
	^ self instanceVariableAtIndex: self classSuperclassIndex 
]
