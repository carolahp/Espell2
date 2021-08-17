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

{ #category : #'instance creation' }
ClassVarAspect class >> demoEntryPoint [ 
	^ 'System log: Dog new kingdom asString.
		Dog new kingdom: #hola.
		System log: Dog new kingdom asString.
		System quit'
]

{ #category : #'instance creation' }
ClassVarAspect class >> expectedEntryPointResult [ 
	^ 'animal
hola'
]

{ #category : #accessing }
ClassVarAspect >> defaultFieldValue [
	^ Dictionary new
]

{ #category : #accessing }
ClassVarAspect >> fieldName [
	^ #classPool
]

{ #category : #accessing }
ClassVarAspect >> fieldValueFor: aClassModel [ 
	Exception signal
]

{ #category : #accessing }
ClassVarAspect >> firstClassModelRoles [
	^#()
]

{ #category : #binding }
ClassVarAspect >> innerBindingOf: aSymbol in: aClassModel [
	^ aClassModel classPool bindingOf: aSymbol
]

{ #category : #'model build' }
ClassVarAspect >> transformLanguageCustom: aLanguageModel [
	self
]
