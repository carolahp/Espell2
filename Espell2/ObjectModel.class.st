Class {
	#name : #ObjectModel,
	#superclass : #Object,
	#instVars : [
		'properties',
		'parent',
		'objectName',
		'role',
		'remote'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #instanciation }
ObjectModel class >> allModelInstVarNames [
	^ self allInstVarNames difference: ObjectModel allInstVarNames
]

{ #category : #instanciation }
ObjectModel class >> customModels [
	" returns the model classes used to build the model "
	^#()
]

{ #category : #instanciation }
ObjectModel class >> defaultLayout [
	self subclassResponsibility 
]

{ #category : #instanciation }
ObjectModel class >> named: aString parent: anEP2MLanguage [ 
	^ self basicNew
		name: aString asSymbol;
		parent: anEP2MLanguage;
		initialize;
		yourself
]

{ #category : #instanciation }
ObjectModel class >> role [ 
	^ nil
]

{ #category : #accessing }
ObjectModel >> announcer [ 
	^ self environment announcer
]

{ #category : #compatibility }
ObjectModel >> asRemoteObject [
	self halt.
	^ self 
]

{ #category : #'accessing remote backend' }
ObjectModel >> asRemoteObjectInObjectSpace: anObjectSpace [
	| missingFields |
	self ensureRemote.
	missingFields := self class allModelInstVarNames.
	missingFields
		do: [ :each | 
			| value |
			value := self perform: each.
			self remote perform: each , ':' with: value ].
	^ remote
]

{ #category : #'evaluate ast' }
ObjectModel >> debugCode: aString [ 
	^ self debugCode: aString temps: #()
]

{ #category : #'evaluate ast' }
ObjectModel >> debugCode: aString temps: aCollection [ 
	^ (self newInstruction code: aString; temps: aCollection) debug
]

{ #category : #'instruction hooks' }
ObjectModel >> destroy [
	remote := nil.
	role := nil.
	parent := nil.
	objectName := nil.
	properties := nil.
	
	
]

{ #category : #'accessing remote backend' }
ObjectModel >> ensureRemote [
	remote ifNotNil: [ ^remote ].
	remote := (self language classWithRole: self class role) remote new.
	^ remote
	
]

{ #category : #accessing }
ObjectModel >> environment [
	^ parent
]

{ #category : #'evaluate ast' }
ObjectModel >> evaluateCode: aString [ 
	^ self evaluateCode: aString temps: #()
]

{ #category : #'evaluate ast' }
ObjectModel >> evaluateCode: aString temps: aCollection [ 
	^ (self newInstruction code: aString; temps: aCollection) evaluate asRemoteObjectCasted
]

{ #category : #'evaluate ast' }
ObjectModel >> evaluateCodeD: aString [
	" use DASTInterpreter for the evaluation "
	^ self evaluateCodeD: aString temps: #() 
]

{ #category : #'evaluate ast' }
ObjectModel >> evaluateCodeD: aString temps: aCollection [ 
	" use DASTInterpreter for the evaluation "
	^ (self newInstruction
		code: aString;
		temps: aCollection) evaluateWithDASTInterpreter 
]

{ #category : #'evaluate ast' }
ObjectModel >> evaluateMarking: aString [
	^ self evaluateMarking: aString temps: #() 
]

{ #category : #'evaluate ast' }
ObjectModel >> evaluateMarking: aString temps: aCollection [
	^ (self newInstruction
		code: aString;
		temps: aCollection) evaluateMarking
]

{ #category : #'evaluate ast' }
ObjectModel >> evaluateToSpecialize: aString [ 
	^ self evaluateToSpecialize: aString temps: #()
]

{ #category : #'evaluate ast' }
ObjectModel >> evaluateToSpecialize: aString temps: aCollection [
	self installAccessedObjectsOnly: true.
	self environment
		removeFromAllElementsPropertyNamed: self environment objectAccessedPropertyName.
	^ (self newInstruction
		code: aString;
		temps: aCollection) evaluateMarking
]

{ #category : #testing }
ObjectModel >> hasProperties [

	^ properties isEmptyOrNil not
]

{ #category : #testing }
ObjectModel >> hasPropertyNamed: propertyName [
	
	^ self hasProperties
		ifTrue: [ properties includesKey: propertyName ]	
		ifFalse:[ false ].

]

{ #category : #accessing }
ObjectModel >> imageBuilder [
	^ self remote backend builder
]

{ #category : #marking }
ObjectModel >> installAccessedObjectsOnly: aBoolean [
	self environment installAccessedObjectsOnly: aBoolean
]

{ #category : #testing }
ObjectModel >> isClassModel [
	^ false
]

{ #category : #marking }
ObjectModel >> isInstallable [
	^ self environment installAccessedObjectsOnly
		ifTrue: [ self isMarkedAsAccessed ]
		ifFalse: [ true ]
]

{ #category : #accessing }
ObjectModel >> isLanguageModel [
	^ false
]

{ #category : #marking }
ObjectModel >> isMarkedAsAccessed [
	^ self 
		propertyNamed: self environment objectAccessedPropertyName 
		ifAbsent: [ false ]
]

{ #category : #accessing }
ObjectModel >> language [
	| model |
	model := self.
	[ model isNil or: [ model isLanguageModel ] ]
		whileFalse: [ model := model parent ].
	^ model
]

{ #category : #marking }
ObjectModel >> markAsAccessed [
	self propertyNamed: self parent objectAccessedPropertyName put: true
]

{ #category : #marking }
ObjectModel >> markAsMaybeAccessed [
	
	self 
		propertyNamed: self environment maybeAccessedPropertyName
		put: true
]

{ #category : #'accessing-api' }
ObjectModel >> name [ 
	^ objectName
]

{ #category : #'accessing-api' }
ObjectModel >> name: aString [ 
	objectName := aString
]

{ #category : #'instruction hooks' }
ObjectModel >> newDummyInstruction [
	^ PBInstructionDummy new
]

{ #category : #'hook instructions' }
ObjectModel >> newInstruction [
	^ PBReflectiveInstruction new 
		languageDefinition: self;
		yourself
]

{ #category : #accessing }
ObjectModel >> parent [
	^ parent
]

{ #category : #accessing }
ObjectModel >> parent: anEP2MLanguage [ 
	parent := anEP2MLanguage
]

{ #category : #'accessing properties' }
ObjectModel >> properties [

	^ properties ifNil: [ properties := IdentityDictionary new ]
]

{ #category : #'accessing properties' }
ObjectModel >> propertyNamed: annotationName ifAbsent: exceptionBlock [ 

	^ self properties
			at: annotationName
			ifAbsent: [ exceptionBlock value ]
]

{ #category : #'accessing properties' }
ObjectModel >> propertyNamed: annotationName ifAbsentPut: blockValue [ 

	^ self properties
		at: annotationName
		ifAbsentPut: blockValue
]

{ #category : #'accessing properties' }
ObjectModel >> propertyNamed: annotationName put: value [ 

	self properties
		at: annotationName
		put: value
]

{ #category : #'accessing properties' }
ObjectModel >> propertyNames [
	
	self hasProperties
		ifFalse:[ ^ OrderedCollection new ].
	^ properties keys
]

{ #category : #'accessing remote backend' }
ObjectModel >> remote [
	^ remote
]

{ #category : #'accessing remote backend' }
ObjectModel >> remote: anEP2Remote [ 
	remote := anEP2Remote 
]

{ #category : #'accessing remote backend' }
ObjectModel >> remoteBackend [
	^ self parent remote espellBackend 
]

{ #category : #marking }
ObjectModel >> removePropertyNamed: propertyName [ 
	
	(self hasPropertyNamed: propertyName)
		ifTrue: [ properties removeKey: propertyName ]
]

{ #category : #accessing }
ObjectModel >> role [ 
	^ role
]

{ #category : #'transforming objects' }
ObjectModel >> toRemoteObject: aLocalObject [ 
	^ aLocalObject asRemoteObjectInObjectSpace: self remoteBackend objectSpace
]

{ #category : #'unresolved objects' }
ObjectModel >> unresolvedValue: aDefaultValue [
self halt:'do I need this?'.
	^ EP2MUnresolvedValue new
		default: aDefaultValue;
		yourself
]
