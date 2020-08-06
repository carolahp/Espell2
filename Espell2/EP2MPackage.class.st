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

{ #category : #printing }
EP2MPackage >> printOn: aStream [
	aStream 
		nextPutAll: 'a Package "';
		nextPutAll: self name asString;
		nextPutAll: '"'
]
