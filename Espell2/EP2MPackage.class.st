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
	self definedBehaviors add: aClass
]

{ #category : #initialize }
EP2MPackage >> defaultDefinedBehaviors [
	^ Set new
]

{ #category : #accessing }
EP2MPackage >> definedBehaviors [
	^ definedBehaviors
]

{ #category : #initialize }
EP2MPackage >> initialize [ 
	super initialize.
	definedBehaviors := self defaultDefinedBehaviors
]

{ #category : #printing }
EP2MPackage >> printOn: aStream [
	aStream 
		nextPutAll: 'a PckgDef "';
		nextPutAll: self name asString;
		nextPutAll: '"'
]
