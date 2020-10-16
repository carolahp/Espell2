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
	| mcDef metaclassDef |
	
	mcDef := aMCClassDefinition.
	metaclassDef := mcDef metaclass. 
	self
		metaclass:
			(metaclassDef
				ifNotNil: [ self parent ensureClassNamed: metaclassDef ]
				ifNil: [ self parent classMetaclass ]).
]

{ #category : #accessing }
MExplicitMetaclassesClass >> initializeWithTemplateCustom: aTemplate [
	self metaclass: self parent classMetaclass.
]

{ #category : #hooks }
MExplicitMetaclassesClass >> innerBindingOf: aString [ 
	^ nil
]

{ #category : #'stubs creation' }
MExplicitMetaclassesClass >> installStubCustom [
	self metaclass = self
		ifTrue: [ ^ self installMetacircularStub ].
	"first install the stub of my metaclass"
	self metaclass installStub.
	"instantiate my metaclass to create a stub of me"
	^ self metaclass newStubWithFormat: self format.
	
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
	self assert: self metaclass isNotNil.
	self assert: self metaclass layout isFixedLayout

]
