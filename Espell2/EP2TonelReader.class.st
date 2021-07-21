Class {
	#name : #EP2TonelReader,
	#superclass : #TonelReader,
	#instVars : [
		'metamodel'
	],
	#category : #'Espell2-Tonel'
}

{ #category : #accessing }
EP2TonelReader class >> canReadFileNamed: fileName [
	"We validate that fileName does not contains dot, but that's the only thing we can do 
	 at this point."
	^ (fileName noneSatisfy: [ :each | each = $. ]) and: [fileName beginsWith: 'Kernel-']
]

{ #category : #accessing }
EP2TonelReader class >> definitionOrders [
	"Used to sort definitions inside a snapshot"
	^ Dictionary newFromPairs: { 
		MCOrganizationDefinition. 	0.
		MCMethodDefinition. 			1.
		EP2MCClassDefinition. 		2. 
		MCTraitDefinition. 			2.
		MCClassTraitDefinition. 		3 }
]

{ #category : #accessing }
EP2TonelReader class >> isAbstract [ 
	^ false
]

{ #category : #loading }
EP2TonelReader >> loadDefinitions [
	| definitionOrders newDefinitions newCategories organization |
	
	definitionOrders := self class definitionOrders.
	newDefinitions := ((self packageDirectory entries
		select: [ :each | self canBeLoaded: each ]) 
		collect: [ :each | each readStreamDo: [ :s | EP2TonelParser parseStream: s metamodel: self metamodel ] ])
		flattened
		sort: [ :a :b | (definitionOrders at: a class) < (definitionOrders at: b class) ].

	newCategories := self categoriesFrom: newDefinitions.
	(newCategories includes: self package name asSymbol)
		ifFalse: [ newCategories := newCategories copyWithFirst: self package name ].
	organization := MCOrganizationDefinition categories: newCategories.
	
	definitions := (newDefinitions copyWithFirst: organization) sort
]

{ #category : #accessing }
EP2TonelReader >> metamodel [
	^ metamodel
]

{ #category : #accessing }
EP2TonelReader >> metamodel: anEP2MLanguage [  
	metamodel := anEP2MLanguage
]
