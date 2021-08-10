"
I am the metamodel of a class in Candle with explicit metaclasses

"
Class {
	#name : #ExplicitMetaclassesClass,
	#superclass : #ClassModel,
	#instVars : [
		'metaclass'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #accessing }
ExplicitMetaclassesClass >> extendWithMonticelloCustom: aMCClassDefinition [ 
	"metaclass"
	| mcDef metaclassDef |
	
	mcDef := aMCClassDefinition.
	metaclassDef := mcDef metaclass. 
	self
		metaclass:
			(metaclassDef
				ifNotNil: [ self parent ensureClassNamed: metaclassDef ]
				ifNil: [ self parent classClass ]).
]

{ #category : #hooks }
ExplicitMetaclassesClass >> innerBindingOf: aString [ 
	^ nil
]

{ #category : #accessing }
ExplicitMetaclassesClass >> metaclass [
	^ metaclass
]

{ #category : #accessing }
ExplicitMetaclassesClass >> metaclass: anObject [
	metaclass := anObject
]

{ #category : #accessing }
ExplicitMetaclassesClass >> test [ 
	super test.
	self assert: self metaclass isNotNil.
	self assert: self metaclass layout isFixedLayout

]
