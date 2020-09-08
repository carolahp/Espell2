"
I am the metamodel of a class in Candle with explicit metaclasses

"
Class {
	#name : #MExplicitMetaclassesClass,
	#superclass : #EP2MClass,
	#instVars : [
		'metaclass'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #accessing }
MExplicitMetaclassesClass >> extendWithMonticelloCustom: aMCClassDefinition [ 
	"metaclass"
	| mcDef |
	mcDef := aMCClassDefinition.
	self
		metaclass:
			(mcDef metaclass
				ifNotNil: [ self parent ensureClassNamed: mcDef metaclass ]
				ifNil: [ self parent classMetaclass ]).
]

{ #category : #accessing }
MExplicitMetaclassesClass >> initializeWithTemplateCustom: aTemplate [
	self metaclass: self parent classMetaclass.
]

{ #category : #accessing }
MExplicitMetaclassesClass >> metaclass [
	^ metaclass
]

{ #category : #accessing }
MExplicitMetaclassesClass >> metaclass: anObject [
	metaclass := anObject
]

{ #category : #accessing }
MExplicitMetaclassesClass >> test [ 
	super test.
	self assert: metaclass isNotNil.
	self assert: metaclass layout isFixedLayout

]
