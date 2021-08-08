Class {
	#name : #LanguageAspect,
	#superclass : #PhAspect,
	#instVars : [
		'modelClass',
		'fieldAspects'
	],
	#category : #Espell2Metamodel
}

{ #category : #'instance creation' }
LanguageAspect class >> for: aClassModelClass [
	^ self basicNew 
		modelClass: aClassModelClass; 
		initialize;
		yourself.
]

{ #category : #'instance creation' }
LanguageAspect class >> new [
	self error: 'use >>for:'
]

{ #category : #advices }
LanguageAspect >> adviceAddClasses [
	^ PhAdvice new
		pointcut: self pcTransform;
		advice: [ :context | 
			| language dog |
			language := context receiver.
			dog := language ensureClassNamed: 'Dog'.
			dog addLocalMethodFromSource: 'kingdom 
			^ Kingdom' 
				selector: #kingdom.
			
			self fieldAspects
				do: [ :asp | 
					(language classWithRole: asp modelClass role)
						addLocalMethodFromSource: asp fieldMethodGetter
						selector: asp fieldName;
						addLocalMethodFromSource: asp fieldMethodSetter
						selector: asp fieldName,':' ] ];
		type: #after
]

{ #category : #'accessing aspects' }
LanguageAspect >> fieldAspects [
	^ fieldAspects
]

{ #category : #'accessing aspects' }
LanguageAspect >> fieldAspects: aCollection [
	aCollection do: [ :aspect | aspect getPointcuts isNotEmpty ].
	fieldAspects := aCollection
	
]

{ #category : #initialization }
LanguageAspect >> initialize [
	super initialize.
	self add: self adviceAddClasses.
	
]

{ #category : #pointcuts }
LanguageAspect >> modelClass [
	^ modelClass
]

{ #category : #pointcuts }
LanguageAspect >> modelClass: aLanguageModelClass [
	modelClass := aLanguageModelClass
]

{ #category : #pointcuts }
LanguageAspect >> pcTransform [
	^ PhPointcut new
		receivers: self modelClass name;
		selectors: 'transform';
		context: #('receiver')
]
