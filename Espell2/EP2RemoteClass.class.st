Class {
	#name : #EP2RemoteClass,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteClass class >> layoutClass [
	^ EP2FixedLayout
]

{ #category : #constants }
EP2RemoteClass class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteClass class >> modelInstVarNames [
	^ #(#superclass #methodDict #format)
]

{ #category : #constants }
EP2RemoteClass class >> role [ 
	^ #Class
]

{ #category : #accessing }
EP2RemoteClass >> addressDefinitionMap [
	"self deprecated: 'use EP2MClass >> remote instead'."
	^ self backend objectSpace interpreter codeProvider classLoader addressDefinitionMap
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> allSlots [ 
	^ self layout allSlots
]

{ #category : #casting }
EP2RemoteClass >> asCastedRemoteClass [
	^ self mirror target asCastedRemoteClass
]

{ #category : #'converting-local' }
EP2RemoteClass >> asClassDefinition [
	| result classIndex |
	classIndex := self indexInClassTable.
	result := self systemDefinition allClasses
		select:
			[ :classModel | classModel indexInClassTable = classIndex ].
	result isEmpty
		ifTrue: [ self error: 'Class definition not found!' ].
	result size > 1
		ifTrue: [ self error: 'Two classes with the same index' ].
	^ result anyOne
	"| result |
	result := self systemDefinition allClasses
		select: [ :classDef | classDef remote = self ].
	result size = 0
		ifTrue: [ ^ self systemDefinition classClass ].
	result size > 1
		ifTrue: [ self error: 'More than one definition for one class' ].
	^ result anyOne"
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
		ifAbsentPut: ["

	| definition role localClassOrNil |
	definition := self asClassDefinition.
	"if I am a metaclass, my instances can be represented as instances of EP2RemoteMetaclass"
	definition isMetaclass
		ifTrue: [ ^ EP2RemoteMetaclass ].
	role := self backend systemDefinition roleOfClass: definition.
	localClassOrNil := Smalltalk classNamed: 'EP2Remote' , role asString.
	^ localClassOrNil
	"]"
]

{ #category : #'converting-local' }
EP2RemoteClass >> asRGClass [
	^ self asClassDefinition
]

{ #category : #accessing }
EP2RemoteClass >> asRemoteClass [
	^ self
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> asRemoteObjectCasted [
	^ self
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
	^ self asClassDefinition bindingOf: aSymbol
	"| binding |
	(self classPool isNilObject not 
	and: [ self asRGClass classPool includes: aSymbol ]) 
		ifTrue: [ binding := self classPool at: aSymbol ].
	
	(self sharedPool isNilObject) ifFalse: [ self halt ].
	
	self flag: 'superclass is nil for all stubs, check this later'.
	(self superclass isNilObject or: self superclass = self) ifFalse:  [
		(self superclass bindingOf: aSymbol) ifNotNil: [ :bind | ^ bind ]].
	
	(self backend builder systemDefinition globalVariableNamed: aSymbol)
	ifNotNil: [ "
		"checking that the remote class exists"
		"(self backend objectSpace systemDictionary at: aSymbol) ifNil: [ self halt: 'asking for a class that has not yet been installed' ].
		^ EP2GlobalBinding new
			name: aSymbol;
			objectSpace: self backend objectSpace;
			yourself ].
	
	^ nil"
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classFormatIndex [
	^ (self systemDefinition instanceVariableMapping classFormatIndex) ifNil: [ self error: 'undefined index for format inst var in Class' ]
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> classMethodDictionaryIndex [
	^ (self systemDefinition instanceVariableMapping classMethodDictionaryIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> className [
	^ self asClassDefinition
		ifNil: [ nil ]
		ifNotNil: [ :classDef | classDef name ]
	"| remoteName |
	remoteName := [self instanceVariableAtIndex: self classNameIndex] on: SubscriptOutOfBounds, Error do: [ ^ nil ].
	remoteName isNilObject ifTrue: [^nil].
	^ self backend fromRemoteByteSymbol: remoteName"
]

{ #category : #accessing }
EP2RemoteClass >> classNameFromAnyOrigin [
	| result |
	result := self className. 
	^ (result isNil or: [result basicSize = 0]) 
		ifTrue: [ self asClassDefinition 
					ifNil: [ 'Class with no name (', self mirror asString,')' ] 
					ifNotNil: [:classDef | classDef name] ]
		ifFalse: [ result ]
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classNameIndex [
	^ (self systemDefinition instanceVariableMapping classNameIndex) ifNil: [ self class unmappedInstVarIndex ]
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

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> classTableIndex [

	^ self target asClassIndexHandle classIndex
]

{ #category : #'accessing-header' }
EP2RemoteClass >> compactClassIndex [
	^ self backend compactClassIndexOf: self
	
]

{ #category : #'accessors does not understand' }
EP2RemoteClass >> doesNotUnderstand: aMessage [
	| selector index result instVarName |
	"this allows the user to access instance variables defined in their class model by accessors"
	selector := aMessage selector.
	index := selector indexOf: $:.
	[index > 0
		ifTrue: [ 
			"possibly a setter"
			selector size = index
				ifFalse: [ self error ]
				ifTrue: [ 
					instVarName := selector copyUpTo: $:.
					result := self instanceVariableNamed: instVarName put: (aMessage arguments at: 1) ] ]
		ifFalse: [ 
			"possibly a getter"
			result := (self instanceVariableNamed: aMessage selector) asRemoteObjectCasted  ].
	] on: EP2SlotNotFoundException do: [:ex | super doesNotUnderstand: aMessage ].
	^ result
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

{ #category : #'accessing-header' }
EP2RemoteClass >> indexInClassTable [
	^ self classTableIndex
]

{ #category : #testing }
EP2RemoteClass >> inheritsFrom: anEP2RemoteClass [
	| superclass |
	superclass := self superclass.
	superclass = anEP2RemoteClass
		ifTrue: [ ^ true ].
	(superclass isNilObject or: [ superclass = self ])
		ifTrue: [ ^ false ].
	^ superclass inheritsFrom: anEP2RemoteClass
]

{ #category : #initialize }
EP2RemoteClass >> initialize [ 
	super initialize
]

{ #category : #binding }
EP2RemoteClass >> innerBindingOf: aSymbol [ 
	
	^ self asClassDefinition innerBindingOf: aSymbol
	"
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
	(self superclass isNilObject or: self superclass = self) ifFalse:  [^ self superclass innerBindingOf: aSymbol].
	
	^ nil"
]

{ #category : #'accessing-header' }
EP2RemoteClass >> instSize [
	^ self mirror target instSize
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
	^ ((self format isSmallInteger 
		and: [ self superclass isNilObject ])
		and: [ self methodDictionary isNilObject ]) 
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> methodDictionary [
	^ (self instanceVariableAtIndex: self classMethodDictionaryIndex) asRemoteMethodDictionary
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> methodDictionary: aRemoteDictionary [
	self instanceVariableAtIndex: self classMethodDictionaryIndex put: aRemoteDictionary
]

{ #category : #accessing }
EP2RemoteClass >> nameOld [
	^ self instanceVariableAtIndex: self classNameIndex 
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> nameOld: anObject [ 
	| name |
	name := (anObject isKindOf: String) ifTrue: [anObject asSymbol] ifFalse: [anObject].
	self instanceVariableAtIndex: self classNameIndex put: name 
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> new [
	^ (self 
		evaluateCode: 'aClass new'
		withTemps: { #aClass -> self }) asRemoteObjectCasted 
]

{ #category : #printing }
EP2RemoteClass >> printOn: aStream [
	aStream 
		nextPutAll: '*';
		nextPutAll: self classNameFromAnyOrigin;
		nextPutAll: '*'
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

{ #category : #'as yet unclassified' }
EP2RemoteClass >> superclass: anEP2RemoteClass [ 
	^ self instanceVariableAtIndex: self classSuperclassIndex put: anEP2RemoteClass 
]

{ #category : #accessing }
EP2RemoteClass >> target [
	
	^ mirror target asClassIndexHandle address = mirror backend nilObject target address
		ifTrue: [ mirror target ]
		ifFalse: [ mirror target asClassIndexHandle ]
]

{ #category : #testing }
EP2RemoteClass >> test [
	| existentIndexes myIndex |
	self assert: (self superclass isNotNilObject or: [self asClassDefinition isProtoObject ]).
	self assert: self methodDictionary isNotNilObject.
	self assert: self format isNotNilObject.

	self assert: self classNameFromAnyOrigin equals: self asClassDefinition name.
	self methodDictionary test.
	self methodDictionary associations do: [ :assoc | 
		assoc value asRemoteCompiledMethod test
	].
	
	"Class table tests"
	myIndex := self classTableIndex.	
	self assert: self target address equals: (self backend objectMemory classAtIndex: myIndex).	

	existentIndexes := ((self backend builder bootstrapEnvironment allClasses) collect: [ :remoteClasss | remoteClasss classTableIndex ]) values.
	existentIndexes := existentIndexes select: [ :index | index = myIndex ].
	self assert: existentIndexes size = 1 description: 'Index ', myIndex asString, ' appears twice in the class table'.
]

{ #category : #testing }
EP2RemoteClass >> testStub [
	| existentIndexes myIndex |
	self assert: self superclass isNilObject.
	self assert: self basicClass isNotNilObject.
	self assert: self methodDictionary isNilObject.
	self assert: self format isNilObject not.
	myIndex := self classTableIndex.
	self assert: self target address = (self backend objectMemory classAtIndex: myIndex).	
	self assert: self asClassDefinition format = self format asLocalSmallInteger.
	existentIndexes := ((self backend builder bootstrapEnvironment allClasses) collect: [ :remoteClasss | remoteClasss classTableIndex ]) values.
	existentIndexes := existentIndexes select: [ :index | index = myIndex ].
	self assert: existentIndexes size = 1 description: 'Index should appear only once in the class table. Maybe you forgot to register the class ', self className asString, '?'.
]
