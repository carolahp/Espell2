Class {
	#name : #ClassVarsAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #'as yet unclassified' }
ClassVarsAspect class >> buildDemoClassesIn: aLanguageModel [
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
ClassVarsAspect class >> demoEntryPoint [ 
	^ 'System log: Dog new kingdom asString.
		Dog new kingdom: #hola.
		System log: Dog new kingdom asString.
		System quit'
]

{ #category : #'instance creation' }
ClassVarsAspect class >> expectedEntryPointResult [ 
	^ 'animal
hola'
]

{ #category : #accessing }
ClassVarsAspect >> fieldName [
	^ #classPool
]

{ #category : #accessing }
ClassVarsAspect >> fieldValueFor: aClassModel [ 
	^ Dictionary new
]

{ #category : #accessing }
ClassVarsAspect >> firstClassModelRoles [
	^#()
]

{ #category : #binding }
ClassVarsAspect >> innerBindingOf: aSymbol in: aClassModel [
	^ aClassModel classPool bindingOf: aSymbol
]

{ #category : #'model build' }
ClassVarsAspect >> transformLanguageCustom: aLanguageModel [
	self
]
