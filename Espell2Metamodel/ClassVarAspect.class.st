Class {
	#name : #ClassVarAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #'as yet unclassified' }
ClassVarAspect class >> buildDemoClassesIn: aLanguageModel [
	| dog dogClassPool |
	dog := aLanguageModel ensureClassNamed: 'Dog'.
	dog
		addLocalMethodFromSource:
			'kingdom 
			^ Kingdom'
		selector: #kingdom.
	dog
		addLocalMethodFromSource:
			'kingdom: aString 
			Kingdom := aString'
		selector: #kingdom:.
	dogClassPool := {((ClassVariableModel named: #Kingdom parent: dog)
		initializationCode: '#animal')} asDictionary.
	dog classPool: dogClassPool
]

{ #category : #accessing }
ClassVarAspect >> defaultFieldValue [
	^ Dictionary new
]

{ #category : #accessing }
ClassVarAspect >> fieldName [
	^ #classPool
]

{ #category : #advices }
ClassVarAspect >> innerBindingOf: aSymbol in: aClassModel [
	^ aClassModel classPool bindingOf: aSymbol
]
