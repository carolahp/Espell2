Class {
	#name : #PackageModel,
	#superclass : #ObjectModel,
	#instVars : [
		'definedBehaviors'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #calypso }
PackageModel class >> convertToCalypsoBrowserItem: anEP2MPackage [ 
	^ClyBrowserItem named: anEP2MPackage name with: anEP2MPackage
]

{ #category : #calypso }
PackageModel class >> prepareClassQueriesFrom: packages in: aNavigationEnvironment [ 
	^{
		ClyAllClassesQuery from: ClyPackageScope ofAll: packages in: aNavigationEnvironment.
		ClyAllClassesQuery from: ClyPackageExtensionScope ofAll: packages in: aNavigationEnvironment 
	}
]

{ #category : #'accessing-backend' }
PackageModel >> addDefinedBehavior: aClass [ 
	(self definesBehavior: aClass)
		ifFalse: [ self definedBehaviors add: aClass ].
	^ aClass
]

{ #category : #'accessing backend' }
PackageModel >> allDefinedBehaviors [
	^ self definedBehaviors 
]

{ #category : #tonel }
PackageModel >> asMCDefinition [
	^ MCOrganizationDefinition categories: self categories asOrderedCollection 
]

{ #category : #exporting }
PackageModel >> asMCSnapshot [
	| definitions |
	definitions := #() asOrderedCollection.
	"adding the package"
	definitions add: self asMCDefinition.
	"adding behaviors"
	definitions
		addAll:
			(((self definedBehaviors reject: #isMeta)
				sorted: [ :a :b | a name < b name ]) collect: #asMCDefinition).
	"adding methods"
	definitions
		addAll:
			(self definedBehaviors , (self definedBehaviors collect: #metaclass)
				flatCollect: [ :behavior | 
					(behavior localMethods
						reject: [ :each | (each parent instanceSide package = each package) not ])
						collect: [ :method | method asMCDefinition ] ]).
	^ MCSnapshot fromDefinitions: definitions
]

{ #category : #calypso }
PackageModel >> calypsoEnvironmentType [
	^RPackage
]

{ #category : #tonel }
PackageModel >> categories [
	
	^ self definedBehaviors collect: #category as: Set

]

{ #category : #calypso }
PackageModel >> classes [
	^ self allDefinedBehaviors 
]

{ #category : #initialize }
PackageModel >> defaultDefinedBehaviors [
	^ Set new
]

{ #category : #accessing }
PackageModel >> definedBehaviors [
	^ definedBehaviors
]

{ #category : #calypso }
PackageModel >> definedClasses [
	^ self definedBehaviors 
]

{ #category : #testing }
PackageModel >> definesBehavior: anOLClass [ 
	^ self definedBehaviors anySatisfy: [:beh | beh = anOLClass ].
]

{ #category : #calypso }
PackageModel >> destroy [
	super destroy.
	definedBehaviors
		ifNotNil: [ 
			definedBehaviors do: [ :beh | beh destroy ].
			definedBehaviors := nil ]
]

{ #category : #accessing }
PackageModel >> environment [ 
	^ self parent
]

{ #category : #'abstract instructions' }
PackageModel >> extendedClasses [
	^ #()
]

{ #category : #calypso }
PackageModel >> includesClassesAffectedBy: aSystemAnnouncement [

	^(aSystemAnnouncement affectsClassesDefinedInPackage: self)
		or: [ aSystemAnnouncement affectsClassesExtendedInPackage: self ]
]

{ #category : #initialize }
PackageModel >> initialize [ 
	super initialize.
	definedBehaviors := self defaultDefinedBehaviors
]

{ #category : #calypso }
PackageModel >> isAboutPackage: anEP2MPackage [ 
	^ self == anEP2MPackage 
]

{ #category : #testing }
PackageModel >> isEmpty [
	^ self definedBehaviors isEmpty
]

{ #category : #testing }
PackageModel >> isNotEmpty [
	^ self definedBehaviors size > 0
]

{ #category : #'compatibilty candle' }
PackageModel >> maybeAccessedPropertyName [
	^ self environment maybeAccessedPropertyName
]

{ #category : #calypso }
PackageModel >> packageManifestOrNil [
	^ nil
]

{ #category : #printing }
PackageModel >> printOn: aStream [
	aStream 
		nextPutAll: 'a Package "';
		nextPutAll: self name asString;
		nextPutAll: '"'
]

{ #category : #registering }
PackageModel >> register [ 
	^ self registerCustom
]

{ #category : #registering }
PackageModel >> registerCustom [
	self subclassResponsibility
]

{ #category : #calypso }
PackageModel >> tagsForClasses [
	^ IdentitySet new
]

{ #category : #metamodel }
PackageModel >> tempVariableModel [
	self deprecated: 'use MethodModel>>tempVariableModel'.
	^ self parent class tempVariableModel
]
