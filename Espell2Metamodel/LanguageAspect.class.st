Class {
	#name : #LanguageAspect,
	#superclass : #PhAspect,
	#instVars : [
		'modelClass',
		'pcTransform'
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
			context receiver ensureClassNamed: 'Dog' ];
		type: #after
]

{ #category : #initialization }
LanguageAspect >> initialize [
	super initialize.
	self add: self adviceAddClasses 
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
	^ pcTransform
		ifNil: [ pcTransform := PhPointcut new
				receivers: self modelClass name;
				selectors: 'transform';
				context: #('receiver') ]
]
