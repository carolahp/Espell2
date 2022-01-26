Class {
	#name : #SuperclassesAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #accessing }
SuperclassesAspect >> fieldName [
	^ #superclasses
]

{ #category : #accessing }
SuperclassesAspect >> fieldValueFor: aClassModel [ 
	^ #()
]

{ #category : #accessing }
SuperclassesAspect >> firstClassModelRoles [
	^ #()
]

{ #category : #binding }
SuperclassesAspect >> innerBindingOf: aSymbol in: aClassModel [
	^ nil
]

{ #category : #'model build' }
SuperclassesAspect >> transformLanguageCustom: aLanguageModel [
	
]
