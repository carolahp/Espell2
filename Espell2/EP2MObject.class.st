Class {
	#name : #EP2MObject,
	#superclass : #Object,
	#instVars : [
		'properties',
		'name',
		'parent'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #instanciation }
EP2MObject class >> named: aString parent: anEP2MLanguage [ 
	^ self basicNew
		name: aString asSymbol;
		parent: anEP2MLanguage;
		initialize;
		yourself
]

{ #category : #accessing }
EP2MObject >> environment [
	^ parent
]

{ #category : #testing }
EP2MObject >> hasProperties [

	^ properties isEmptyOrNil not
]

{ #category : #testing }
EP2MObject >> hasPropertyNamed: propertyName [
	
	^ self hasProperties
		ifTrue: [ properties includesKey: propertyName ]	
		ifFalse:[ false ].

]

{ #category : #marking }
EP2MObject >> isInstallable [
	^ true
]

{ #category : #marking }
EP2MObject >> isMarkedAsAccessed [
	^ self 
		propertyNamed: self environment objectAccessedPropertyName 
		ifAbsent: [ false ]
]

{ #category : #'accessing-api' }
EP2MObject >> name [ 
	^ name
]

{ #category : #'accessing-api' }
EP2MObject >> name: aString [ 
	name := aString
]

{ #category : #'instruction hooks' }
EP2MObject >> newDummyInstruction [
	^ PBInstructionDummy new
]

{ #category : #'hook instructions' }
EP2MObject >> newInstruction [
	^ PBInstructionGenericRemote new 
		languageDefinition: self;
		imageBuilder: self imageBuilder;
		yourself
]

{ #category : #accessing }
EP2MObject >> parent [
	^ parent
]

{ #category : #accessing }
EP2MObject >> parent: anEP2MLanguage [ 
	parent := anEP2MLanguage
]

{ #category : #'accessing properties' }
EP2MObject >> properties [

	^ properties ifNil: [ properties := IdentityDictionary new ]
]

{ #category : #'accessing properties' }
EP2MObject >> propertyNamed: annotationName ifAbsent: exceptionBlock [ 

	^ self properties
			at: annotationName
			ifAbsent: [ exceptionBlock value ]
]

{ #category : #'accessing properties' }
EP2MObject >> propertyNamed: annotationName ifAbsentPut: blockValue [ 

	^ self properties
		at: annotationName
		ifAbsentPut: blockValue
]

{ #category : #'accessing properties' }
EP2MObject >> propertyNamed: annotationName put: value [ 

	self properties
		at: annotationName
		put: value
]

{ #category : #'accessing properties' }
EP2MObject >> propertyNames [
	
	self hasProperties
		ifFalse:[ ^ OrderedCollection new ].
	^ properties keys
]

{ #category : #'accessing remote backend' }
EP2MObject >> remoteBackend [
	^ self parent remote espellBackend 
]

{ #category : #marking }
EP2MObject >> removePropertyNamed: propertyName [ 
	
	(self hasPropertyNamed: propertyName)
		ifTrue: [ properties removeKey: propertyName ]
]

{ #category : #'unresolved objects' }
EP2MObject >> unresolvedValue: aDefaultValue [
self halt:'do I need this?'.
	^ EP2MUnresolvedValue new
		default: aDefaultValue;
		yourself
]
