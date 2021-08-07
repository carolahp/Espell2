Class {
	#name : #LanguageAspect,
	#superclass : #PhAspect,
	#instVars : [
		'modelClass',
		'fieldAspect'
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
			context receiver ensureClassNamed: 'Dog'.
			(context receiver classWithRole: fieldAspect modelClass role)
				addLocalMethodFromSource: fieldAspect fieldGetter
				selector: fieldAspect fieldName ];
		type: #after
]

{ #category : #'accessing aspects' }
LanguageAspect >> fieldAspect: anAspect [
	fieldAspect := anAspect 
	
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
