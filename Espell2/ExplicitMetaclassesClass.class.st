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
				ifNil: [ self parent classMetaclass ]).
]

{ #category : #accessing }
ExplicitMetaclassesClass >> initializeWithTemplateCustom: aTemplate [
	self metaclass: self parent classMetaclass.
]

{ #category : #hooks }
ExplicitMetaclassesClass >> innerBindingOf: aString [ 
	^ nil
]

{ #category : #'stubs creation' }
ExplicitMetaclassesClass >> installStubCustom [

	self deprecated: 'Use LanguageModel >> installMulticlassStubs:'.
	self metaclass = self
		ifTrue: [ ^ self installMetacircularStub ].
	"first install the stub of my metaclass"
	self metaclass installStub.
	"instantiate my metaclass to create a stub of me"
	^ self metaclass newStubWithFormat: self format.
	
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
