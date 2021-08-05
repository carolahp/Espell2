Class {
	#name : #ClassVarsAspect,
	#superclass : #PhAspect,
	#instVars : [
		'classModelClass',
		'languageModelClass'
	],
	#category : #Espell2Metamodel
}

{ #category : #'instance creation' }
ClassVarsAspect class >> for: aClassModelClass in: aLanguageModelClass [
	^ self basicNew 
		classModelClass: aClassModelClass;
		languageModelClass: aLanguageModelClass; 
		initialize;
		yourself.
]

{ #category : #'instance creation' }
ClassVarsAspect class >> new [
	self error: 'use >>for:'
]

{ #category : #initialization }
ClassVarsAspect >> adviceInitializeClass [
	^ PhAdvice new
		pointcut:
			(PhPointcut new
				receivers: classModelClass name;
				selectors: 'initialize';
				context: #(#receiver));
		advice: [ :context | 
			context receiver
				perform: self classVarsIVName , ':'
				with: Dictionary new ];
		type: #after
]

{ #category : #initialization }
ClassVarsAspect >> adviceTransformClass [
	| ivar getter |
	ivar := self classVarsIVName.
	getter := self varGetter: ivar.
	
	^ PhAdvice new
		pointcut:
			(PhPointcut new
				receivers: classModelClass name;
				selectors: 'transform';
				context: #(#receiver));
		advice: [ :context | 
			context receiver addLocalMethodFromSource: getter selector: ivar ];
		type: #before
]

{ #category : #initialization }
ClassVarsAspect >> adviceTransformLanguage [
	^ PhAdvice new
		pointcut:
			(PhPointcut new
				receivers: languageModelClass name;
				selectors: 'transform';
				context: #(#receiver));
		advice: [ :context | | dog |
			dog := context receiver ensureClassNamed: 'Dog'.
			dog classVars at: #Kingdom put: #animal ];
		type: #after
]

{ #category : #accessing }
ClassVarsAspect >> classModelClass: aClassModelClass [
	classModelClass := aClassModelClass
]

{ #category : #initialization }
ClassVarsAspect >> classModifier [
	| getter setter ivar |
	ivar := self classVarsIVName.
	getter := self varGetter: ivar.
	setter := self varSetter: ivar.
	
	^ PhClassModifier new
		on:
			(PhPointcut receivers: classModelClass name selectors: #any asParser);
		addNewInstanceVar: ivar;
		addNewInstanceMethod: getter;
		addNewInstanceMethod: setter;
		yourself
]

{ #category : #constants }
ClassVarsAspect >> classVarsIVName [
	^ #classPool
]

{ #category : #initialization }
ClassVarsAspect >> initialize [
	super initialize.
	self addClassModifier: self classModifier.
	self
		add: self adviceInitializeClass;
		add: self adviceTransformClass;
		add: self adviceTransformLanguage
]

{ #category : #'install-uninstall' }
ClassVarsAspect >> install [
	self assert: (classModelClass hasInstVarNamed: self classVarsIVName) not.
	super install.
	self assert: (classModelClass hasInstVarNamed: self classVarsIVName)
]

{ #category : #accessing }
ClassVarsAspect >> languageModelClass: aLanguageModelClass [
	languageModelClass := aLanguageModelClass
]

{ #category : #'install-uninstall' }
ClassVarsAspect >> uninstall [
	super uninstall.
	self assert: (classModelClass hasInstVarNamed: self classVarsIVName) not
]

{ #category : #constants }
ClassVarsAspect >> varGetter: var [
	^ var, ' 
	^ ' , var
]

{ #category : #constants }
ClassVarsAspect >> varSetter: var [
	^ var, ': anObject
	', var, ' := anObject'.
]
