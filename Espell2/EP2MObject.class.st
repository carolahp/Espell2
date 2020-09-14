Class {
	#name : #EP2MObject,
	#superclass : #Object,
	#instVars : [
		'properties',
		'parent',
		'objectName'
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

{ #category : #compatibility }
EP2MObject >> asRemoteObject [
	^ self 
]

{ #category : #'evaluate ast' }
EP2MObject >> debugCode: aString [ 
	^ self debugCode: aString temps: #()
]

{ #category : #'evaluate ast' }
EP2MObject >> debugCode: aString temps: aCollection [ 
	^ (self newInstruction code: aString; temps: aCollection) debug
]

{ #category : #accessing }
EP2MObject >> environment [
	^ parent
]

{ #category : #'ast-evaluation' }
EP2MObject >> evaluateCode: aString [ 
	^ self evaluateCode: aString temps: #()
]

{ #category : #'evaluating ast' }
EP2MObject >> evaluateCode: aString temps: aCollection [ 
	^ (self newInstruction code: aString; temps: aCollection) evaluate asRemoteObjectCasted
]

{ #category : #'evaluating ast' }
EP2MObject >> evaluateLoadingMissingDefinitionsFromPharo: aString [ 
	^ self evaluateLoadingMissingDefinitionsFromPharo: aString temps: #()
]

{ #category : #'evaluating ast' }
EP2MObject >> evaluateLoadingMissingDefinitionsFromPharo: aString temps: aCollection [ 
	^ (self newInstruction code: aString; temps: aCollection) evaluateLoadingMissingDefinitionsFromPharo
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

{ #category : #accessing }
EP2MObject >> imageBuilder [
	^ self remote backend builder
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

{ #category : #marking }
EP2MObject >> markAsAccessed [
	self propertyNamed: self parent objectAccessedPropertyName put: true
]

{ #category : #marking }
EP2MObject >> markAsMaybeAccessed [
	
	self 
		propertyNamed: self environment maybeAccessedPropertyName
		put: true
]

{ #category : #'accessing-api' }
EP2MObject >> name [ 
	^ objectName
]

{ #category : #'accessing-api' }
EP2MObject >> name: aString [ 
	objectName := aString
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

{ #category : #'transforming objects' }
EP2MObject >> toRemoteObject: aLocalObject [ 
	^ aLocalObject asRemoteObjectInObjectSpace: self remoteBackend objectSpace
]

{ #category : #'unresolved objects' }
EP2MObject >> unresolvedValue: aDefaultValue [
self halt:'do I need this?'.
	^ EP2MUnresolvedValue new
		default: aDefaultValue;
		yourself
]
