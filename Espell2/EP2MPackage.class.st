Class {
	#name : #EP2MPackage,
	#superclass : #EP2MObject,
	#instVars : [
		'definedBehaviors'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #calypso }
EP2MPackage class >> convertToCalypsoBrowserItem: anEP2MPackage [ 
	^ClyBrowserItem named: anEP2MPackage name with: anEP2MPackage
]

{ #category : #calypso }
EP2MPackage class >> prepareClassQueriesFrom: packages in: aNavigationEnvironment [ 
	^{
		ClyAllClassesQuery from: ClyPackageScope ofAll: packages in: aNavigationEnvironment.
		ClyAllClassesQuery from: ClyPackageExtensionScope ofAll: packages in: aNavigationEnvironment 
	}
]

{ #category : #'accessing-backend' }
EP2MPackage >> addDefinedBehavior: aClass [ 
	(self definesBehavior: aClass)
		ifFalse: [ self definedBehaviors add: aClass ].
	^ aClass
]

{ #category : #'accessing backend' }
EP2MPackage >> allDefinedBehaviors [
	^ self definedBehaviors 
]

{ #category : #exporting }
EP2MPackage >> asMCSnapshot [
	
	| definitions | 
	
	definitions := ((((self definedBehaviors reject: #isMeta) sorted: [:a :b | a name < b name ]) collect: #asMCDefinition)", (self extensionMethods collect: #asMCDefinition)") asOrderedCollection.
	definitions addAll: ((self definedBehaviors, (self definedBehaviors collect: #metaclass)) flatCollect: [ :behavior |
		(behavior localMethods reject: [:each | (each  parent instanceSide package = each package) not])
			collect: [ :method | method asMCDefinition] ]).
	
	^ MCSnapshot fromDefinitions: definitions.
]

{ #category : #calypso }
EP2MPackage >> calypsoEnvironmentType [
	^RPackage
]

{ #category : #calypso }
EP2MPackage >> classes [
	^ self allDefinedBehaviors 
]

{ #category : #initialize }
EP2MPackage >> defaultDefinedBehaviors [
	^ Set new
]

{ #category : #accessing }
EP2MPackage >> definedBehaviors [
	^ definedBehaviors
]

{ #category : #calypso }
EP2MPackage >> definedClasses [
	^ self definedBehaviors 
]

{ #category : #testing }
EP2MPackage >> definesBehavior: anOLClass [ 
	^ self definedBehaviors anySatisfy: [:beh | beh = anOLClass ].
]

{ #category : #'abstract instructions' }
EP2MPackage >> extendedClasses [
	^ #()
]

{ #category : #initialize }
EP2MPackage >> initialize [ 
	super initialize.
	definedBehaviors := self defaultDefinedBehaviors
]

{ #category : #calypso }
EP2MPackage >> isAboutPackage: anEP2MPackage [ 
	^ self == anEP2MPackage 
]

{ #category : #testing }
EP2MPackage >> isEmpty [
	^ self definedBehaviors isEmpty
]

{ #category : #testing }
EP2MPackage >> isNotEmpty [
	^ self definedBehaviors size > 0
]

{ #category : #calypso }
EP2MPackage >> packageManifestOrNil [
	^ nil
]

{ #category : #printing }
EP2MPackage >> printOn: aStream [
	aStream 
		nextPutAll: 'a Package "';
		nextPutAll: self name asString;
		nextPutAll: '"'
]

{ #category : #calypso }
EP2MPackage >> tagsForClasses [
	^ IdentitySet new
]
