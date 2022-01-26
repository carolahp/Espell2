Class {
	#name : #MetaclassFieldAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #'model build' }
MetaclassFieldAspect >> extend: aClassModel withMonticello: anEP2MCClassDefinition [ 
	| mcDef metaclassDef model |
	model := aClassModel.
	mcDef := anEP2MCClassDefinition.
	metaclassDef := mcDef metaclass.
	self assert: (model name isNil or: [model name = anEP2MCClassDefinition name]).
	model
		metaclass:
			(metaclassDef
				ifNotNil: [ model parent ensureClassNamed: metaclassDef ]
				ifNil: [ model parent classClass ]).
]

{ #category : #accessing }
MetaclassFieldAspect >> fieldName [
	^ #metaclass
]

{ #category : #accessing }
MetaclassFieldAspect >> fieldValueFor: aClassModel [
	^ aClassModel parent classClass
]

{ #category : #accessing }
MetaclassFieldAspect >> firstClassModelRoles [
	^ #()
]

{ #category : #binding }
MetaclassFieldAspect >> innerBindingOf: aSymbol in: aClassModel [
	^ nil
]

{ #category : #'model build' }
MetaclassFieldAspect >> transformLanguageCustom: aLanguageModel [
	self
]
