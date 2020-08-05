Class {
	#name : #EP2RemoteClass,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteClass class >> allInstVarNames [
	^#(#superclass #methodDict #format)
]

{ #category : #constants }
EP2RemoteClass class >> layoutClass [
	^ EP2FixedLayout
]

{ #category : #constants }
EP2RemoteClass class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteClass class >> role [ 
	^ 'Class'
]

{ #category : #accessing }
EP2RemoteClass >> addressDefinitionMap [
	^ self backend objectSpace interpreter codeProvider classLoader addressDefinitionMap
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> allSlots [ 
	^ self slots
]

{ #category : #'converting-local' }
EP2RemoteClass >> asClassDefinition [
	^ [self addressDefinitionMap at: self target address ] on: KeyNotFound do: [ self backend builder systemDefinitionAt: #Class ]
]

{ #category : #compatibility }
EP2RemoteClass >> asClassMirror [
	^ self 
]

{ #category : #accessing }
EP2RemoteClass >> asLocalClass [
	"it returns the EP2Remote class that corresponds with this class.
	For example: Association asLocalClass will return EP2RemoteAssociation.
	We use this to instantiate the correct class for each remote object we fetch from the remote object memory"
	"^ self addressLocalClassMap 
		at: self mirror target address 
		ifAbsentPut: [" | definition role localClassOrNil |
			definition := [self addressDefinitionMap at: self mirror target address] 
				on: KeyNotFound 
				do: [ ^ nil " self backend builder systemDefinitionAt: #Class" ].
			"if I am a metaclass, my instances can be represented as instances of EP2RemoteMetaclass"
			definition isMetaclass ifTrue: [^ EP2RemoteMetaclass].
			role := self backend systemDefinition roleOfClass: definition.
			localClassOrNil := Smalltalk classNamed: 'EP2Remote', role asString.
		^	localClassOrNil
		"]"
]

{ #category : #'converting-local' }
EP2RemoteClass >> asRGClass [
	^ self asClassDefinition
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> basicNew [
	" casting as remote object or immediate, depending on my layout "
	^ self layout class defaultRemoteObjectClass  
		on: (self backend basicNewOn: self) 
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> basicNew: aSize [ 

	^ self backend basicNewOn: self withSize: aSize
]

{ #category : #binding }
EP2RemoteClass >> binding [
	^ self bindingOf: self className
]

{ #category : #binding }
EP2RemoteClass >> bindingOf: aSymbol [ 
	| binding |
	(self classPool isNilObject not 
	and: [ self asRGClass classPool includes: aSymbol ]) 
		ifTrue: [ binding := self classPool at: aSymbol ].
	
	(self sharedPool isNilObject) ifFalse: [ self halt ].
	
	self flag: 'superclass is nil for all stubs, check this later'.
	(self superclass isNilObject) ifFalse:  [
		(self superclass bindingOf: aSymbol) ifNotNil: [ :bind | ^ bind ]].
	
	(self backend builder systemDefinition at: aSymbol)
	ifNotNil: [ 
		"checking that the remote class exists"
		(self backend objectSpace systemDictionary at: aSymbol) ifNil: [ self halt: 'asking for a class that has not yet been installed' ].
		^ EP2GlobalBinding new
			name: aSymbol;
			objectSpace: self backend objectSpace;
			yourself ].
	
	^ nil
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
	^ (self instanceVariableAtIndex: self classPoolIndex) asRemoteDictionary 
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> classPool: anObject [ 
	
	^ self instanceVariableAtIndex: self classPoolIndex put: anObject
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classPoolIndex [
	^ (self systemDefinition instanceVariableMapping classPoolIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classSharedPoolsIndex [
	^ (self systemDefinition instanceVariableMapping classSharedPoolsIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> classSide [
	^ self isMetaclass 
		ifTrue: [ self	]
		ifFalse: [ self basicClass ]
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classSuperclassIndex [
	^ (self systemDefinition instanceVariableMapping classSuperclassIndex) ifNil: [ self error: 'undefined index for superclass inst var in Class' ]
]

{ #category : #'accessing-header' }
EP2RemoteClass >> compactClassIndex [
	^ self backend compactClassIndexOf: self
	
]

{ #category : #'public-api' }
EP2RemoteClass >> fixedSize [
	^self basicClass instanceFixedSize
]

{ #category : #'accessing-header' }
EP2RemoteClass >> format [
	^ (self layout instanceVariableAtIndex: self classFormatIndex) asRemoteSmallInteger
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> format: anInteger [
	^self layout instanceVariableAtIndex: self classFormatIndex put: anInteger
]

{ #category : #initialize }
EP2RemoteClass >> initialize [ 
	super initialize
]

{ #category : #binding }
EP2RemoteClass >> innerBindingOf: aSymbol [ 
	| result |
	self classPool isNilObject not 
		ifTrue: [ result := self classPool at: aSymbol ifAbsent: [ nil ] ].
	result ifNotNil: [
		^ EP2ClassVariableBinding new
				name: aSymbol asSymbol
				ownerName: self classNameFromAnyOrigin
				objectSpace: mirror backend objectSpace;
				yourself ] .
	
	(self sharedPool isNilObject) ifFalse: [ self halt ].
	
	self flag: 'superclass is nil for all stubs, check this later'.
	(self superclass isNilObject) ifFalse:  [^ self superclass innerBindingOf: aSymbol].
	
	^ nil
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> instSpec [ 
	^ self mirror target instSpec
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
EP2RemoteClass >> instanceSide [
	^ self isClass 
		ifTrue: [ self ]
		ifFalse: [ self mirror asRemoteMetaclass soleInstance ]
]

{ #category : #testing }
EP2RemoteClass >> isBitsClass [

	^ self backend isBitsClass: self
	
]

{ #category : #testing }
EP2RemoteClass >> isClass [
	^ self asRGClass isClass
]

{ #category : #testing }
EP2RemoteClass >> isClassMirror [
	^ true
]

{ #category : #testing }
EP2RemoteClass >> isMetaclass [
	^ self asRGClass isMeta
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

{ #category : #accessing }
EP2RemoteClass >> name [
	^ self className
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> name: aString [ 

	self instanceVariableAtIndex: self classNameIndex put: aString asSymbol
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> new [
	^ self 
		evaluateCode: 'aClass new'
		withTemps: { #aClass -> self } 
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
	^ (self allSlots select: [ :slot | slot name = aString ]) 
		ifEmpty: [ EP2SlotNotFoundException signal ] 
		ifNotEmpty: [:results | results anyOne]
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> superclass [
	^ (self instanceVariableAtIndex: self classSuperclassIndex) asRemoteClass
]
