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
ObjectModel class >> named: aString parent: anEP2MLanguage [ 
	^ self basicNew
		name: aString asSymbol;
		parent: anEP2MLanguage;
		initialize;
		yourself
]

{ #category : #accessing }
ObjectModel >> announcer [ 
	^ self environment announcer
]

{ #category : #compatibility }
ObjectModel >> asRemoteObject [
	^ self 
]

{ #category : #'evaluate ast' }
ObjectModel >> debugCode: aString [ 
	^ self debugCode: aString temps: #()
]

{ #category : #'evaluate ast' }
ObjectModel >> debugCode: aString temps: aCollection [ 
	^ (self newInstruction code: aString; temps: aCollection) debug
]

{ #category : #accessing }
ObjectModel >> environment [
	^ parent
]

{ #category : #'ast-evaluation' }
ObjectModel >> evaluateCode: aString [ 
	^ self evaluateCode: aString temps: #()
]

{ #category : #'evaluating ast' }
ObjectModel >> evaluateCode: aString temps: aCollection [ 
	^ (self newInstruction code: aString; temps: aCollection) evaluate asRemoteObjectCasted
]

{ #category : #'evaluating ast' }
ObjectModel >> evaluateToSpecialize: aString [ 
	^ self evaluateToSpecialize: aString temps: #()
]

{ #category : #'evaluating ast' }
ObjectModel >> evaluateToSpecialize: aString temps: aCollection [
	self installAccessedObjectsOnly: true.
	self environment
		removeFromAllElementsPropertyNamed: self environment objectAccessedPropertyName.
	^ (self newInstruction
		code: aString;
		temps: aCollection) evaluateToSpecialize
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

{ #category : #marking }
ObjectModel >> isInstallable [
	^ self environment installAccessedObjectsOnly
		ifTrue: [ self isMarkedAsAccessed ]
		ifFalse: [ true ]
]

{ #category : #marking }
ObjectModel >> isMarkedAsAccessed [
	^ self 
		propertyNamed: self environment objectAccessedPropertyName 
		ifAbsent: [ false ]
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
ObjectModel >> remoteBackend [
	^ self parent remote espellBackend 
]

{ #category : #marking }
ObjectModel >> removePropertyNamed: propertyName [ 
	
	(self hasPropertyNamed: propertyName)
		ifTrue: [ properties removeKey: propertyName ]
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
