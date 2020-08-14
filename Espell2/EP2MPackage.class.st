Class {
	#name : #EP2MPackage,
	#superclass : #EP2MObject,
	#instVars : [
		'definedBehaviors'
	],
	#category : #'Espell2-Metamodel'
}

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
	
	definitions := ((((self definedBehaviors reject: #isMeta) sorted: [:a :b | a name < b name ]) collect: #asMCDefinition), (self extensionMethods collect: #asMCDefinition)) asOrderedCollection.
	definitions addAll: ((self definedBehaviors, (self definedBehaviors collect: #classSide)) flatCollect: [ :behavior |
		(behavior localMethods reject: [:each | (each  parent instanceSide package = each package) not])
			collect: [ :method | method asMCDefinition] ]).
	
	^ MCSnapshot fromDefinitions: definitions.
]

{ #category : #initialize }
EP2MPackage >> defaultDefinedBehaviors [
	^ Set new
]

{ #category : #accessing }
EP2MPackage >> definedBehaviors [
	^ definedBehaviors
]

{ #category : #testing }
EP2MPackage >> definesBehavior: anOLClass [ 
	^ self definedBehaviors anySatisfy: [:beh | beh = anOLClass ].
]

{ #category : #initialize }
EP2MPackage >> initialize [ 
	super initialize.
	definedBehaviors := self defaultDefinedBehaviors
]

{ #category : #testing }
EP2MPackage >> isEmpty [
	^ self definedBehaviors isEmpty
]

{ #category : #printing }
EP2MPackage >> printOn: aStream [
	aStream 
		nextPutAll: 'a Package "';
		nextPutAll: self name asString;
		nextPutAll: '"'
]
